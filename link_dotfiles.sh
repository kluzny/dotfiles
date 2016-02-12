#!/usr/bin/env bash
echo "don't forget to link your own .(bash|zsh)rc"
for dertferl in vimrc ackrc aliases gitignore tmux.conf; do
  mv -vf $HOME/.$dertferl{,.$(date +"%Y%m%d-%H%M%S").bak}
  ln -sv $HOME/dotfiles/.$dertferl $HOME/.$dertferl
done

local OMZ="$HOME/.oh-my-zsh/themes"
if [[ -d "$OMZ" ]]; then
  local THEME="emojeezispentwaytoomuchtimeonthis.zsh-theme"
  ln -sv $HOME/dotfiles/$THEME $OMZ/$THEME
fi
