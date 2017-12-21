#!/bin/bash

read STATUS_DP < /sys/class/drm/card0-DP-1/status
read STATUS_HDMI < /sys/class/drm/card0-HDMI-A-1/status
read STATUS_HDMI2 < /sys/class/drm/card0-HDMI-A-2/status
export DISPLAY=:0
export XAUTHORITY=/home/jon/.Xauthority

maxlight() {
	/bin/cat /sys/class/backlight/intel_backlight/max_brightness > /sys/class/backlight/intel_backlight/brightness
}

lowdpi() {
	/usr/bin/sed -i 's/Xft.dpi: .*/Xft.dpi: 96/' ~jon/.Xresources
	/usr/bin/sed -i 's/x: 144.0/x: 96.0/' ~jon/.config/alacritty.yml
	/usr/bin/sed -i 's/y: 144.0/y: 96.0/' ~jon/.config/alacritty.yml
	/usr/bin/sed -i 's/barHeight = .*/barHeight = 20/' ~jon/.config/taffybar/taffybar.hs
	/usr/bin/sudo -E -u jon xrdb ~jon/.Xresources
}

hidpi() {
	/usr/bin/sed -i 's/Xft.dpi: .*/Xft.dpi: 144/' ~jon/.Xresources
	/usr/bin/sed -i 's/x: 96.0/x: 144.0/' ~jon/.config/alacritty.yml
	/usr/bin/sed -i 's/y: 96.0/y: 144.0/' ~jon/.config/alacritty.yml
	/usr/bin/sed -i 's/barHeight = .*/barHeight = 30/' ~jon/.config/taffybar/taffybar.hs
	/usr/bin/sudo -u jon xrdb ~jon/.Xresources
}

DEV=""
DEVC=""
STATUS="disconnected"
if [[ "$STATUS_DP" = "connected" ]]; then
	STATUS="conected"
	DEV="DP-1"
	DEVC="DP-1"
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
	/usr/bin/xrandr --output HDMI-1 --off
	/usr/bin/xrandr --output HDMI-2 --off
	/usr/bin/xrandr --output eDP-1 --mode 1920x1440
	/usr/bin/xrandr --output eDP-1 --auto
	/usr/bin/xset +dpms
	/usr/bin/xset s default
	hidpi
	/usr/bin/sed -i 's/HandleLidSwitch\=ignore/HandleLidSwitch\=suspend/' /etc/systemd/logind.conf
else
	if [[ $1 == "mirror" ]]; then
		/usr/bin/xrandr --output $DEV --mode 1024x768
		/usr/bin/xrandr --output eDP-1 --mode 1024x768 --same-as $DEV
	else
		edid=$(/usr/bin/cat /sys/class/drm/card0/card0-$DEVC/edid | /usr/bin/sha512sum - | /usr/bin/sed 's/\s*-$//')

		pos="above"
		case "$edid" in
			"9ed75b31c6f1bce5db7420887ebbc71c126d6a152ddf00b2b5bbb7a5479cea2608273bfcae23d8ec7bcf01578256d672c5fb0d899005f46096ef98dc447d2244")
				pos="primary --rotate left --right-of"
				maxlight
				;;
			"2639dca257f1da0fecd2edf771aefae0347b56f2f2e51fb44802859d4b43e6b298b9d157bcb7a179de054435cf97d5af674244d6139319a36a1f58791d392a7e"|\
			"e0b1346dd753a490b1d067e6b91acb40b52f67572799f6b7629484a167879248a7550496f85f62a91ea8c3cd96ddbb8cb6e30cba2effa645f225cd22667a278a")
				pos="primary --right-of"
				maxlight
				;;
		esac
		/usr/bin/xrandr --addmode eDP-1 1920x1080
		/usr/bin/xrandr --output eDP-1 --mode 1920x1080 --output $DEV --$pos eDP-1 --auto
	fi
	/usr/bin/xset -dpms
	/usr/bin/xset s off

	/usr/bin/xrandr --dpi 96
	lowdpi

	/usr/bin/sed -i 's/HandleLidSwitch\=suspend/HandleLidSwitch\=ignore/' /etc/systemd/logind.conf
fi

# restart services
pid=$(/usr/bin/pgrep taffybar)
if [[ -n $pid ]]; then
	/usr/bin/sudo -E -u jon kill $pid
	/usr/bin/sleep 1
	/usr/bin/sudo -E -u jon taffybar &
fi

# notify-osd doesn't need to be restored
/usr/bin/pkill notify-osd
/usr/bin/sudo -E -u jon nitrogen --restore

# /usr/bin/systemctl restart systemd-logind
