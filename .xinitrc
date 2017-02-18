#!/bin/sh
# Keymap
# setxkbmap no;
setxkbmap -option compose:rctrl
if test -e /usr/bin/xmodmap; then
  if test -e .Xmodmap; then
    xmodmap .Xmodmap
  fi
fi

# X styling
xrdb .Xresources;

# composition manager
if test -e "/usr/bin/compton" ; then
    compton -CGb \
	--paint-on-overlay \
	--backend=glx \
	--glx-swap-method=buffer-age # --vsync=opengl-swc
fi

# Start user-space DBUS
for f in /etc/X11/xinit/xinitrc.d/*.sh; do
	source "$f"
done

autoif=$(systemctl | grep netctl-auto | awk '{print $1}' | sed 's/.*@\(.*\)\.service/\1/')
if [[ -n $autoif ]]; then
	has_carrier=$(cat /sys/class/net/autoif/carrier 2>/dev/null)
	if [[ $has_carrier -ne "1" ]]; then
		sudo systemctl restart netctl-auto@$autoif &
	fi
fi

# gnupg keyring agent
# ensure it's started so SSH will work
# https://www.gnupg.org/faq/whats-new-in-2.1.html#autostart
if [[ -e "/usr/bin/gpgconf" ]]; then
	gpgconf --launch gpg-agent
	export "SSH_AUTH_SOCK=/run/user/$(id -u)/gnupg/S.gpg-agent.ssh"
fi

# ssh agent fallback
if test -z "$SSH_AUTH_SOCK" ; then
	eval $(ssh-agent -s)
fi

# Update screen layout
if [[ -e ~/bin/hotplug-dp.sh ]]; then
    (
      sleep .2;
      sudo -E ~/bin/hotplug-dp.sh;
    ) &
fi

# Start WM
xsetroot -cursor_name left_ptr
xmonad 2> .logs/xmonad.err > .logs/xmonad.log &
wmpid=$!
tiling=1

# Apps
if test -e "/usr/bin/kupfer" ; then
    kupfer --no-splash 2> .logs/kupfer.err > .logs/kupfer.log &
fi

if test -e "/usr/bin/xscreensaver" ; then
    xscreensaver -no-splash &
fi

# Tray icons
if test -e "/usr/bin/gatotray" ; then
    gatotray 2> .logs/gatotray.err > .logs/gatotray.log &
fi
if test -e "/usr/bin/caffeine" ; then
    caffeine 2> .logs/caffeine.err > .logs/caffeine.log &
fi
if test -e "/usr/bin/SpiderOak" ; then
    SpiderOak 2> .logs/spideroak.err > .logs/spideroak.log &
fi
if test -e "/usr/bin/hasmail" ; then
    /usr/bin/hasmail 2> .logs/hasmail.err > .logs/hasmail.log &
fi
if test -e "/usr/bin/volti" ; then
    volti &
fi
if test -e "/usr/bin/cbatticon" ; then
    cbatticon -i notification &
fi

# Conky
if test -e "/usr/bin/conky" ; then
    conky &
fi

# nVidia settings
if test -e "/usr/bin/nvidia-settings" ; then
    nvidia-settings --load-config-only &
fi

# wallpaper
if test -e "/usr/bin/nitrogen" ; then
    nitrogen --restore &
fi

# numlockx
if test -e "/usr/bin/numlockx" ; then
    numlockx &
fi

if test -e "/usr/bin/parcellite" ; then
    parcellite -d &
fi

if ((tiling)); then
    if test -e /usr/bin/taffybar; then
        taffybar &
    fi
elif test -e "/usr/bin/tint2"; then
    tint2 &
fi

if [[ -e "/usr/bin/xflux" && -e ~/.config/xflux ]]; then
    xflux $(cat ~/.config/xflux)
fi


# And wait for WM
echo $wmpid > .wmpid
wait $wmpid

# Cleanup
killall --user $USER
eval `ssh-agent -k`
