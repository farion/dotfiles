#!/bin/bash
WINDOW=$(swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true) | .name')
if [[ ! $WINDOW =~ .*-\ KeePassXC.* ]]; then
	echo $1 | clipman store --no-persist
fi
