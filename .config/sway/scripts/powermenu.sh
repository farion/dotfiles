#!/bin/bash
run_power_choice() {
	case $1 in
	"Poweroff")
		swaymsg -t command exec "systemctl poweroff"
	;;
	"Reboot")
		swaymsg -t command exec "systemctl reboot"
	;;
	"Suspend")
		swaymsg -t command exec "systemctl suspend"
	;;
	"Lock")
		swaymsg -t command exec "swaylock --hide-keyboard-layout"
	;;
	"Logout")
		swaymsg exit
	;;
	esac
}

if [ ! -z "$1" ]; then
	run_power_choice $1
	exit
fi

choices='Lock\nLogout\nReboot\nSuspend\nPoweroff'

echo -e $choices | fzf --info hidden | xargs -r $0
