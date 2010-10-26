LeopardTamer
============


Quick install
=============
[This script][gist] will:

* Install [chef][chef] on your machine under the ruby shipped with OS X
* Collect various information about your github account
* Install rvm
* Install ruby 1.9.2 and set it as default
* Install ruby 1.8.7-p302
* Install jruby-1.5.3
* Install a sane set of gems for each ruby
* Install git
* Install homebrew
* Use homebrew to install useful utilties, such as markdown, wget, sqlite
  ctags-exuberant, bash-completion
* Use homebrew to Install mysql and populate it with MDI's
  standard throwaway user / pass
* Install a sane irbrc from a template
* Install a sane set of vim configs from a template
* Install macvim from its tarball

This script will not prompt before it does anything :)

First make sure [xcode is installed][xcode], then do:

    eval $"`curl http://gist.github.com/raw/647636/install_leopard_tamer.sh`"

[gist]:http://http://gist.github.com/raw/647636/install_leopard_tamer.sh
[xcode]:http://developer.apple.com/technologies/xcode.html
[chef]:http://www.opscode.com/chef/
