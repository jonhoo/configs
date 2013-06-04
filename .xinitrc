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

# gnome keyring agent
if test -z "$GNOME_KEYRING_PID" && test -e "/usr/bin/gnome-keyring-daemon"; then
  eval `gnome-keyring-daemon -s -c secrets,ssh,gpg`
fi

# ssh agent fallback
if test -z "$SSH_AUTH_SOCK" ; then
  eval `ssh-agent -s`
fi

# Start WM
if test -e "/usr/bin/pekwm" ; then
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
if test -e "/usr/bin/dropboxd" ; then
    dropboxd &
fi
if test -e "/usr/bin/hasmail" ; then
    /usr/bin/hasmail 2> .logs/hasmail.err > .logs/hasmail.log &
fi
if test -e "/usr/bin/volti" ; then
    volti &
fi
if test -e "/usr/bin/tidybattery" ; then
    tidybattery &
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

if test -e "/usr/bin/tint2" ; then
    tint2 &
fi

# And wait for WM
echo $wmpid > .wmpid
wait $wmpid

# Cleanup
killall --user $USER
eval `ssh-agent -k`
