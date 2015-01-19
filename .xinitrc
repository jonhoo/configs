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
    compton -CGb
fi

# Start user-space DBUS
source /etc/X11/xinit/xinitrc.d/30-dbus

autoif=$(systemctl | grep netctl-auto | awk '{print $1}' | sed 's/.*@\(.*\)\.service/\1/')
if [[ -n $autoif ]]; then
	has_carrier=$(cat /sys/class/net/autoif/carrier 2>/dev/null)
	#if [[ $has_carrier != "1" ]]; then
		sudo systemctl restart netctl-auto@$autoif &
	#fi
fi

# gnupg keyring agent
# ensure it's started so SSH will work
# https://www.gnupg.org/faq/whats-new-in-2.1.html#autostart
if [[ -e "/usr/bin/gpgconf" ]]; then
	gpgconf --launch gpg-agent
	export SSH_AUTH_SOCK=/home/jon/.gnupg/S.gpg-agent.ssh
fi

# ssh agent fallback
if test -z "$SSH_AUTH_SOCK" ; then
	eval $(ssh-agent -s)
fi

# Start WM
tiling=0
if [[ $1 == "weston" && -e "/usr/bin/weston-launch" ]]; then
  weston-launch 2> .logs/weston.err > .logs/weston.log &
elif [[ $1 == "xmonad" && -e "/usr/bin/xmonad" ]]; then
  xsetroot -cursor_name left_ptr
  xmonad 2> .logs/xmonad.err > .logs/xmonad.log &
  tiling=1
elif [[ -e "/usr/bin/pekwm" ]]; then
  pekwm 2> .logs/pekwm.err > .logs/pekwm.log &
else
  xterm &
fi
wmpid=$!

# Apps
if test -e "/usr/bin/kupfer" ; then
    kupfer --no-splash 2> .logs/kupfer.err > .logs/kupfer.log &
fi

if test -e "/usr/bin/xscreensaver" ; then
    xscreensaver -no-splash &
fi

# Tray icons
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

if [[ -e "/usr/bin/urxvtd" ]]; then
    urxvtd -q -o -f &
fi

# Update screen layout
if [[ -e ~/bin/hotplug-dp.sh ]]; then
    (
      sleep 1;
      sudo ~/bin/hotplug-dp.sh;
      pkill -SIGUSR1 tint2;
    ) &
fi

# And wait for WM
echo $wmpid > .wmpid
wait $wmpid

# Cleanup
killall --user $USER
eval `ssh-agent -k`
