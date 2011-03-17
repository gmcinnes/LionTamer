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

    # Wait for mysql to come up
    fail_counter=0
    for (( ; ; ))
    do
      mysqladmin version 2>&1 | grep "Can't connect"
      if [ $? -eq 0 ]; then
        echo "Mysql not up yet"
        fail_counter=$(($fail_counter + 1))
      else
        echo "Mysql up now"
        break
      fi


      if [ $fail_counter -gt 60 ]; then
        echo "Couldn't connect to mysql"
        break
      fi

      sleep 1
    done 

    # Try a bunch of times to set a password
    mysqladmin -u root password 2>&1 | grep 'Access denied'
    if [ $? -eq 0 ]; then
      echo "Password already set"
    else
      echo "Setting password"
      mysqladmin -u root password #{THROWAWAY_PASSWORD} 2>&1
    fi
  EOS
end


