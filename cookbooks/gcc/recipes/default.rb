#
# Cookbook Name:: gcc
# Recipe:: gcc 


script "download gcc" do
  interpreter "bash"
  puts "Downloading and installing GCC.  This will take a while"
  code <<-EOS
    if [ `which gcc` == ""]; then
      curl -sSL https://github.com/downloads/kennethreitz/osx-gcc-installer/GCC-10.7-v2.pkg > /tmp/gcc.pkg
      sudo installer -package /tmp/gcc.pkg -target /
      if [ `which gcc` != ""]; then
        rm /tmp/gcc.pkg
      else
        exit 127
      fi
    fi
  EOS
end
