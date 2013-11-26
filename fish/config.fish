function o
  xdg-open $argv
end

function p
  sudo pacman $argv
end

function y
  yaourt $argv
end

function up
  if [ -e /usr/bin/yaourt ]
    yaourt -Syu --aur
  else
    sudo pacman -Syu
  end
end

set FORTUNES computers debian linux magic
set FORTUNES futurama hitchhiker himym $FORTUNES
set FORTUNES firefly calvin perl $FORTUNES
set FORTUNES science wisdom miscellaneous $FORTUNES
set FORTUNES off/atheism off/debian off/linux off/privates $FORTUNES
set FORTUNES off/religion off/vulgarity $FORTUNES

# Fish git prompt
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream ''

set PATH $PATH ~/bin
set EDITOR vim
set BROWSER firefox
set EMAIL jon@tsp.io
set NAME "Jon Gjengset"

function fish_greeting
  set_color blue
  echo '\\'
  fortune -asn 500 $FORTUNES | sed 's/^/ > /'
  echo '/'
  set_color normal
end
