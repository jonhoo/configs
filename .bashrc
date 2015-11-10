# If not running interactively, don't do anything
if [[ $- != *i* ]]; then
  # non-interactive
  alias echo=/bin/false
fi

# Make sure terminal is recognized
faking="no"
if [[ "$TERM" == "rxvt-unicode-256color" && ! -e "/usr/share/terminfo/r/$TERM" ]]; then
  if [ -e "/usr/share/terminfo/r/rxvt-256color" ]; then
    faking="nounicode"
    export TERM='rxvt-256color';
  else
    faking="vt100"
    export TERM='vt100';
  fi
fi

# Style with solarized
if [[ -e $HOME/dev/others/base16/builder/output/shell ]]; then
  source "$HOME/dev/others/base16/builder/output/shell/base16-atelierdune.dark.sh"
else
  if [[ "$TERM" == "linux" ]]; then
	  echo -en "\e]P0002b36\e]P1dc322f\e]P2859900\e]P3b58900\e]P4268bd2\e]P5d33682\e]P62aa198\e]P7eee8d5\e]P9cb4b16\e]P8002b36\e]PA586e75\e]PB657b83\e]PC839496\e]PD6c71c4\e]PE93a1a1\e]PFfdf6e3"
	  echo -e '\e[37mbtw: base16 shell style not available, emulating solarized\e[0m';
  else
	  echo -e '\e[37mbtw: base16 shell style not available\e[0m';
  fi
fi

if [[ $faking == "nounicode" ]]; then
  echo -e '\e[37mbtw: rxvt-unicode not supported, faking rxvt...\e[0m';
elif [[ $faking == "vt100" ]]; then
  echo -e '\e[37mbtw: rxvt not supported, faking vt100...\e[0m';
fi

# Be nice to sysadmins
if [ -f /etc/bashrc ]; then
  echo -e '\e[37mbtw: merging master bashrc...\e[0m';
  source /etc/bashrc
elif [ -f /etc/bash.bashrc ]; then
  echo -e '\e[37mbtw: merging master bash.bashrc...\e[0m';
  source /etc/bash.bashrc
fi

# And to users who like to tweak
if [ -e "$HOME/.local/bashrc" ]; then
  echo -e '\e[37mbtw: merging local bashrc...\e[0m';
  source "$HOME/.local/bashrc"
fi

# Weston needs some custom vars
if [[ ! -z `pgrep weston` ]]; then
  export GDK_BACKEND="wayland"
  export CLUTTER_BACKEND="wayland"
  export SDL_VIDEODRIVER="wayland"
  export QT_QPA_PLATFORM="wayland-egl"
fi

[[ $- != *i* ]] && return;

# Open in GitHub from https://gist.github.com/4132919
alias github="((git config --local --get remote.origin.url | sed -e 's/^.*git@github.com:\?/https:\/\/github.com/g' -e 's/\.git$/\/tree\//g'); (git branch 2>/dev/null| sed -n '/^\*/s/^\* //p'); echo '/'; (git rev-parse --show-prefix)) | tr -d '\n' | xargs $BROWSER"

PS1='\[\e[37m\][\A] \[\e[0;33m\]\u\[\e[0m\]@\[\e[35m\]\h \[\e[32m\]\w'

# Prompt
if [ -e /usr/share/git/completion/git-prompt.sh ]; then
    source /usr/share/git/completion/git-prompt.sh
    # For unstaged(*) and staged(+) values next to branch name in __git_ps1
    GIT_PS1_SHOWDIRTYSTATE="enabled"
    GIT_PS1_SHOWUNTRACKEDFILES="enabled"
    PS1=$PS1'\[\e[35m\]`__git_ps1`'
    echo -e "\e[37mbtw: enabling git completion in prompt...\e[0m";
fi

PS1=$PS1' \[\e[31m\]\$\[\e[0m\] '

# Prompt command (for SSH window titles)
if [ ! "$TERM" = "linux" ]; then
  export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
fi

# Solarized ls
if [ -e .dircolors ]; then
    eval "$(dircolors -b .dircolors)"
else
    echo -e '\e[37mbtw: no dircolors available...\e[0m';
fi

# colored man output
# from http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
alias man='man -P less'

# Don't autocomplete to hidden directories
bind 'set match-hidden-files off'

# Make working with Java a bit easier
export CLASSPATH="$CLASSPATH:."
if [ -e /usr/share/java ]; then
  export CLASSPATH="$CLASSPATH:/usr/share/java"
fi

# History management
export HISTCONTROL=ignoreboth
export HISTSIZE=5000
export HISTIGNORE="clear:bg:fg:cd:cd -:cd ..:exit:date:w:* --help:ls:l:ll:lll"

# Autocomplete ignore
# LaTeX
export FIGNORE="$FIGNORE:.aux:.out:.toc"

# make less better
# X = leave content on-screen
# F = quit automatically if less than one screenfull
# R = raw terminal characters (fixes git diff)
#     see http://jugglingbits.wordpress.com/2010/03/24/a-better-less-playing-nice-with-git/
export LESS="-F -X -R"

# Color aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias mplayer='mplayer -msgcolor'
# Common aliases
alias more='less'
# Convenience aliases
alias lll='ls -la'
alias ll='ls -l'
alias l='ls'
alias run='sudo systemctl start'
alias restart='sudo systemctl restart'
alias stop='sudo systemctl stop'
alias x='sudo netctl'
alias gc='git checkout'
alias gs='git status -s'
alias ca='git commit -a -m'
alias xt='date +%s'
alias ..='cd ..'
# make
alias ,='make'
# file handlers
alias o='xdg-open'
# update command
alias p="sudo pacman"
alias y="yaourt"
if [ -e /usr/bin/yaourt ]; then
  alias up="yaourt -Syu --aur"
else
  alias up="sudo pacman -Syu"
fi
# editing
alias e='$EDITOR'
# Safety first
alias mv='mv -i'

# Type - to move up to top parent dir which is a repository
function - {
  local p=""
  for f in `pwd | tr '/' ' '`; do
    p="$p/$f"
    if [ -e "$p/.git" ]; then
      cd "$p"
      break
    fi
  done
}

# Replace part of current path and cd to it
function cdd {
  cd `pwd | sed "s/$1/$2/"`
}

# Clever way of watching for file read/pipe progress
# Kudos to https://coderwall.com/p/g-drlg
function watch_progress {
  local file=$1
  local size=`sudo du -b $file | awk '{print $1}'`
  local pid=${2:-`
    sudo lsof -F p $file | cut -c 2- | head -n 1
  `}

  local watcher=/tmp/watcher-$$
  cat <<EOF > $watcher
file=$file
size=$size
pid=$pid
EOF

  cat <<'EOF' >> $watcher
line=`sudo lsof -o -o 0 -p $pid | grep $file`
position=`echo $line | awk '{print $7}' | cut -c 3-`
progress=`echo "scale=2; 100 * $position / $size" | bc`
echo pid $pid reading $file: $progress% done
EOF

  chmod +x /tmp/watcher-$$
  watch /tmp/watcher-$$
}
