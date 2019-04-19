#!/usr/bin/env bash

echo "linking dotfiles"
working_dir=`pwd`
for dertferl in vimrc ackrc aliases gitignore tmux.conf; do
  mv -vf $HOME/.$dertferl{,.$(date +"%Y%m%d-%H%M%S").bak}
  ln -sv $working_dir/.$dertferl $HOME/.$dertferl
done

local OMZ="$HOME/.oh-my-zsh/themes" 
if [[ -d "$OMZ" ]]; then
  echo "copying zsh theme"
  local THEME="emojeezispentwaytoomuchtimeonthis.zsh-theme"
  ln -sv $working_dir/$THEME $OMZ/$THEME
fi

echo "making directory trees"
mkdir -pv "$HOME/Development/golang"

echo "setting up rc file"
rc_file=$(ls $HOME/.bashrc || ls $HOME/.zshrc || echo "$HOME/.bashrc")
echo "using rcfile $rc_file"
cp -vf $rc_file{,.$(date +"%Y%m%d-%H%M%S").bak}
cat *rc >> $rc_file

echo "installing common packages"
bash ./install_libs.sh

echo "installing vundler"
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
echo "installing vim plugins"
vim +BundleInstall +qall

# TODO: copy over .gitconfig.bak to .gitconfig, maybe prompt for username and email
# TODO: rbenv, rubybuild, ruby
# TODO: pyenv pyenv-virtualenv, python
# TODO: golang, possibly with https://github.com/syndbg/goenv
# TODO: nvm, node
