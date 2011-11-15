require 'pp'
require 'chef/provider'

class Chef
  class Provider
    class Package
      class Homebrew < ::Chef::Provider::Package
        PREFIX   = "`brew --prefix`"
        HOMEBREW = "#{PREFIX}/bin/brew"

        def latest_version_for(name)
          %x{#{HOMEBREW} info #{name}| head -n1 | awk '{print $2}'}.chomp
        end

        def load_current_resource
          @current_resource = Chef::Resource::Homebrew.new(@new_resource.name)
          @current_resource.package_name(@new_resource.name)
          @candidate_version = latest_version_for(@new_resource.name)
          @current_resource
        end

        def install_package(name, version)
          run_brew_command("#{HOMEBREW} install --force #{name}")
        end

        def remove_package(name, version)
          run_brew_command("#{HOMEBREW} uninstall #{name}")
        end

        def run_brew_command(command)
          Chef::Log.debug(command)
          run_command_with_systems_locale(
            :command => command,
            :ignore_failure => true
          )
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
