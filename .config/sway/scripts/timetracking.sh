#!/bin/bash
while true; do
	choices="$(dialog --stdout --colors --radiolist "Select Activity:" 0 0 0 \
		1 "VDTT General" on \
		2 "VDTT Arch" off \
		3 "MBOS Arch" off \
		4 "VDTT Refinement" off \
		5 "MBOS Refinement" off \
		6 "IM6 Leadership" off \
		7 "IM6 General" off \
		8 "Skillcoaching" off \
		9 "3S API" off \
		10 "OCM Ista" off \
		11 "Inter Keycloak" off)"
	choice=
	for i in ${choices}; do
		choice=$i
	done
	if [ $choice ]; then
		timew stop
		case $choice in
		1)
			timew start "VDS vdtt"
			;;
		2)
			timew start "VDS vdtt arch"
			;;
		3)
			timew start "VDS mbos arch"
			;;
		4)
			timew start "VDS vdtt refinement meeting"
			;;
		5)
			timew start "VDS mbos refinement meeting"
			;;
		6)
			timew start "IM6 leadership meeting"
			;;
		7)
			timew start "IM6 general"
			;;
		8)
			timew start "Skillcoaching"
			;;
		9)
			timew start "3S API"
			;;
		10)
			timew start "OCM Ista"
			;;
		11)
			timew start "Inter Keycloak"
			;;
		esac
		continue
	fi
	exit
done
