#!/bin/bash
run_kanshi_choice() {

	case "$1" in
	"Default")
		CONFNAME=default
	;;
	"Mirror")
		CONFNAME=mirror
	;;
	"FullHD")
		CONFNAME=fullhd
	;;
	"Auto")
		CONFNAME=auto
	;;
	esac

	swaymsg -t command exec "rm ~/.config/kanshi/config && ln -s ~/.config/kanshi/"$CONFNAME" ~/.config/kanshi/config && ~/.config/sway/scripts/startkanshi.sh"
}

if [ ! -z "$1" ]; then
	run_kanshi_choice $1
	exit
fi

CURRENTCHOICE=$(ls -l  ~/.config/kanshi/config | rev | cut -f1 -d"/" | rev)

case $CURRENTCHOICE in
"auto")
    CURRENTAUTO=" (current)"
;;
"default")
    CURRENTDEFAULT=" (current)"
;;
"fullhd")
    CURRENTFULLHD=" (current)"
;;
"mirror")
    CURRENTMIRROR=" (current)"
;;
esac

choices="Default$CURRENTDEFAULT\nAuto$CURRENTAUTO\nMirror$CURRENTMIRROR\nFullHD$CURRENTFULLHD"

echo -e $choices | fzf --info hidden | xargs -0 -r $0
