set -U fish_user_abbreviations
set -U fish_user_abbreviations $fish_user_abbreviations 'o=xdg-open'
set -U fish_user_abbreviations $fish_user_abbreviations 'g=git'
set -U fish_user_abbreviations $fish_user_abbreviations 'gc=git checkout'
set -U fish_user_abbreviations $fish_user_abbreviations 'vimdiff=nvim -d'
set -U fish_user_abbreviations $fish_user_abbreviations 'clippy=cargo +nightly clippy'
set -U fish_user_abbreviations $fish_user_abbreviations 'cargot=cargo t'
set -U fish_user_abbreviations $fish_user_abbreviations 'amz=env AWS_SECRET_ACCESS_KEY=(pass www/aws-secret-key | head -n1)'
set -U fish_user_abbreviations $fish_user_abbreviations 'gah=git stash; and git pull --rebase; and git stash pop'
set -U fish_user_abbreviations $fish_user_abbreviations 'c=cargo'
complete --command yaourt --wraps pacman
complete --command pacaur --wraps pacman
complete --command aurman --wraps pacman

if status --is-interactive
	tmux ^ /dev/null; and exec true
end

if [ -e /usr/bin/aurman ]
	set -U fish_user_abbreviations $fish_user_abbreviations 'p=aurman'
	set -U fish_user_abbreviations $fish_user_abbreviations 'up=aurman -Syu'
else if [ -e /usr/bin/pacaur ]
	set -U fish_user_abbreviations $fish_user_abbreviations 'p=pacaur'
	set -U fish_user_abbreviations $fish_user_abbreviations 'up=pacaur -Syu'
else if [ -e /usr/bin/yaourt ]
	set -U fish_user_abbreviations $fish_user_abbreviations 'p=yaourt'
	set -U fish_user_abbreviations $fish_user_abbreviations 'up=yaourt -Syu --aur'
else
	set -U fish_user_abbreviations $fish_user_abbreviations 'p=sudo pacman'
	set -U fish_user_abbreviations $fish_user_abbreviations 'up=sudo pacman -Syu'
end

if [ -e ~/.cargo/bin/exa ]
	set -U fish_user_abbreviations $fish_user_abbreviations 'l=exa'
	set -U fish_user_abbreviations $fish_user_abbreviations 'ls=exa'
	set -U fish_user_abbreviations $fish_user_abbreviations 'll=exa -l'
	set -U fish_user_abbreviations $fish_user_abbreviations 'lll=exa -la'
else
	set -U fish_user_abbreviations $fish_user_abbreviations 'l=ls'
	set -U fish_user_abbreviations $fish_user_abbreviations 'll=ls -l'
	set -U fish_user_abbreviations $fish_user_abbreviations 'lll=ls -la'
end

if [ -e /usr/share/fish/functions/fzf_key_bindings.fish ]; and status --is-interactive
	source /usr/share/fish/functions/fzf_key_bindings.fish
end

if test -f /usr/share/autojump/autojump.fish;
	source /usr/share/autojump/autojump.fish;
end

function ssh
	switch $argv[1]
	case "*.amazonaws.com"
		env TERM=xterm /usr/bin/ssh $argv
	case "ubuntu@"
		env TERM=xterm /usr/bin/ssh $argv
	case "*"
		/usr/bin/ssh $argv
	end
end

function limit
	numactl -C 0,2 $argv
end

function remote_alacritty
	# https://gist.github.com/costis/5135502
	set fn (mktemp)
	infocmp alacritty-256color > $fn
	scp $fn $argv[1]":alacritty-256color.ti"
	ssh $argv[1] tic "alacritty-256color.ti"
	ssh $argv[1] rm "alacritty-256color.ti"
end

function remarkable
	if test (count $argv) -lt 1
		echo "No files given"
		return
	end

	ip addr show up to 10.11.99.0/29 | grep enp0s20u2 >/dev/null
	if test $status -ne 0
		# not yet connected
		echo "Connecting to reMarkable internal network"
		sudo dhcpcd enp0s20u2
	end
	for f in $argv
		curl --form "file=@"$f http://10.11.99.1/upload
		echo
	end
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
	env SSHPASS=(pass www/mit) sshpass -e ssh athena $argv
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
set __fish_git_prompt_showupstream 'none'
set -g fish_prompt_pwd_dir_length 3

set PATH /usr/local/bin/ $PATH
set PATH $PATH ~/bin
set PATH $PATH ~/.local/bin
set PATH $PATH ~/.cargo/bin
set PATH $PATH ~/.npm-global/bin
set PATH $PATH ~/dev/go/bin

# For RLS
# https://github.com/fish-shell/fish-shell/issues/2456
setenv LD_LIBRARY_PATH (rustc +nightly --print sysroot)"/lib:$LD_LIBRARY_PATH"
setenv RUST_SRC_PATH (rustc --print sysroot)"/lib/rustlib/src/rust/src"
setenv RLS_ROOT ~/dev/others/rls

