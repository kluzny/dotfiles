#!/usr/bin/env bash
for dertferl in zshrc vimrc ackrc aliases gitignore; do
  ln -sv $HOME/.$dertferl $HOME/.$dertferl
done
