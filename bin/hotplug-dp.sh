#!/bin/bash

read STATUS_DP < /sys/class/drm/card0-DP-1/status
read STATUS_HDMI < /sys/class/drm/card0-HDMI-A-1/status
export DISPLAY=:0
export XAUTHORITY=/home/jon/.Xauthority

DEV=""
STATUS="disconnected"
if [[ "$STATUS_DP" = "connected" ]]; then
	STATUS="conected"
	DEV="DP1"
elif [[ "$STATUS_HDMI" = "connected" ]]; then
	STATUS="connected"
	DEV="HDMI1"
fi

if [ "$STATUS" = "disconnected" ]; then
  xrandr --output DP1 --off
  xrandr --output HDMI1 --off
  xrandr --output LVDS1 --mode 1600x900
  xset +dpms
  xset s default
  if $(pgrep tint2 > /dev/null); then
	  pkill tint2; sudo -u jon tint2 &
  elif $(pgrep trayer > /dev/null); then
	  pkill trayer; sudo -u jon ~jon/bin/usr-trayer &
  fi
  sudo -u jon nitrogen --restore
  sed -i 's/^/#/' ~jon/.asoundrc
  sed -i 's/^##/#/' ~jon/.asoundrc
  sed -i 's/HandleLidSwitch\=ignore/HandleLidSwitch\=suspend/' /etc/systemd/logind.conf
else
  if [[ $1 == "mirror" ]]; then
    xrandr --output $DEV --mode 1024x768
    xrandr --output LVDS1 --mode 1024x768 --same-as $DEV
  else
    xrandr --output $DEV --above LVDS1 --mode 1920x1080
  fi
  xset -dpms
  xset s off
  if $(pgrep tint2 > /dev/null); then
	  pkill tint2; sudo -u jon tint2 &
  elif $(pgrep trayer > /dev/null); then
	  pkill trayer; sudo -u jon ~jon/bin/usr-trayer &
  fi
  sudo -u jon nitrogen --restore
  sed -i 's/^#//' ~jon/.asoundrc
  sed -i 's/HandleLidSwitch\=suspend/HandleLidSwitch\=ignore/' /etc/systemd/logind.conf
fi

systemctl restart systemd-logind
