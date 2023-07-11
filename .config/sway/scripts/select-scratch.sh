#!/bin/zsh

# Get regular windows
windows=$(swaymsg -t get_tree | jq -r '.. | select(.name?) | select(.id?) | select(.name|test("'${1}'")) | .id')

scratches=$(swaymsg -t get_tree | jq -r '.nodes[].nodes[] | select(.name=="__i3_scratch") | .. | select(.name?) | select(.id?) | select(.name|test("'${1}'")) | .id')


window_id="$(printf "%s" $windows)"


windows_in_scratch="$(printf "%s" $scratches)"

if [ -z "${window_id}" ] ; then
	if [ ! -z "${2}" ]; then
		eval $2
		
		exit
	fi
	echo "No window ids found"
	exit 2
fi

if echo "${windows_in_scratch}" | grep -q "${window_id}" ; then
	swaymsg "[con_id=${window_id}] focus"
        swaymsg "[con_id=${window_id}] floating enabled"
	swaymsg "[con_id=${window_id}] resize set width "$3"ppt height "$4"ppt, move position "$5"ppt "$6"ppt"
	sleep 1
	swaymsg "[con_id=${window_id}] resize set width "$3"ppt height "$4"ppt, move position "$5"ppt "$6"ppt"
else
	swaymsg "[con_id=${window_id}] move container to scratchpad"
fi




# Select window with rofi
#selected=$(echo "$all_windows" | rofi -dmenu -i | awk '{print $1}')

# Tell sway to focus said window
#swaymsg [con_id="$selected"] focus