setenv EDITOR nvim
setenv BROWSER firefox-developer-edition
setenv EMAIL jon@tsp.io
setenv NAME "Jon Gjengset"
setenv GOPATH "$HOME/dev/go:$HOME/dev/projects/cuckood:$HOME/dev/projects/hasmail"
setenv RUST_BACKTRACE 1
setenv CARGO_INCREMENTAL 1
setenv RUSTFLAGS "-C target-cpu=native"
setenv WINEDEBUG fixme-all
setenv FZF_DEFAULT_COMMAND 'fd --type file --follow'
setenv FZF_CTRL_T_COMMAND 'fd --type file --follow'
setenv FZF_DEFAULT_OPTS '--height 20%'

# https://blog.packagecloud.io/eng/2017/02/21/set-environment-variable-save-thousands-of-system-calls/
setenv TZ ":/etc/localtime"

set -U fish_user_abbreviations $fish_user_abbreviations 'nova=env OS_PASSWORD=(pass www/mit-openstack | head -n1) nova'
set -U fish_user_abbreviations $fish_user_abbreviations 'glance=env OS_PASSWORD=(pass www/mit-openstack | head -n1) glance'
setenv OS_USERNAME jfrg@csail.mit.edu
setenv OS_TENANT_NAME usersandbox_jfrg
setenv OS_AUTH_URL https://nimbus.csail.mit.edu:5001/v2.0
setenv OS_IMAGE_API_VERSION 1
setenv OS_VOLUME_API_VERSION 2
function penv -d "Set up environment for the PDOS openstack service"
	env OS_PASSWORD=(pass www/mit-openstack | head -n1) OS_TENANT_NAME=pdos OS_PROJECT_NAME=pdos $argv
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
    eval sh $HOME/dev/others/base16/shell/scripts/base16-atelier-dune.sh
end

# Pretty ls colors
if test -e ~/.dir_colors
	setenv LS_COLORS (sh --noprofile -c 'eval "$(dircolors -b ~/.dir_colors)"; echo $LS_COLORS')
end

function fish_user_key_bindings
	bind \cz 'fg>/dev/null ^/dev/null'
	if functions -q fzf_key_bindings
		fzf_key_bindings
	end
end

function fish_greeting
	echo
	echo -e (uname -ro | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uptime -p | sed 's/^up //' | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uname -n | awk '{print " \\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e " \\e[1mDisk usage:\\e[0m"
	echo
	echo -ne (\
		df -l -h | grep -E 'dev/(xvda|sd|mapper)' | \
		awk '{printf "\\\\t%s\\\\t%4s / %4s  %s\\\\n\n", $6, $3, $2, $5}' | \
		sed -e 's/^\(.*\([8][5-9]\|[9][0-9]\)%.*\)$/\\\\e[0;31m\1\\\\e[0m/' -e 's/^\(.*\([7][5-9]\|[8][0-4]\)%.*\)$/\\\\e[0;33m\1\\\\e[0m/' | \
		paste -sd ''\
	)
	echo

	echo -e " \\e[1mNetwork:\\e[0m"
	echo
	# http://tdt.rocks/linux_network_interface_naming.html
	echo -ne (\
		ip addr show up scope global | \
			grep -E ': <|inet' | \
			sed \
				-e 's/^[[:digit:]]\+: //' \
				-e 's/: <.*//' \
				-e 's/.*inet[[:digit:]]* //' \
				-e 's/\/.*//'| \
			awk 'BEGIN {i=""} /\.|:/ {print i" "$0"\\\n"; next} // {i = $0}' | \
			sort | \
			column -t -R1 | \
			# public addresses are underlined for visibility \
			sed 's/ \([^ ]\+\)$/ \\\e[4m\1/' | \
			# private addresses are not \
			sed 's/m\(\(10\.\|172\.\(1[6-9]\|2[0-9]\|3[01]\)\|192\.168\.\).*\)/m\\\e[24m\1/' | \
			# unknown interfaces are cyan \
			sed 's/^\( *[^ ]\+\)/\\\e[36m\1/' | \
			# ethernet interfaces are normal \
			sed 's/\(\(en\|em\|eth\)[^ ]* .*\)/\\\e[39m\1/' | \
			# wireless interfaces are purple \
			sed 's/\(wl[^ ]* .*\)/\\\e[35m\1/' | \
			# wwan interfaces are yellow \
			sed 's/\(ww[^ ]* .*\).*/\\\e[33m\1/' | \
			sed 's/$/\\\e[0m/' | \
			sed 's/^/\t/' \
		)
	echo

	set r (random 0 100)
	if [ $r -lt 5 ] # only occasionally show backlog (5%)
		echo -e " \e[1mBacklog\e[0;32m"
		set_color blue
		echo "  [project] <description>"
		echo
	end

	set_color normal
	echo -e " \e[1mTODOs\e[0;32m"
	echo
	if [ $r -lt 10 ]
		# unimportant, so show rarely
		set_color cyan
		# echo "  [project] <description>"
	end
	if [ $r -lt 25 ]
		# back-of-my-mind, so show occasionally
		set_color green
		# echo "  [project] <description>"
	end
	if [ $r -lt 50 ]
		# upcoming, so prompt regularly
		set_color yellow
		# echo "  [project] <description>"
	end

	# urgent, so prompt always
	set_color red
	# echo "  [project] <description>"

	echo

	if test -s ~/todo
		set_color magenta
		cat todo | sed 's/^/ /'
		echo
	end

	set_color normal
end
