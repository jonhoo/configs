#!/bin/bash

read STATUS_DP < /sys/class/drm/card0-DP-1/status
read STATUS_HDMI < /sys/class/drm/card0-HDMI-A-1/status
export DISPLAY=:0
export XAUTHORITY=/home/jon/.Xauthority

maxlight() {
	cat /sys/class/backlight/intel_backlight/max_brightness > /sys/class/backlight/intel_backlight/brightness
}

DEV=""
DEVC=""
STATUS="disconnected"
if [[ "$STATUS_DP" = "connected" ]]; then
	STATUS="conected"
	DEV="DP1"
	DEVC="DP-1"
elif [[ "$STATUS_HDMI" = "connected" ]]; then
	STATUS="connected"
	DEV="HDMI1"
	DEVC="HDMI-A-1"
fi

if [ "$STATUS" = "disconnected" ]; then
	xrandr --output DP1 --off
	xrandr --output HDMI1 --off
	xrandr --output LVDS1 --mode 1600x900
	xset +dpms
	xset s default
	sed -i 's/^/#/' ~jon/.asoundrc
	sed -i 's/^##/#/' ~jon/.asoundrc
	sed -i 's/HandleLidSwitch\=ignore/HandleLidSwitch\=suspend/' /etc/systemd/logind.conf
else
	if [[ $1 == "mirror" ]]; then
		xrandr --output $DEV --mode 1024x768
		xrandr --output LVDS1 --mode 1024x768 --same-as $DEV
	else
		edid=$(cat /sys/class/drm/card0/card0-$DEVC/edid | sha512sum - | sed 's/\s*-$//')

		res=$(xrandr -q | grep -A1 "$DEV connected" | tail -n 1 | sed 's/^ *\([0-9x]*\).*/\1/')
		pos="above"
		if [[ $edid == "9ed75b31c6f1bce5db7420887ebbc71c126d6a152ddf00b2b5bbb7a5479cea2608273bfcae23d8ec7bcf01578256d672c5fb0d899005f46096ef98dc447d2244" ]]; then
			pos="right-of"
			maxlight
		fi
		xrandr --output $DEV --$pos LVDS1 --mode $res
	fi
	xset -dpms
	xset s off
	sed -i 's/^#//' ~jon/.asoundrc
	sed -i 's/HandleLidSwitch\=suspend/HandleLidSwitch\=ignore/' /etc/systemd/logind.conf
fi

if $(pgrep tint2 > /dev/null); then
	pkill tint2; sudo -u jon tint2 &
fi
if $(pgrep trayer > /dev/null); then
	pkill trayer; sudo -u jon ~jon/bin/usr-trayer &
fi
if $(pgrep xmobar > /dev/null); then
	sudo -u jon pkill -USR1 xmobar
fi
sudo -u jon nitrogen --restore

systemctl restart systemd-logind
