#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

m=$(xrandr --query | grep " connected" | grep primary | cut -d" " -f1)
cmd=(env "MONITOR=$m" polybar --reload main)

if [[ $# -gt 0 ]] && [[ $1 = "block" ]]; then
	exec "${cmd[@]}"
else
	"${cmd[@]}" &
fi
