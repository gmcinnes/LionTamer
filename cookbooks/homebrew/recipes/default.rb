#
# Cookbook Name:: homebrew
# Recipe:: homebrew
#

root = File.expand_path(File.join(File.dirname(__FILE__), ".."))

require root + '/resources/homebrew'
require root + '/providers/homebrew'
require 'etc'

directory "#{ENV['HOME']}/Developer" do
  action :create
end

script "remove old homebrew" do
  interpreter "bash"
  code <<-EOS
    if [ "`which brew`" != "" ] &&  [ "`which brew`" != "#{ENV['HOME']}/Developer/bin/brew" ]; then
      cd `brew --prefix`
      rm -rf Cellar
      brew prune
      rm -rf Library .git .gitignore bin/brew README.md share/man/man1/brew
      rm -rf ~/Library/Caches/Homebrew
    fi
  EOS
end

script "remove old macports" do
  interpreter "bash"
  code <<-EOS
    if [ "`which port`" != "" ]; then
      sudo port -f uninstall installed
      sudo rm -rf \
      /opt/local \
      /Applications/DarwinPorts \
      /Applications/MacPorts \
      /Library/LaunchDaemons/org.macports.* \
      /Library/Receipts/DarwinPorts*.pkg \
      /Library/Receipts/MacPorts*.pkg \
      /Library/StartupItems/DarwinPortsStartup \
      /Library/Tcl/darwinports1.0 \
      /Library/Tcl/macports1.0 \
      ~/.macports
    fi
  EOS
end

execute "download homebrew installer" do
  command "mkdir -p ~/Developer"
  command "/usr/bin/curl -sfL https://github.com/mxcl/homebrew/tarball/master | /usr/bin/tar xz -m --strip 1 -C ~/Developer"
  cwd     "#{ENV['HOME']}/Developer"
  not_if  "test -e ~/Developer/bin/brew"
end

script "install_something" do
  interpreter "bash"
  code <<-EOS
  if [ -f ~/.cider.profile ]; then
    rm ~/.cider.profile
  fi
  if [ -f ~/.cider.profile.custom ]; then
    mv ~/.cider.profile.custom ~/.cinderella.profile.custom
  fi
  EOS
end

template "#{ENV['HOME']}/.cinderella.profile" do
  mode   0700
  owner  ENV['USER']
  group  Etc.getgrgid(Process.gid).name
  source "dot.profile.erb"
  variables({ :home => ENV['HOME'] })
end

%w(bash_profile bashrc).each do |config_file|
  execute "include cinderella environment into defaults for ~/.#{config_file}" do
    command "if [ -f ~/.#{config_file} ]; then echo 'source ~/.cinderella.profile' >> ~/.#{config_file}; fi"
    not_if  "grep -q 'cinderella.profile' ~/.#{config_file}"
  end
end

execute "setup cinderella profile sourcing in ~/.profile" do
  command "echo 'source ~/.cinderella.profile' >> ~/.profile"
  not_if  "grep -q 'cinderella.profile' ~/.profile"
end

execute "install git" do
  command "brew install git"
  not_if "test -e ~/Developer/bin/git"
end

script "updating homebrew from github" do
  interpreter "bash"
  code <<-EOS
    source ~/.cinderella.profile
    PATH=#{ENV['HOME']}/Developer/bin:$PATH; export PATH
    ~/Developer/bin/brew update >> ~/.cinderella.log 2>&1
  EOS
end
