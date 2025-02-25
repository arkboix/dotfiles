#!/bin/sh

chosen=$(printf "Power Off\nRestart\nLock" | rofi -dmenu -i -p "Power ")

case "$chosen" in
	"Power Off") poweroff ;;
	"Restart") reboot ;;
	"Lock") hyprlock ;;
	*) exit 1 ;;
esac	
