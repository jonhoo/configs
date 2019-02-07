#!/bin/bash

read STATUS_DP < /sys/class/drm/card0-DP-1/status
read STATUS_DP2 < /sys/class/drm/card0-DP-2/status
read STATUS_DP3 < /sys/class/drm/card0-DP-3/status
read STATUS_HDMI < /sys/class/drm/card0-HDMI-A-1/status
read STATUS_HDMI2 < /sys/class/drm/card0-HDMI-A-2/status
export DISPLAY=:0
export XAUTHORITY=/home/jon/.Xauthority

maxlight() {
	/bin/cat /sys/class/backlight/intel_backlight/max_brightness > /sys/class/backlight/intel_backlight/brightness
}

lowdpi() {
	#/usr/bin/sed -i 's/Xft.dpi: .*/Xft.dpi: 96/' ~jon/.Xresources
	#/usr/bin/sudo -E -u jon xrdb ~jon/.Xresources
	:
}

hidpi() {
	#/usr/bin/sed -i 's/Xft.dpi: .*/Xft.dpi: 144/' ~jon/.Xresources
	#/usr/bin/sudo -u jon xrdb ~jon/.Xresources
	:
}

DEV=""
DEVC=""
STATUS="disconnected"
if [[ "$STATUS_DP" = "connected" ]]; then
	STATUS="conected"
	DEV="DP-1"
	DEVC="DP-1"
elif [[ "$STATUS_DP2" = "connected" ]]; then
	STATUS="conected"
	DEV="DP-2"
	DEVC="DP-2"
elif [[ "$STATUS_DP3" = "connected" ]]; then
	STATUS="conected"
	DEV="DP-1-1"
	DEVC="DP-3"
elif [[ "$STATUS_HDMI" = "connected" ]]; then
	STATUS="connected"
	DEV="HDMI-1"
	DEVC="HDMI-A-1"
elif [[ "$STATUS_HDMI2" = "connected" ]]; then
	STATUS="connected"
	DEV="HDMI-2"
	DEVC="HDMI-A-2"
fi

if [ "$STATUS" = "disconnected" ]; then
	/usr/bin/xrandr --output DP-1 --off
	/usr/bin/xrandr --output DP-2 --off
	/usr/bin/xrandr --output HDMI-1 --off
	/usr/bin/xrandr --output HDMI-2 --off
	/usr/bin/xrandr --output eDP-1 --mode 2560x1440
	/usr/bin/xrandr --output eDP-1 --auto
	/usr/bin/xset +dpms
	/usr/bin/xset s default
	hidpi
else
	if [[ $1 == "mirror" ]]; then
		/usr/bin/xrandr --output $DEV --mode 1024x768
		/usr/bin/xrandr --output eDP-1 --mode 1024x768 --same-as $DEV
	else
		edid=$(/usr/bin/cat /sys/class/drm/card0/card0-$DEVC/edid | /usr/bin/sha512sum - | /usr/bin/sed 's/\s*-$//')

		background_primary="wide"
		background_secondary="wide"
		pos="above --rotate normal"
		case "$edid" in
			"81ec22b7be37e347de73e6e9c2b8f68d5e34068e3b1f058a7f80a0b37af576198767ffbc0bb3691c4957d863fd224e67d72e6835caf88d418ba2da1f4e0a8b0d")
				pos="primary --rotate left --right-of"
				background_primary="tall"
				maxlight
				;;
			"2639dca257f1da0fecd2edf771aefae0347b56f2f2e51fb44802859d4b43e6b298b9d157bcb7a179de054435cf97d5af674244d6139319a36a1f58791d392a7e"|\
			"e0b1346dd753a490b1d067e6b91acb40b52f67572799f6b7629484a167879248a7550496f85f62a91ea8c3cd96ddbb8cb6e30cba2effa645f225cd22667a278a")
				pos="primary --rotate normal --right-of"
				maxlight
				;;
		esac
		/usr/bin/xrandr --output eDP-1 --mode 1920x1080 --output $DEV --$pos eDP-1 --auto
		sleep 1
		nitrogen --head=0 --set-zoom ~jon/.backgrounds/"$background_primary".jpg
		nitrogen --head=1 --set-zoom ~jon/.backgrounds/"$background_secondary".jpg
	fi
	/usr/bin/xset -dpms
	/usr/bin/xset s off

	/usr/bin/xrandr --dpi 96
	lowdpi
fi

/usr/bin/sudo -E -u jon env HOME=~jon ~jon/.config/polybar/launch.sh
