#!/usr/bin/env bash

# echo "linking dotfiles"
# working_dir=`pwd`
# for dertferl in vimrc ackrc aliases gitignore tmux.conf; do
#   mv -vf $HOME/.$dertferl{,.$(date +"%Y%m%d-%H%M%S").bak}
#   ln -sv $working_dir/.$dertferl $HOME/.$dertferl
# done

# echo "setting up rc file"
# rc_file=.bashrc
# cp -vf $rc_file{,.$(date +"%Y%m%d-%H%M%S").bak}
# cat *rc >> $rc_file

# bash ./install_libs.sh
# bash ./install_vundler.sh
# bash ./install_rebenv.sh
# bash ./install_bash_git_prompt.sh
# bash ./install_rush.sh

# TODO: copy over .gitconfig.bak to .gitconfig, maybe prompt for username and email
# TODO: ruby
# TODO: rust
# TODO: nvm, nod
# TODO: pyenv pyenv-virtualenv, python
# TODO: golang
# TODO: docker
