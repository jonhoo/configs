#!/bin/bash
# TODO rewrite in Rust
if [[ -n "$(pgrep obs)" ]]; then
	echo "OBS is already running"
	#echo "Refusing to start due to https://github.com/hyprwm/Hyprland/issues/2689"
	# exit 1
fi
desktop=$(hyprctl activeworkspace | grep -E '^workspace' | grep DP-1 | awk '{print $3}')
id=""
if [[ $1 == "-u" ]]; then
	hyprctl keyword monitor DP-1,addreserved,0,0,0,0
	hyprctl keyword general:gaps_out 8
else
	pkill buzz
	hyprctl keyword general:gaps_out 0
	# all values are -42 since the bar always adds to the reserved space
	if [[ $1 == "-p" ]]; then
		# presentation mode, so exactly 1920x1080
		hyprctl keyword monitor DP-1,addreserved,1026,$((54-42)),640,1280
	elif [[ $1 == "-q" ]]; then
		# q&a mode, so (2560/<golden ratio> = 1582)x1440
		# center, with Qs left and chat right
		hyprctl keyword monitor DP-1,addreserved,360,$((360-42)),1129,1129
	else
		# coding mode, so 2560x1440, left-aligned for chat on the right
		# but keep same chat width as for q&a
		hyprctl keyword monitor DP-1,addreserved,360,$((360-42)),$((1280-1129)),1129
	fi
	before=$(hyprctl clients | grep -E '^Window' | grep 'Firefox' | awk '{print $2}')
	firefox-developer-edition --new-window "https://studio.youtube.com/live_chat?v=2tm2zH-ECVw" &
	# let it open
	sleep 2
	after=$(hyprctl clients | grep -E '^Window' | grep 'Firefox' | awk '{print $2}')
	echo "BEFORE\n$before"
	echo "AFTER\n$after"
	id=$(comm -13 <(echo "$before") <(echo "$after"))
	echo "ID\n$id"
fi
if [[ -n "$id" ]]; then
	echo "Chat window: $id"
	if [[ $1 == "-u" ]]; then
		hyprctl dispatch closewindow "address:0x$id"
	else
		hyprctl dispatch togglefloating "address:0x$id"
		hyprctl dispatch movewindowpixel "exact $((3840-1125)) 0,address:0x$id"
		hyprctl dispatch resizewindowpixel "exact 1125 $((2160-44)),address:0x$id"
		hyprctl dispatch pin "address:0x$id"
	fi
fi
if [[ $1 = "-q" ]]; then
	firefox-developer-edition --new-window "https://wewerewondering.com/event/01H4Y60CT5XCH2A1QHRBW1TE8J/LHqP8w2miPWQlkjbF2W0SwPCejhYD7" &
	sleep 2
	qid=$(hyprctl clients | grep -E '^Window' | grep 'Firefox' | grep 'Q&A' | awk '{print $2}')
	if [[ -n "$qid" ]]; then
		echo "Q&A window: $qid"
		hyprctl dispatch togglefloating "address:0x$qid"
		hyprctl dispatch resizewindowpixel "exact 1125 $((2160-44)),address:0x$qid"
		hyprctl dispatch movewindowpixel "exact 0 0,address:0x$qid"
		hyprctl dispatch pin "address:0x$qid"
	fi
fi
if [[ $1 = "-u" ]]; then
	qids=$(hyprctl clients | grep -E '^Window' | grep 'Firefox' | grep 'Q&A' | awk '{print $2}')
	qid=$( echo "$qids" | head -n1)
	if [[ -n "$qid" && "$qids" = "$qid" ]]; then
		hyprctl dispatch closewindow "address:0x$qid"
	fi
fi

# also open a small terminal to mark webcam square
if [[ $1 != "-u" ]] && [[ $1 != "-q" ]]; then
	alacritty -e cat &> /dev/null &
	pid=$!
	# let it open
	sleep 1
	echo "Webcam underlay pid: $pid"
	hyprctl dispatch togglefloating "pid:$pid"
	hyprctl dispatch resizewindowpixel "exact 15 35,pid:$pid"
	hyprctl dispatch pin "pid:$pid"
	if [[ $1 == "-p" ]]; then
		# webcam is 300x300
		hyprctl dispatch movewindowpixel "exact 2260 1806,pid:$pid"
	else
		# webcam is 550x550
		hyprctl dispatch movewindowpixel "exact $((3840-1129-549)) $((360+549-35)),pid:$pid"
	fi
fi

if [[ $1 = "-u" ]]; then
	for maybe_marker in $(pgrep cat); do
		ppid=$(ps -p "$maybe_marker" --no-headers -o "%P" | sed 's/^ *//')
		pname=$(ps -p "$ppid" --no-headers -o "%c" | sed 's/ *$//')
		if [[ "$pname" = "alacritty" ]]; then
			hyprctl dispatch closewindow "pid:$ppid"
			break
		fi
	done
fi

# move back to current desktop if we moved away
hyprctl dispatch workspace "$desktop"
