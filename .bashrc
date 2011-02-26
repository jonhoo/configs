
# Check for an interactive session
[ -z "$PS1" ] && return

# Color aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Common aliases
alias more='less'

# Convenience aliases
alias srm='sudo rm'
alias l='ls -la'

# Prompt
source /usr/share/git/completion/git-completion.bash
# For unstaged(*) and staged(+) values next to branch name in __git_ps1
GIT_PS1_SHOWDIRTYSTATE="enabled"

PS1="\[\e[2;37m\][\A] \[\e[0;33m\]\u\[\e[0m\]@\[\e[34m\]\h \[\e[32m\]\w\[\e[35m\]\`__git_ps1\` \[\e[31m\]\$\[\e[0m\] "

# Tab completion for sudo
# Disabled because it also autocompletes filenames...
#complete -cf sudo

# Sets the editor to use
export EDITOR='emacs'
export BROWSER='chromium'

# Add local bins to path
export PATH="$PATH:/usr/local/bin"
export CLASSPATH="$CLASSPATH:."

# Other aliases
# make
alias ,='make'
alias ,,='/home/jon/dev/makefiles/makeMakefile.pl'
# git
alias .='git pull'
alias ..='git push'
# file handlers
alias o='mimeopen'
# update commands
alias p="sudo powerpill"
alias y="yaourt"
alias up="yaourt -Syu --aur"
# online tools
alias t='tweet'
# editing
alias v='vim'
# misc
alias s='/home/jon/dev/snippets/Perl/stamp/stamp.pl'
alias f='fortune -asn 500'
# Safe
alias mv='mv -i'

export FORTUNES="computers debian linux magic"
export FORTUNES="futurama hitchhiker himym $FORTUNES"
export FORTUNES="montypython perl $FORTUNES"
export FORTUNES="science wisdom miscellaneous $FORTUNES"
export FORTUNES="off/atheism off/debian off/linux off/privates off/religion off/sex off/vulgarity $FORTUNES"
alias f='fortune -casn 500 $FORTUNES'
