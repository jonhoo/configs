set -U fish_user_abbreviations
set -U fish_user_abbreviations $fish_user_abbreviations 'o=xdg-open'
set -U fish_user_abbreviations $fish_user_abbreviations 'p=sudo pacman'
set -U fish_user_abbreviations $fish_user_abbreviations 'y=yaourt'
set -U fish_user_abbreviations $fish_user_abbreviations 'g=git'
set -U fish_user_abbreviations $fish_user_abbreviations 'gc=git checkout'
complete --command yaourt --wraps pacman
complete --command pacaur --wraps pacman

if status --is-interactive
	tmux ^ /dev/null; and exec true
end

if [ -e /usr/bin/yaourt ]
	set -U fish_user_abbreviations $fish_user_abbreviations 'up=yaourt -Syu --aur'
else if [ -e /usr/bin/pacaur ]
	set -U fish_user_abbreviations $fish_user_abbreviations 'up=pacaur -Syu'
else
	set -U fish_user_abbreviations $fish_user_abbreviations 'up=sudo pacman -Syu'
end

if [ -e /usr/local/bin/exa ]
	set -U fish_user_abbreviations $fish_user_abbreviations 'l=exa'
	set -U fish_user_abbreviations $fish_user_abbreviations 'ls=exa'
	set -U fish_user_abbreviations $fish_user_abbreviations 'll=exa -l'
	set -U fish_user_abbreviations $fish_user_abbreviations 'lll=exa -la'
else
	set -U fish_user_abbreviations $fish_user_abbreviations 'l=ls'
	set -U fish_user_abbreviations $fish_user_abbreviations 'll=ls -l'
	set -U fish_user_abbreviations $fish_user_abbreviations 'lll=ls -la'
end

function md2pdf
	set t (mktemp -t md2pdf.XXXXXXX.pdf)
	pandoc --smart --standalone --from markdown_github -V geometry:letterpaper,margin=2cm $argv[1] -o $t
	set --erase argv[1]
	if test (count $argv) -gt 0 -a $argv[1] '!=' '-'
		mv $t $argv[1]
	else
		cat $t
		rm $t
	end
end

function lpmd
	set infile $argv[1]
	set --erase argv[1]
	md2pdf $infile - | lp $argv -
end

function pdfo
	echo $argv | xargs pdflatex
	echo $argv | sed 's/\.tex$/.pdf/' | xargs xdg-open
end

function px
	ssh -fND localhost:8080 -C jon@ssh.thesquareplanet.com -p 222
end
function athena
	env SSHPASS=(pass www/mit) sshpass -e ssh athena
end

set nooverride PATH PWD
function onchdir -v PWD
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
		set dr (dirname $dr)
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
set PATH $PATH ~/.cargo/bin
set PATH $PATH (ruby -e 'print Gem.user_dir')/bin
set PATH $PATH ~/dev/go/bin

# For RLS
setenv LD_LIBRARY_PATH $LD_LIBRARY_PATH ~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib

setenv EDITOR nvim
setenv BROWSER vivaldi-snapshot
setenv EMAIL jon@tsp.io
setenv NAME "Jon Gjengset"
setenv GOPATH "$HOME/dev/go:$HOME/dev/projects/cuckood:$HOME/dev/projects/hasmail"
setenv RUST_BACKTRACE 1
setenv CARGO_INCREMENTAL 1
setenv WINEDEBUG fixme-all

set -U fish_user_abbreviations $fish_user_abbreviations 'nova=env OS_PASSWORD=(pass www/mit-openstack | head -n1) nova'
set -U fish_user_abbreviations $fish_user_abbreviations 'glance=env OS_PASSWORD=(pass www/mit-openstack | head -n1) glance'
setenv OS_USERNAME jfrg@csail.mit.edu
setenv OS_TENANT_NAME usersandbox_jfrg
setenv OS_AUTH_URL https://nimbus.csail.mit.edu:5001/v2.0
setenv OS_IMAGE_API_VERSION 1
function penv -d "Set up environment for the PDOS openstack service"
	env OS_PASSWORD=(pass www/mit-openstack | head -n1) OS_TENANT_NAME=pdos $argv
end
function pvm -d "Run nova/glance commands against the PDOS openstack service"
	switch $argv[1]
	case 'image-*'
		penv glance $argv
	case 'c'
		penv cinder $argv[2..-1]
	case 'g'
		penv glance $argv[2..-1]
	case '*'
		penv nova $argv
	end
end

#setenv QT_DEVICE_PIXEL_RATIO 2
#setenv GDK_SCALE 2
#setenv GDK_DPI_SCALE 0.5
setenv _JAVA_OPTIONS '-Dawt.useSystemAAFontSettings=lcd -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
setenv JAVA_FONTS /usr/share/fonts/TTF
setenv MATLAB_JAVA /usr/lib/jvm/default-runtime
setenv J2D_D3D false

# Fish should not add things to clipboard when killing
# See https://github.com/fish-shell/fish-shell/issues/772
set FISH_CLIPBOARD_CMD "cat"

# Base16 Shell
if status --is-interactive
    eval sh $HOME/dev/others/base16/builder/templates/shell/scripts/base16-atelier-dune.sh
end

# Pretty ls colors
if test -e ~/.dir_colors
	setenv LS_COLORS (sh --noprofile -c 'eval "$(dircolors -b ~/.dir_colors)"; echo $LS_COLORS')
end

function fish_user_key_bindings
	bind \cr 'fg>/dev/null ^/dev/null'
end

function fish_greeting
	#tput cup $LINES # start terminal at the bottom
	echo -e (uname -ro | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uptime -p | sed 's/^up //' | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uname -n | awk '{print " \\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e " \\e[1mDisk usage:\\e[0m"
	echo
	echo -ne (\
		df -l -h | grep -E 'dev/(sd|mapper)' | \
		awk '{printf "\\\\t%s\\\\t%4s / %4s  %s\\\\n\n", $6, $3, $2, $5}' | \
		sed -e 's/^\(.*\([8][5-9]\|[9][0-9]\)%.*\)$/\\\\e[0;31m\1\\\\e[0m/' -e 's/^\(.*\([7][5-9]\|[8][0-4]\)%.*\)$/\\\\e[0;33m\1\\\\e[0m/' | \
		paste -sd ''\
	)
	echo

	#echo -e " \\e[1mAnd here's a quote:\\e[0m"
	#set_color blue
	#fortune -asn 500 $FORTUNES | sed 's/^/ /'
	#echo

	echo -e " \e[1mBacklog\e[0;32m"
	set_color blue
	echo "  [project] <description>"
	echo

	set_color normal
	echo -e " \e[1mIn progress\e[0;32m"
	set_color magenta
	echo "  [project] <description>"
	echo

	set_color normal
	echo -e " \e[1mTODOs\e[0;32m"
	set_color cyan
	echo "  [project] <description>"
	set_color green
	echo "  [project] <description>"
	set_color yellow
	echo "  [project] <description>"
	set_color red
	echo "  [project] <description>"
	echo

	set_color normal
end
