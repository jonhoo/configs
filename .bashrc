# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Color aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Common aliases
alias more='less'

# Convenience aliases
alias srm='sudo rm'
alias lll='ls -la'
alias ll='ls -l'
alias l='ls'
alias run='sudo systemctl start'
alias x='sudo netcfg'
alias gc='git checkout'
alias gs='git status'
alias ca='git commit -a -m'
alias xt='date +%s'
if [ -e "$HOME/.local/bashrc" ]; then
  source "$HOME/.local/bashrc"
fi

#h5bp
alias b='cd build;ant build;cd ..'

# Seriex!
if [ -e /home/jon/dev/seriex/seriex.pl ]; then
  echo -e '\e[2;37mbtw: seriex available...\e[0m';
  alias sx='/home/jon/dev/seriex/seriex.pl'
fi

# Smore!
if [ -e /home/jon/dev/smore/smore.pl ]; then
  echo -e '\e[2;37mbtw: smore available...\e[0m';
  alias sc='/home/jon/dev/smore/smore.pl'
fi

# IMDb lookup!
if [ -e /home/jon/dev/imdb-lookup/imdb.pl ]; then
  echo -e '\e[2;37mbtw: imdb available...\e[0m';
  alias il='/home/jon/dev/imdb-lookup/imdb.pl'
fi

PS1='\[\e[2;37m\][\A] \[\e[0;33m\]\u\[\e[0m\]@\[\e[34m\]\h \[\e[32m\]\w'

# Prompt
if [ -e /usr/share/git/completion/git-prompt.bash ]; then
    source /usr/share/git/completion/git-prompt.bash
    # For unstaged(*) and staged(+) values next to branch name in __git_ps1
    GIT_PS1_SHOWDIRTYSTATE="enabled"
    PS1=$PS1'\[\e[35m\]`__git_ps1`'
else
    echo -e '\e[2;37mbtw: enabling git completion in prompt...\e[0m';
fi

PS1=$PS1' \[\e[31m\]\$\[\e[0m\] '

# Prompt command (for SSH window titles)
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'

# Ant
if [ -e /etc/profile.d/apache-ant.sh ]; then
    source /etc/profile.d/apache-ant.sh
fi

# Solarized ls
if [ -e .dir_colors ]; then
    eval `dircolors .dir_colors`
else
    echo -e '\e[2;37mbtw: no dircolors available...\e[0m';
fi

# Tab completion for sudo
# Disabled because it also autocompletes filenames...
#complete -cf sudo

# Don't autocomplete to hidden directories
bind 'set match-hidden-files off'

# Bookmarks
if [ -f ~/.local/bin/bashmarks.sh ]; then
    source ~/.local/bin/bashmarks.sh;
fi

# Sets the editor to use
export EDITOR='vim'
if [ -e "/usr/bin/opera-next" ]; then
  export BROWSER='opera-next'
else
  export BROWSER='chromium'
fi

if [ "$TERM" == "rxvt-unicode-256color" -a ! -e "/usr/share/terminfo/r/$TERM" ]; then
  if [ -e "/usr/share/terminfo/r/rxvt-256color" ]; then
    export TERM='rxvt-256color';
  else
    echo -e '\e[2;37mbtw: rxvt not supported, faking vt100...\e[0m';
    export TERM='vt100';
  fi
fi

# Add local bins to path
export PATH="$PATH:/usr/local/bin"
if [ -e "/home/jon/.cabal/bin/" ]; then
  export PATH="$PATH:/home/jon/.cabal/bin/"
fi
export CLASSPATH="$CLASSPATH:."

if [ -e /usr/share/java ]; then
    export CLASSPATH="$CLASSPATH:/usr/share/java"
fi

# History management
export HISTCONTROL=ignoreboth
export HISTSIZE=2000
export HISTIGNORE="clear:bg:fg:cd:cd -:cd ..:exit:date:w:* --help:ls:l:ll:lll"

# Other aliases
# make
alias ,='make'
alias ,,='/home/jon/dev/makefiles/makeMakefile.pl'
# file handlers
alias o='xdg-open'
# update command
UP="sudo"
if [ -e /usr/bin/powerpill ]; then
    UP="$UP powerpill"
else
    if [ -e /usr/bin/pacman-color ]; then
        UP="$UP pacman-color"
    else
        UP="$UP pacman"
    fi
fi
alias p="$UP"
alias y="yaourt"
if [ -e /usr/bin/yaourt ]; then
    alias up="yaourt -Syu --aur"
else
    alias up="$UP -Syu"
fi
# online tools
alias t='tweet'
alias tsp='ssh -C jon@thesquareplanet.com'
# editing
alias v='vim'
# misc
alias stamp='/home/jon/dev/snippets/Perl/stamp/stamp.pl'
alias f='fortune -asn 500'
# Safe
alias mv='mv -i'

export FORTUNES="computers debian linux magic"
export FORTUNES="futurama hitchhiker himym $FORTUNES"
export FORTUNES="montypython perl $FORTUNES"
export FORTUNES="science wisdom miscellaneous $FORTUNES"
export FORTUNES="off/atheism off/debian off/linux off/privates off/religion off/sex off/vulgarity $FORTUNES"
alias f='fortune -casn 500 $FORTUNES'

# Be nice to sysadmins
if [ -f /etc/bashrc ]; then
  echo -e '\e[2;37mbtw: merging master bashrc...\e[0m';
  source /etc/bashrc
fi
