
# Check for an interactive session
[ -z "$PS1" ] && return

# Color aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Common aliases
alias more='less'
alias svim='sudo vim'
alias srm='sudo rm'

# Prompt
PS1='[\u@\h \W]\$ '

# Tab completion for sudo
#complete -cf sudo

export EDITOR='vim'
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:/home/jon/bin/sal/bin"
export CLASSPATH="$CLASSPATH:."
export CLASSPATH="$CLASSPATH:/usr/lib/junit.jar"
export CLASSPATH="$CLASSPATH:/usr/share/java/emma.jar"

alias ,='make'
alias ,,='/home/jon/dev/makefiles/makeMakefile.pl'
alias .='git pull'
alias ..='git push'
alias o='xdg-open'
alias yu='yaourt -Syu --aur'
alias pu='sudo powerpill -Syu'
alias yi='yaourt -S'
alias t='tweet'
alias f='fortune -asn 500'
alias f='fortune -casn 500 /usr/share/fortune/{chucknorris,computers,debian,himym,linux,linuxcookie,magic,matrix,men-women,miscellaneous,off/atheism,off/black-humor,off/cookie,off/debian,off/limerick,off/linux,off/misandry,off/miscellaneous,off/misogyny,off/privates,off/religion,off/riddles,off/sex,off/vulgarity,perl,riddles,science,startrek,wisdom}'
alias s='/home/jon/dev/snippets/Perl/stamp/stamp.pl'
