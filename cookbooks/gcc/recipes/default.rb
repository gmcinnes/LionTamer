#
# Cookbook Name:: gcc
# Recipe:: gcc 

dmg_package "GCC-10.7.v2.pkg" do
  source "https://github.com/downloads/kennethreitz/osx-gcc-installer/GCC-10.7-v2.pkg"
  type "mpkg"
  action :install
end

# script "download gcc" do
#   interpreter "bash"
#   puts "Downloading and installing GCC.  This will take a while"
#     #curl -sSL https://github.com/downloads/kennethreitz/osx-gcc-installer/GCC-10.7-v2.pkg > /tmp/gcc.pkg
#   code <<-EOS
#     sudo installer -package /tmp/gcc.pkg -target /
#   EOS
# end
