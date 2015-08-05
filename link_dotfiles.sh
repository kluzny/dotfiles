#!/usr/bin/env bash
echo "don't forget to link your own .(bash|zsh)rc"
for dertferl in vimrc ackrc aliases gitignore; do
  mv -vf $HOME/.$dertferl{,.$(date +"%Y%m%d-%H%M%S").bak}
  ln -sv $HOME/dotfiles/.$dertferl $HOME/.$dertferl
done
