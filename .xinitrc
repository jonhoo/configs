# user-space dbus
if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
  eval `dbus-launch --sh-syntax --exit-with-session`
fi

# ssh agent
if test -z "$SSH_AUTH_SOCK" ; then
  eval `ssh-agent -s`
fi

# Keymap
setxkbmap no;

# X styling
xrdb .Xresources;

# Apps
kupfer --no-splash &
tint2 &

# Tray icons
blueman-applet &
dropboxd &
volti &

# Conky
conky &

# nVidia settings
nvidia-settings --load-config-only &

# wallpaper
nitrogen --restore &

# Start WM
#ck-launch-session compiz --replace ccp 2>$HOME/.xsession-errors
ck-launch-session pekwm 2>$HOME/.xsession-errors
