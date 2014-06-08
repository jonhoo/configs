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

function g
  git $argv
end

function gc
  git checkout $argv
end

set FORTUNES computers debian linux magic
set FORTUNES futurama hitchhiker $FORTUNES
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
set PATH $PATH /opt/android-sdk/platform-tools
set PATH $PATH /usr/bin/core_perl/
set PATH $PATH /usr/bin/vendor_perl/
set PATH $PATH ~/.cabal/bin
set PATH $PATH ~/.gem/ruby/1.9.1/bin
set PATH $PATH ~/.gem/ruby/2.0.0/bin
set PATH $PATH ~/.gem/ruby/2.1.0/bin

setenv EDITOR vim
setenv BROWSER firefox
setenv EMAIL jon@tsp.io
setenv NAME "Jon Gjengset"

function fish_greeting
  set_color blue
  echo '\\'
  fortune -asn 500 $FORTUNES | sed 's/^/ > /'
  echo '/'
  set_color normal
end
