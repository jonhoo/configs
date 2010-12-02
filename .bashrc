
# Check for an interactive session
[ -z "$PS1" ] && return

# Color aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Common aliases
alias more='less'

# Convenience aliases
alias svim='sudo vim'
alias srm='sudo rm'

# Prompt
PS1='[\u@\h \W]\$ '

# Tab completion for sudo
# Disabled because it also autocompletes filenames...
#complete -cf sudo

# Sets the editor to use
export EDITOR='vim'

# Add local bins to path
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:/home/jon/bin/sal/bin"
export CLASSPATH="$CLASSPATH:."
export CLASSPATH="$CLASSPATH:/usr/lib/junit.jar"
export CLASSPATH="$CLASSPATH:/usr/share/java/emma.jar"

# Other aliases
# make
alias ,='make'
alias ,,='/home/jon/dev/makefiles/makeMakefile.pl'
# git
alias .='git pull'
alias ..='git push'
# file handlers
alias o='xdg-open'
# update commands
alias p="powerpill"
alias y="yaourt"
# online tools
alias t='tweet'
# misc
alias s='/home/jon/dev/snippets/Perl/stamp/stamp.pl'
alias f='fortune -asn 500'
alias f='fortune -casn 500 /usr/share/fortune/{chucknorris,computers,debian,himym,linux,linuxcookie,magic,matrix,men-women,miscellaneous,off/atheism,off/black-humor,off/cookie,off/debian,off/limerick,off/linux,off/misandry,off/miscellaneous,off/misogyny,off/privates,off/religion,off/riddles,off/sex,off/vulgarity,perl,riddles,science,startrek,wisdom}'
