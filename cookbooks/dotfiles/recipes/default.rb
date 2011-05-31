#
#
# Cookbook Name:: dotfiles 
# Recipe:: default
#

template "#{ENV['HOME']}/.editrc" do
  source "dot_editrc.erb"
end

template "#{ENV['HOME']}/.inputrc" do
  source "dot_inputrc.erb"
end


template "#{ENV['HOME']}/.bash_profile" do
  source "bash_profile.erb"
end

template "#{ENV['HOME']}/.bashrc" do
  source "bashrc.erb"
end

if ENV['DONT_TOUCH_MY_VIMRC'].nil?
  template "#{ENV['HOME']}/.vimrc" do
    source "vimrc.erb"
  end
  
  directory "#{ENV['HOME']}/.vim" do
    action 'create'
  end
  
  directory "#{ENV['HOME']}/.vim/bundle" do
    action 'create'
  end
  
  remote_directory "#{ENV['HOME']}/.vim/bundle" do
    source "vim/bundle"
  end

  remote_directory "#{ENV['HOME']}/.vim" do
    source "vim"
  end
  
  directory "#{ENV['HOME']}/.vimswap" do
    action 'create'
  end

end

template "#{ENV['HOME']}/.autospec" do
  source "dot.autospec.erb"
end

script "install C ext. for Command-T vim plugin" do
  interpreter "bash"
  code <<-EOS
    source ~/.cinderella.profile
    cd ~/.vim/bundle/command-t/ruby/command-t
    rvm use system
    ruby extconf.rb
    make clean
    make
  EOS
end
