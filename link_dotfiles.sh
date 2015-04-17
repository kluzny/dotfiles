#!/usr/bin/env bash
for dertferl in zshrc vimrc ackrc aliases gitignore; do
  mv -vf $HOME/.$dertferl{,.$(date +"%Y%m%d-%H%M%S").bak}
  ln -sv $HOME/dotfiles/.$dertferl $HOME/.$dertferl
done
