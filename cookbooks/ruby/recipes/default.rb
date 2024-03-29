#
# Cookbook Name:: ruby
# Recipe:: default
#
include_recipe "homebrew"

DEFAULT_RUBY_VERSION = "1.9.2"
RUBY_1_8_7 = "1.8.7"
JRUBY = "jruby"

script "installing rvm" do
  interpreter "bash"
  code <<-EOS
    source ~/.cinderella.profile
  
   if [ `which rvm` != 0]; then
     if [[ -d ~/.rvm ]]; then
        rm -rf ~/.rvm
     fi 

     if [[ -d ~/.rvmrc ]]; then
        rm -rf ~/.rvmrc
     fi

     if [[ -f ~/.rvmrc ]]; then
        rm -rf ~/.rvmrc
     fi

     bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )
     echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> ~/.cinderella.profile
    fi 
  EOS
end

# Tell us about the default gems
template "#{ENV['HOME']}/.rvm/gemsets/default.gems" do
  source "default.gems.erb"
end

# And gemrc
template "#{ENV['HOME']}/.gemrc" do
  source "dot.gemrc.erb"
end

# And debugger
template "#{ENV['HOME']}/.rdebugrc" do
    source "dot.rdebugrc.erb"
end

# And irb
template "#{ENV['HOME']}/.irbrc" do
    source "dot.irbrc.erb"
end

script "updating rvm to the latest stable version" do
  interpreter "bash"
  code <<-EOS
    source ~/.cinderella.profile
    rvm reload
    rvm get head >> ~/.cinderella.log 2>&1
  EOS
end


script "installing ruby 1.9.2" do
  interpreter "bash"
  code <<-EOS
    source ~/.cinderella.profile
    `rvm list | grep -q '#{DEFAULT_RUBY_VERSION}'`
    if [ $? -ne 0 ]; then
      rvm install #{DEFAULT_RUBY_VERSION}
    fi
  EOS
end

script "installing ruby 1.8.7" do
  interpreter "bash"
  code <<-EOS
    source ~/.cinderella.profile
    `rvm list | grep -q '#{RUBY_1_8_7}'`
    if [ $? -ne 0 ]; then
      rvm install #{RUBY_1_8_7}
    fi
  EOS
end

script "installing jruby 1.5.3"  do
  interpreter "bash"
  code <<-EOS
    source ~/.cinderella.profile
    `rvm list | grep -q '#{JRUBY}'`
    if [ $? -ne 0 ]; then
      rvm install #{JRUBY}
    fi
  EOS
end

script "ensuring a default ruby is set" do
  interpreter "bash"
  code <<-EOS
    source ~/.cinderella.profile
    rvm use #{DEFAULT_RUBY_VERSION} --default
  EOS
end

