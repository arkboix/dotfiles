#!/bin/sh
# https://github.com/arkboix/dotfiles - THIS SCRIPT IS NO LONGER IN USE
chosen=$(printf "Power Off\nRestart\nLock" | rofi -dmenu -i -p "Power ")

case "$chosen" in
	"Power Off") poweroff ;;
	"Restart") reboot ;;
	"Lock") hyprlock ;;
	*) exit 1 ;;
esac	
