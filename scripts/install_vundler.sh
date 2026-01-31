#!/usr/bin/env bash

echo "installing vundler"
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
echo "installing vim plugins"
vim +BundleInstall +qall