
# Check for an interactive session
[ -z "$PS1" ] && return

# Color aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Common aliases
alias more='less'
alias pp='sudo powerpill'

# Convenience aliases
alias srm='sudo rm'

# Prompt
PS1='[\u@\h \W]\$ '

# Tab completion for sudo
# Disabled because it also autocompletes filenames...
#complete -cf sudo

# Sets the editor to use
export EDITOR='emacs'

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
# online tools
alias t='tweet'
# editing
alias v='vim'
# misc
alias s='/home/jon/dev/snippets/Perl/stamp/stamp.pl'
alias f='fortune -asn 500'

export FORTUNES="computers debian linux magic"
export FORTUNES="futurama hitchhiker himym $FORTUNES"
export FORTUNES="montypython perl $FORTUNES"
export FORTUNES="science wisdom miscellaneous $FORTUNES"
export FORTUNES="off/atheism off/debian off/linux off/privates off/religion off/sex off/vulgarity $FORTUNES"
alias f='fortune -casn 500 $FORTUNES'
