#
# Cookbook Name:: git
# Recipe:: default
#
root = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "homebrew"))
require root + '/resources/homebrew'
require root + '/providers/homebrew'
require 'etc'

module GitInfoHelpers

  def get_parameter_from_gitconfig(name)
    config = File.read("#{ENV['HOME']}/.gitconfig")
    matches = config.match /^ *#{name} *= *(.*)$/
    matches[1].strip rescue nil
  end

  def gitconfig_exists?
    File.exist?("#{ENV['HOME']}/.gitconfig")
  end

  def populate_parameters
    @__email = get_parameter_from_gitconfig('email')
    @__name  = get_parameter_from_gitconfig('name')
    @__user  = get_parameter_from_gitconfig('user')
    @__token = get_parameter_from_gitconfig('token')
    @__editor = get_parameter_from_gitconfig('editor')
  end

  def parameters_all_populated?
    populate_parameters
    @__email && @__name && @__user && @__token && @__editor
  end

  def wants_to_use_gitconfig?
    puts "Use existing ~/.gitconfig variables for configuring git?"
    puts "Your current variables are:"
    puts "Email: #{@__email}"
    puts "Full Name: #{@__name}"
    puts "Github User Name: #{@__user}"
    puts "Github API Token: #{@__token}"
    puts "Editor: #{@__editor}"
    puts ""
    puts "(Y/N): "
    choice = $stdin.gets.strip.upcase
    choice == "Y" 
  end


  def collect_parameters
    puts ""
    puts "Enter your work email: "
    @__email = $stdin.gets.strip
    puts ""
    puts "Enter your full name: "
    @__name = $stdin.gets.strip
    puts ""
    puts "Enter your github user name: "
    @__user = $stdin.gets.strip
    puts ""
    puts "Enter your github token: "
    @__token = $stdin.gets.strip
    puts ""
    @__editor = "/usr/bin/vim"
  end
end

template "#{ENV['HOME']}/.gitconfig" do
  include GitInfoHelpers

  mode   0700
  owner  ENV['USER']
  group  Etc.getgrgid(Process.gid).name
  source "dot.gitconfig.erb"
  if gitconfig_exists? && 
     parameters_all_populated? && 
     wants_to_use_gitconfig?
     nil # We already have the parameters if we got this far 
  else
    collect_parameters 
  end
  
  variables({
    :home         => ENV['HOME'],
    :user         => @__name,
    :email        => @__email,
    :github_user  => @__github_user,
    :github_token => @__token,
    :editor       => @__editor,
    :fullname     => @__name
  })
end

template "#{ENV['HOME']}/.gitignore" do
  source "dot.gitignore.erb"
end
