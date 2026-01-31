#!/usr/bin/env bash

echo "installing bash-git-prompt"
git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1

timestamp=`date`
tee -a ~/.bashrc << END

# Added by \`install_bash_git_prompt.sh\` on $timestamp
if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    GIT_PROMPT_END=" \$ "
    source "$HOME/.bash-git-prompt/gitprompt.sh"
fi
END
