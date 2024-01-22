# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Be nice to sysadmins
if [ -f /etc/bashrc ]; then
  source /etc/bashrc
elif [ -f /etc/bash.bashrc ]; then
  source /etc/bash.bashrc
fi

# History management
export HISTCONTROL=ignoreboth
export HISTSIZE=5000
export HISTIGNORE="clear:bg:fg:cd:cd -:cd ..:exit:date:w:* --help:ls:l:ll:lll"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
