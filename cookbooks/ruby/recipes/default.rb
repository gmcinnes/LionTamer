#
# Cookbook Name:: ruby
# Recipe:: default
#

DEFAULT_RUBY_VERSION = "1.9.2-p180"
RUBY_1_8_7 = "1.8.7-p334"
JRUBY_1_5_3 = "jruby-1.5.3"

script "installing rvm to ~/Developer" do
  interpreter "bash"
  code <<-EOS
    source ~/.cinderella.profile
    if [[ ! -d ~/Developer/.rvm ]]; then
      rm -rf rvm
      git clone https://github.com/wayneeseguin/rvm.git rvm
      cd rvm
      ./install --prefix #{ENV['HOME']}/Developer/. >> ~/.cinderella.log 2>&1
    fi
  EOS
end

script "updating rvm to the latest stable version" do
  interpreter "bash"
  code <<-EOS
    source ~/.cinderella.profile
    rvm reload
    rvm update -—head >> ~/.cinderella.log 2>&1
  EOS
end

template "#{ENV['HOME']}/Developer/.rvm/gemsets/default.gems" do
  source "default.gems.erb"
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
    `rvm list | grep -q '#{JRUBY_1_5_3}'`
    if [ $? -ne 0 ]; then
      rvm install #{JRUBY_1_5_3}
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

execute "cleanup rvm build artifacts" do
  command "find ~/Developer/.rvm/src -depth 1 | grep -v src/rvm | xargs rm -rf "
end

template "#{ENV['HOME']}/.gemrc" do
  source "dot.gemrc.erb"
end

template "#{ENV['HOME']}/.rdebugrc" do
    source "dot.rdebugrc.erb"
end
