#!/bin/bash

read STATUS_DP < /sys/class/drm/card0-DP-1/status
read STATUS_HDMI < /sys/class/drm/card0-HDMI-A-1/status
read STATUS_HDMI2 < /sys/class/drm/card0-HDMI-A-2/status
export DISPLAY=:0
export XAUTHORITY=/home/jon/.Xauthority

maxlight() {
	/bin/cat /sys/class/backlight/intel_backlight/max_brightness > /sys/class/backlight/intel_backlight/brightness
}

intsnd() {
	/usr/bin/sed -i 's/^#\(<.*\/\.asoundrc-internal>\)/\1/' ~jon/.asoundrc
	/usr/bin/sed -i 's/^\(<.*\/\.asoundrc-external>\)/#\1/' ~jon/.asoundrc
}

extsnd() {
	/usr/bin/sed -i 's/^\(<.*\/\.asoundrc-internal>\)/#\1/' ~jon/.asoundrc
	/usr/bin/sed -i 's/^#\(<.*\/\.asoundrc-external>\)/\1/' ~jon/.asoundrc
}


lowdpi() {
	/usr/bin/sed -i 's/Xft.dpi: .*/Xft.dpi: 96/' ~jon/.Xresources
	/usr/bin/sed -i 's/barHeight = .*/barHeight = 20/' ~jon/.config/taffybar/taffybar.hs
	/usr/bin/sudo -E -u jon xrdb ~jon/.Xresources
	/usr/bin/sed -i 's/\(--alt-high-dpi-setting\).*/\1=96/' ~jon/.local/share/applications/opera-developer.desktop
	/usr/bin/sed -i 's/\(--force-device-scale-factor\).*/\1=0.5/' ~jon/.local/share/applications/vivaldi-snapshot.desktop
}

hidpi() {
	/usr/bin/sed -i 's/Xft.dpi: .*/Xft.dpi: 144/' ~jon/.Xresources
	/usr/bin/sed -i 's/barHeight = .*/barHeight = 30/' ~jon/.config/taffybar/taffybar.hs
	/usr/bin/sudo -u jon xrdb ~jon/.Xresources
	/usr/bin/sed -i 's/\(--alt-high-dpi-setting\).*/\1=144/' ~jon/.local/share/applications/opera-developer.desktop
	/usr/bin/sed -i 's/\(--force-device-scale-factor\).*/\1=1.5/' ~jon/.local/share/applications/vivaldi-snapshot.desktop
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
elif [[ "$STATUS_HDMI2" = "connected" ]]; then
	STATUS="connected"
	DEV="HDMI2"
	DEVC="HDMI-A-2"
fi

if [ "$STATUS" = "disconnected" ]; then
	/usr/bin/xrandr --output DP1 --off
	/usr/bin/xrandr --output HDMI1 --off
	/usr/bin/xrandr --output HDMI2 --off
	/usr/bin/xrandr --output eDP1 --auto
	/usr/bin/xset +dpms
	/usr/bin/xset s default
	intsnd
	hidpi
	/usr/bin/sed -i 's/HandleLidSwitch\=ignore/HandleLidSwitch\=suspend/' /etc/systemd/logind.conf
else
	if [[ $1 == "mirror" ]]; then
		/usr/bin/xrandr --output $DEV --mode 1024x768
		/usr/bin/xrandr --output eDP1 --mode 1024x768 --same-as $DEV
	else
		edid=$(/usr/bin/cat /sys/class/drm/card0/card0-$DEVC/edid | /usr/bin/sha512sum - | /usr/bin/sed 's/\s*-$//')

		pos="above"
		if [[ $edid == "9ed75b31c6f1bce5db7420887ebbc71c126d6a152ddf00b2b5bbb7a5479cea2608273bfcae23d8ec7bcf01578256d672c5fb0d899005f46096ef98dc447d2244" ]]; then
			pos="right-of"
			maxlight
		fi
		/usr/bin/xrandr --addmode eDP1 1920x1080
		/usr/bin/xrandr --output eDP1 --mode 1920x1080 --output $DEV --$pos eDP1 --auto
	fi
	/usr/bin/xset -dpms
	/usr/bin/xset s off

	/usr/bin/xrandr --dpi 96
	lowdpi

	if [[ $DEV == HDMI* ]]; then
		extsnd
	else
		intsnd
	fi
	/usr/bin/sed -i 's/HandleLidSwitch\=suspend/HandleLidSwitch\=ignore/' /etc/systemd/logind.conf
fi

# restart services
for p in kupfer urxvtd; do
	pid=$(/usr/bin/pgrep $p)
	if [[ -n $pid ]]; then
		/usr/bin/cp /proc/$pid/cmdline /tmp/.restart$pid
		/usr/bin/sudo -E -u jon kill $pid
		/usr/bin/sleep .5
		/usr/bin/sudo -E -u jon xargs -0 /bin/sh -c 'exec "$@"' ignored < /tmp/.restart$pid &
	fi
done
pid=$(/usr/bin/pgrep taffybar)
if [[ -n $pid ]]; then
	/usr/bin/sudo -E -u jon kill $pid
	/usr/bin/sleep .5
	/usr/bin/sudo -E -u jon taffybar &
fi

# notify-osd doesn't need to be restored
/usr/bin/pkill notify-osd
/usr/bin/sudo -E -u jon nitrogen --restore

/usr/bin/systemctl restart systemd-logind
