#!/bin/bash

read STATUS_DP < /sys/class/drm/card0-DP-1/status
read STATUS_HDMI < /sys/class/drm/card0-HDMI-A-1/status
export DISPLAY=:0
export XAUTHORITY=/home/jon/.Xauthority

maxlight() {
	cat /sys/class/backlight/intel_backlight/max_brightness > /sys/class/backlight/intel_backlight/brightness
}

intsnd() {
	sed -i 's/^#\(<.*\/\.asoundrc-internal>\)/\1/' ~jon/.asoundrc
	sed -i 's/^\(<.*\/\.asoundrc-external>\)/#\1/' ~jon/.asoundrc
}

extsnd() {
	sed -i 's/^\(<.*\/\.asoundrc-internal>\)/#\1/' ~jon/.asoundrc
	sed -i 's/^#\(<.*\/\.asoundrc-external>\)/\1/' ~jon/.asoundrc
}

lowdpi() {
	sed -i 's/Xft.dpi: .*/Xft.dpi: 144/' ~jon/.Xresources
	sed -i 's/Sans 7/Sans 6/' ~jon/.gtkrc-2.0
	sed -i 's/Sans 7/Sans 6/' ~jon/.config/gtk-3.0/settings.ini
	sed -i 's/barHeight = .*/barHeight = 20/' ~jon/.config/taffybar/taffybar.hs
	sudo -u jon xrdb ~jon/.Xresources
	sed -i 's/\(--alt-high-dpi-setting\).*/\1=96/' ~jon/.local/share/applications/opera-developer.desktop
}

hidpi() {
	sed -i 's/Xft.dpi: .*/Xft.dpi: 192/' ~jon/.Xresources
	sed -i 's/Sans 6/Sans 7/' ~jon/.gtkrc-2.0
	sed -i 's/Sans 6/Sans 7/' ~jon/.config/gtk-3.0/settings.ini
	sed -i 's/barHeight = .*/barHeight = 30/' ~jon/.config/taffybar/taffybar.hs
	sudo -u jon xrdb ~jon/.Xresources
	sed -i 's/\(--alt-high-dpi-setting\).*/\1=144/' ~jon/.local/share/applications/opera-developer.desktop
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
	xrandr --output eDP1 --auto
	xset +dpms
	xset s default
	intsnd
	hidpi
	sed -i 's/HandleLidSwitch\=ignore/HandleLidSwitch\=suspend/' /etc/systemd/logind.conf
else
	if [[ $1 == "mirror" ]]; then
		xrandr --output $DEV --mode 1024x768
		xrandr --output eDP1 --mode 1024x768 --same-as $DEV
	else
		edid=$(cat /sys/class/drm/card0/card0-$DEVC/edid | sha512sum - | sed 's/\s*-$//')

		pos="above"
		if [[ $edid == "9ed75b31c6f1bce5db7420887ebbc71c126d6a152ddf00b2b5bbb7a5479cea2608273bfcae23d8ec7bcf01578256d672c5fb0d899005f46096ef98dc447d2244" ]]; then
			pos="right-of"
			maxlight
		fi
		xrandr --addmode eDP1 1920x1080
		xrandr --output eDP1 --mode 1920x1080 --output $DEV --$pos eDP1 --auto
		xrandr --dpi 96
		lowdpi
	fi
	xset -dpms
	xset s off

	if [[ $DEV == "HDMI1" ]]; then
		extsnd
	else
		intsnd
	fi
	sed -i 's/HandleLidSwitch\=suspend/HandleLidSwitch\=ignore/' /etc/systemd/logind.conf
fi

# restart services
for p in taffybar kupfer urxvtd; do
	pid=$(pgrep $p)
	if [[ -n $pid ]]; then
		cp /proc/$pid/cmdline /tmp/.restart$pid
		sudo -u jon kill $pid
		sudo -u jon xargs -0 /bin/sh -c 'exec "$@"' ignored < /tmp/.restart$pid &
	fi
done

# notify-osd doesn't need to be restored
pkill notify-osd
sudo -u jon nitrogen --restore

systemctl restart systemd-logind
