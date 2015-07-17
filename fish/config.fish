set -U fish_user_abbreviations
set -U fish_user_abbreviations $fish_user_abbreviations 'o=xdg-open'
set -U fish_user_abbreviations $fish_user_abbreviations 'p=sudo pacman'
set -U fish_user_abbreviations $fish_user_abbreviations 'y=yaourt'
set -U fish_user_abbreviations $fish_user_abbreviations 'g=git'
set -U fish_user_abbreviations $fish_user_abbreviations 'gc=git checkout'
set -U fish_user_abbreviations $fish_user_abbreviations 'mpva=mpv --no-video'
set -U fish_user_abbreviations $fish_user_abbreviations 'a=asana amber/Amber'
set -U fish_user_abbreviations $fish_user_abbreviations 'l=ls'
set -U fish_user_abbreviations $fish_user_abbreviations 'll=ls -l'
set -U fish_user_abbreviations $fish_user_abbreviations 'lll=ls -la'
if [ -e ~/dev/others/t/t.py ]
	set -U fish_user_abbreviations $fish_user_abbreviations 't=~/dev/others/t/t.py --vcs-rooted --list todo.txt'
end
complete --command yaourt --wraps pacman
complete --command pacaur --wraps pacman

if [ -e /usr/bin/yaourt ]
	set -U fish_user_abbreviations $fish_user_abbreviations 'up=yaourt -Syu --aur'
else if [ -e /usr/bin/pacaur ]
	set -U fish_user_abbreviations $fish_user_abbreviations 'up=pacaur -Syu'
else
	set -U fish_user_abbreviations $fish_user_abbreviations 'up=sudo pacman -Syu'
end


function pdfo
	echo $argv | xargs pdflatex
	echo $argv | sed 's/\.tex$/.pdf/' | xargs xdg-open
end

function px
	ssh -fND localhost:8080 -C jon@thesquareplanet.com
end

set nooverride PATH PWD
function -v PWD onchdir
	set dr $PWD
	while [ "$dr" != "/" ]
		for e in $dr/.setenv-*
			set envn (basename -- $e | sed 's/^\.setenv-//')
			if contains $envn $nooverride
				continue
			end

			if not test -s $e
				# setenv is empty
				# var value is file's dir
				set envv (readlink -e $dr)
			else if test -L $e; and test -d $e
				# setenv is symlink to directory
				# var value is target directory
				set envv (readlink -e $e)
			else
				# setenv is non-empty file
				# var value is file content
				set envv (cat $e)
			end

			if not contains $envn $wasset
				set wasset $wasset $envn
				setenv $envn $envv
			end
		end
		set dr (realpath -eL $dr/..)
	end
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
set PATH $PATH (ruby -e 'print Gem.user_dir')/bin
set PATH $PATH ~/dev/go/bin

setenv EDITOR vim
setenv BROWSER vivaldi-snapshot
setenv EMAIL jon@tsp.io
setenv NAME "Jon Gjengset"
setenv GOPATH "$HOME/dev/go:$HOME/dev/projects/cuckood:$HOME/dev/projects/hasmail"

set -U fish_user_abbreviations $fish_user_abbreviations 'nova=env OS_PASSWORD=(pass www/mit-openstack) nova'
set -U fish_user_abbreviations $fish_user_abbreviations 'glance=env OS_PASSWORD=(pass www/mit-openstack) glance'
setenv OS_USERNAME jfrg
setenv OS_TENANT_NAME usersandbox_jfrg
setenv OS_AUTH_URL https://nimbus.csail.mit.edu:5001/v2.0

setenv QT_DEVICE_PIXEL_RATIO=2
setenv GDK_SCALE=2
setenv GDK_DPI_SCALE=0.5

# Fish should not add things to clipboard when killing
# See https://github.com/fish-shell/fish-shell/issues/772
set FISH_CLIPBOARD_CMD "cat"

# Base16 Shell
eval sh $HOME/dev/others/base16/shell/base16-atelierdune.dark.sh

function fish_user_key_bindings
	bind \cr 'fg>/dev/null ^/dev/null'
end

function fish_greeting
	tput cup $LINES # start terminal at the bottom
	echo -e (uname -ro | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uptime -p | sed 's/^up //' | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uname -n | awk '{print " \\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e " \\e[1mDisk usage:\\e[0m"
	echo
	echo -ne (\
		df -h | grep -E 'sda|mapper' | \
		awk '{printf "\\\\t%s\\\\t%4s / %4s  %s\\\\n\n", $6, $3, $2, $5}' | \
		sed -e 's/^\(.*\([8][5-9]\|[9][0-9]\)%.*\)$/\\\\e[0;31m\1\\\\e[0m/' -e 's/^\(.*\([7][5-9]\|[8][0-4]\)%.*\)$/\\\\e[0;33m\1\\\\e[0m/' | \
		paste -sd ''\
	)

	echo
	echo -e " \\e[1mAnd here's a quote:\\e[0m"
	set_color blue
	fortune -asn 500 $FORTUNES | sed 's/^/ /'
	echo
	set_color normal
end
