# D-bus
if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
       eval `dbus-launch --sh-syntax --exit-with-session`
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

# Wallpaper
nitrogen --restore &

# Start WM
exec ssh-agent ck-launch-session compiz --indirect-rendering --replace ccp 2>$HOME/.xsession-errors
