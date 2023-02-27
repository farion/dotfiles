#!/bin/zsh

# Get regular windows
regular_windows=$(swaymsg -t get_tree | jq -r '.nodes[].nodes[].nodes[] | select(.name?) | select(.id?) | select(.name|test("'${1}'")) | .id')

regular_scratches=$(swaymsg -t get_tree | jq -r '.nodes[].nodes[] | select(.name=="__i3_scratch") | .nodes[] | select(.name?) | select(.id?) | select(.name|test("'${1}'")) | .id')

# Get floating windows
floating_windows=$(swaymsg -t get_tree | jq -r '.nodes[].nodes[].floating_nodes[] | select(.name?) | select(.id?) | select(.name|test("'${1}'")) | .id')

floating_scratches=$(swaymsg -t get_tree | jq -r '.nodes[].nodes[] | select(.name=="__i3_scratch") | .floating_nodes[] | select(.name?) | select(.id?) |select(.name|test("'${1}'")) | .id')

#echo $regular_windows

#echo $floating_windows

#echo $floating_windows

#echo $floating_scratches
#exit

enter=$'\n'
if [[ $regular_windows && $floating_windows ]]; then
  all_windows="$regular_windows$enter$floating_windows"
elif [[ $regular_windows ]]; then
  all_windows=$regular_windows
else
  all_windows=$floating_windows
fi

if [[ $regular_scratches && $floating_scratches ]]; then
  all_scratches="$regular_scratches$enter$floating_scratches"
elif [[ $regular_scratches ]]; then
  all_scratches=$regular_scratches
else
  all_scratches=$floating_scratches
fi

window_id="$(printf "%s" $all_windows)"

windows_in_scratch="$(printf "%s" $all_scratches)"

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
