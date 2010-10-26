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
    # Break early if a password has been set
    mysqladmin -u root password 2>&1 | grep 'Access denied'
    if [ $? -eq 0 ]; then
      exit 0
    fi;

    # Try a bunch of times to set a password - if mysql has just
    # been restarted it might take it a while to come up
    fail_counter=0
    for (( ; ; ))
    do
      mysqladmin -u root password #{THROWAWAY_PASSWORD} 
      if [ $? -ne 0 ]; then
        fail_counter=$(($fail_counter + 1))
        sleep 1
      fi

      if [ $fail_counter -gt 60 ]; then
        echo "Couldn't connect to mysql"
        break
      fi
    done
  EOS
end


