begin
  require 'rubygems'

  task :install do |t, args|
    system("chef-solo -j config/run_list.json -c config/solo.rb")
  end
  task :cleanup do |t, args|
    %w(mysql).each do |server_type|
      system("launchctl unload -w ~/Library/LaunchAgents/*.#{server_type}*")
      system("ps auwwx | grep #{server_type} | awk '{print $2}' | xargs kill -9")
      system("rm ~/Library/LaunchAgents/*.#{server_type}*")
    end
  end
rescue LoadError => e
  puts e.message
  puts "You don't seem to have chef, installing it for you"
  system("sudo gem install chef --no-rdoc --no-ri")
  puts "I had to install chef for you, please rerun 'rake smeagol'"
end
