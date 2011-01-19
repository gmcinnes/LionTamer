LeopardTamer
============


Quick install
=============
[This script][gist] will:

* Install [chef][chef] on your machine under the ruby shipped with OS X
* Install [rvm][rvm] 
* Install ruby 1.9.2 and set it as default
* Install ruby 1.8.7-p302
* Install jruby-1.5.3
* Install a sane set of gems for each ruby
* Install a sane irbrc from a template
* Collect various information about your github account
* Install [git][git]
* Uninstall [macports][macports]
* Uninstall any existing [homebrew][homebrew] installs
* Install [homebrew][homebrew]
* Use homebrew to install useful utilties, such as markdown, wget, sqlite
  ctags-exuberant, bash-completion
* Use homebrew to Install mysql and populate it with MDI's
  standard throwaway user / pass
* Install macvim from its tarball
* Install a sane set of vim configs from a template

This script will not prompt before it does anything :)

First make sure [xcode is installed][xcode], then do:

    eval $"`curl https://gist.github.com/raw/647636/install_leopard_tamer.sh`"

[gist]:https://http://gist.github.com/raw/647636/install_leopard_tamer.sh
[xcode]:http://developer.apple.com/technologies/xcode.html
[chef]:http://www.opscode.com/chef/
[homebrew]:https://github.com/mxcl/homebrew
[rvm]:http://rvm.beginrescueend.com/
[macports]:http://www.macports.org/
[git]:http://git-scm.com/
