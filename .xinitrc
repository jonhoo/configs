# user-space dbus
if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
  eval `dbus-launch --sh-syntax --exit-with-session`
fi

# we want to start netcfg only after we have decrypted /home
sudo systemctl start net-auto-wireless.service &

# ssh agent
if test -z "$SSH_AUTH_SOCK" ; then
  eval `ssh-agent -s`
fi

# Keymap
# setxkbmap no;
setxkbmap -option compose:rctrl
if test -e /usr/bin/xmodmap; then
  if test -e .Xmodmap; then
    xmodmap .Xmodmap &
  fi
fi

# X styling
xrdb .Xresources;

# Apps
if test -e "/usr/bin/kupfer" ; then
    kupfer --no-splash &
fi

if test -e "/usr/bin/xscreensaver" ; then
    xscreensaver -no-splash &
fi

# Tray icons
if test -e "/usr/bin/blueman-applet" ; then
    blueman-applet &
fi
if test -e "/usr/bin/dropboxd" ; then
    dropboxd &
fi
if test -e "/usr/bin/volti" ; then
    volti &
fi
if test -e "/usr/bin/tidybattery" ; then
    tidybattery &
fi

# Conky
if test -e "/usr/bin/conky" ; then
    (sleep 2 && conky) &
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
    (sleep 2 && tint2) &
fi

# Start WM
if test -e "/usr/bin/pekwm" ; then
    pekwm 2>$HOME/.xsession-errors
else
    compiz --replace ccp 2>$HOME/.xsession-errors
fi
