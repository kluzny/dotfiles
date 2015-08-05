#!/usr/bin/env bash
pkg_manager=$(which yum | which apt-get);
echo "installing vim"
sudo $pkg_manager -y install vim

echo "linking dotfiles"
bash ./link_dotfiles.sh

echo "installing vundler"
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
echo "installing vim plugins"
vim +BundleInstall +qall

echo "setting up (bash|zsh)rc file"
rc_file=$(ls $HOME/.bashrc || ls $HOME/.zshrc || echo "$HOME/.bashrc")
echo "using rcfile $rc_file"

aliases_added=$(grep ".aliases" $rc_file)
if [[ -z "$aliases_added" ]]; then
  echo "adding aliases file to $rc_file"
  echo 'source $HOME/.aliases' >> $rc_file
  source $rc_file
fi
