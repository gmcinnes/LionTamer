# Chef package provider for Homebrew

require 'chef/provider/package'
require 'chef/resource/package'
require 'chef/platform'

class Chef
  class Provider
    class Package
      class Homebrew < Package
        def load_current_resource
          @current_resource = Chef::Resource::Package.new(@new_resource.name)
          @current_resource.package_name(@new_resource.package_name)
          @current_resource.version(current_installed_version)

          @current_resource
        end

        def install_package(name, version)
          brew('install', name)
        end

        # Homebrew doesn't really have a notion of upgrading packages, just
        # install the latest version?
        def upgrade_package(name, version)
          install_package(name, version)
        end

        def remove_package(name, version)
          brew('uninstall', name)
        end

        # Homebrew doesn't really have a notion of purging, so just remove.
        def purge_package(name, version)
          remove_package(name, version)
        end

        protected
        def brew(*args)
          run_command_with_systems_locale(
            :command => "brew #{args.join(' ')}"
          )
        end

        def current_installed_version
          get_version_from_command("brew list --versions | awk '/^#{@new_resource.package_name} / { print $2 }'")
        end

        def candidate_version
          get_version_from_command("brew info #{@new_resource.package_name} | awk '/^#{@new_resource.package_name} / { print $2 }'")
        end

        def get_version_from_command(command)
          version = get_response_from_command(command).chomp
          version.empty? ? nil : version
        end

        # Nicked from lib/chef/package/provider/macports.rb and tweaked
        # slightly.
        def get_response_from_command(command)
          output = nil
          status = popen4(command) do |pid, stdin, stdout, stderr|
            begin
              output = stdout.read
            rescue Exception => e
              raise Chef::Exceptions::Package, "Could not read from STDOUT on command: #{command}\nException: #{e.inspect}"
            end
          end
          unless (0..1).include? status.exitstatus
            raise Chef::Exceptions::Package, "#{command} failed - #{status.inspect}"
          end
          output
        end
      end
      
      class HomebrewDb < Homebrew
        def plist_for(name)
          { "mysql"      => "com.mysql.mysqld.plist" }[name]
        end

        def plist_fullpath_for(name)
          "#{PREFIX}/Cellar/#{name}/#{latest_version_for(name)}/#{plist_for(name)}"
        end

        def load_plist_for(name)
          Chef::Log.info("Configuring #{name} to automatically start on login")
          destination_plist = "#{ENV['HOME']}/Library/LaunchAgents/#{plist_for(name)}"
          system("mkdir -p #{ENV['HOME']}/Library/LaunchAgents")
          system("launchctl unload -w -F #{destination_plist}")
          system("cp -f #{plist_fullpath_for(name)} #{destination_plist}")
          system("launchctl load -w -F #{destination_plist}")
        end

        def install_package(name, version)
          super(name, version)
          case name
          when "mysql"
            unless ::File.directory?("#{PREFIX}/var/mysql")
              system("#{PREFIX}/Cellar/mysql/#{latest_version_for(name)}/bin/mysql_install_db > /dev/null")
            end

            # Hack around the change in data directory from mysql 5.1.x
            # to 5.5.x
            case version
            when "5.5.10"
              system("cd #{PREFIX}/Cellar/mysql/5.5.10/ && scripts/mysql_install_db --basedir=#{PREFIX}/Cellar/mysql/5.5.10 --tmpdir=/tmp")
            end

          else
            raise "Unknown Homebrew DB: #{name}"
          end

          load_plist_for(name)
        end
      end

    
    end
  end
end

Chef::Platform.set :platform => :mac_os_x, :resource => :package, :provider => Chef::Provider::Package::Homebrew
