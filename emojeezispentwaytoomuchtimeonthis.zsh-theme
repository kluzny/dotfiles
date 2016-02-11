# Thanks to gallifrey, upon whose theme this is based
# Thanks to strug and lukerandall as well

# export CLICOLOR=1
# export LSCOLORS=dxFxCxDxBxegedabagacad

function my_git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  GIT_STATUS=$(git_prompt_status)
  [[ -n $GIT_STATUS ]] && GIT_STATUS=" $GIT_STATUS"
  echo "$BRANCH$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$GIT_STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function my_git_remote_status() {
  GIT_REM_STATUS=$(git_remote_status)
  [[ -n $GIT_REM_STATUS ]] && GIT_REM_STATUS=" $GIT_REM_STATUS"
  echo "${${GIT_REM_STATUS/\(/}/\)/}"
}

local git_branch='$(my_git_prompt_info)%{$reset_color%}$(my_git_remote_status)'

START="ॐ  "
AT_SIGN=" 🌍  "
SYMBOL=" ☠  "
BRANCH=" 🌴  "
CLOUD="☁ "
LOCATION="💾 "

# traditional
# PROMPT="$fg_bold[white]$START$reset_color$fg[blue]%n$AT_SIGN$reset_color$fg[cyan]%m$LOCATION$reset_color$fg_bold[cyan]%2~ $git_branch$reset_color%B$SYMBOL%b"

# slim
PROMPT=""\
"%{$fg_bold[white]%}$START%{$reset_color%}"\
"%{$fg[cyan]%}%2~%{$reset_color%}"\
"$git_branch%{$reset_color%}"\
"%B$SYMBOL%b"

RPS1="%{$fg_bold[red]%}$(DATE) ☢  $?%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="💾 "
ZSH_THEME_GIT_PROMPT_ADDED="💩 "
ZSH_THEME_GIT_PROMPT_UNTRACKED="⚡ "
ZSH_THEME_GIT_PROMPT_MODIFIED=""
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[green]%}♻ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="🔥 "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[white]%}☯ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_DETAILED=true
ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_PREFIX="%{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_SUFFIX="%{$fg[yellow]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE=" 🚀  "
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR=%{$fg[green]%}
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE=" 🐌  "
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR=%{$fg[red]%}
