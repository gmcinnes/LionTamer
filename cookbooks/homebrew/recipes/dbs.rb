#
# Cookbook Name:: homebrew
# Recipe:: dbs
#

root = File.expand_path(File.join(File.dirname(__FILE__), ".."))

require root + '/resources/homebrew'
require root + '/providers/homebrew'
THROWAWAY_PASSWORD = 'spamhead'
homebrew_db "mysql"

script "Setting mysql root user to have MDI throwaway password" do
  interpreter "bash"
  code <<-EOS
    source ~/.cinderella.profile
    # Try a bunch of times to set a password - if mysql has just
    # been restarted it might take it a while to come up
    fail_counter=0
    for (( ; ; ))
    do
      # Break early if a password has been set
      mysqladmin -u root password 2>&1 | grep 'Access denied'
      if [ $? -ne 0]; then
        echo "Password already set"
        break; 
      fi

      # Try and set the password. Increment fail counter if
      # we can't set the pword
      mysqladmin -u root password #{THROWAWAY_PASSWORD} 
      if [ $? -ne 0 ]; then
        fail_counter=$(($fail_counter + 1))
      fi

      if [ $fail_counter -gt 60 ]; then
        echo "Couldn't connect to mysql"
        break
      fi
      sleep 1 
    done
  EOS
end


