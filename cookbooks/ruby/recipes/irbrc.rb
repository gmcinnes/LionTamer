#
# Cookbook Name:: ruby
# Recipe:: irbrc
#
include_recipe "homebrew"

template "#{ENV['HOME']}/.irbrc" do
  source "dot.irbrc.erb"
end
