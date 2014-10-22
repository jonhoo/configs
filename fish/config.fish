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

function px
	ssh -fND localhost:8080 -C jon@thesquareplanet.com
end

function vim
	if [ -e /bin/nvim ]
		/bin/nvim $argv
  else
	  /bin/vim $argv
  end
end

function mpva
	mpv --no-video $argv
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
set PATH $PATH ~/.gem/ruby/1.9.1/bin
set PATH $PATH ~/.gem/ruby/2.0.0/bin
set PATH $PATH ~/.gem/ruby/2.1.0/bin

setenv EDITOR nvim
setenv BROWSER firefox
setenv EMAIL jon@tsp.io
setenv NAME "Jon Gjengset"
setenv GOPATH ~/dev/go

function fish_greeting
	set_color blue
	echo '\\'
	fortune -asn 500 $FORTUNES | sed 's/^/ > /'
	echo '/'
	set_color normal
end
