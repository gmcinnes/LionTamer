#
# Cookbook Name:: dotfiles 
# Recipe:: default
#


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

  remote_directory "#{ENV['HOME']}/vim" do
    source "vim"
  end
  
  directory "#{ENV['HOME']}/.vimswap" do
    action 'create'
  end

end

template "#{ENV['HOME']}/.autospec" do
  source "dot.autospec.erb"
end

script "installed macvim from github" do
  interpreter "bash"
  code <<-EOS
    source ~/.cinderella.profile
    if [ ! -e ~/Developer/bin/mvim ]; then
      rm -rf /Applications/MacVim.app
      curl -L http://github.com/downloads/b4winckler/macvim/MacVim-snapshot-55.tbz -o - | tar -xvf -
      cd MacVim-snapshot-55
      cp mvim ~/Developer/bin
      cp -r MacVim.app /Applications/
    fi
  EOS
end
