#
# Cookbook Name:: gcc
# Recipe:: gcc 
#
script "download gcc"
  interpreter "bash"
  code <<-EOS
  curl -sSL https://github.com/downloads/kennethreitz/osx-gcc-installer/GCC-10.7-v2.pkg > /tmp/gcc.pkg
  installer -package /tmp/gcc.pkg -target /
  EOS
  end
end
