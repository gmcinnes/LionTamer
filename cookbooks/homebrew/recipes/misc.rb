#
# Cookbook Name:: homebrew
# Recipe:: dbs
#

root = File.expand_path(File.join(File.dirname(__FILE__), ".."))

require root + '/resources/homebrew'
require root + '/providers/homebrew'

%w(tig ack imagemagick sqlite wget hub fortune proctools markdown ctags-exuberant bash-completion memcached pow).each do |pkg|
  homebrew pkg
end


template "#{ENV['HOME']}/.cinderella.profile.custom" do
  mode 0700
  owner ENV['USER']
  group Etc.getgrgid(Process.gid).name
  source "dot.profile.custom.erb"
end
