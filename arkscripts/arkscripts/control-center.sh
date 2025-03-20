#!/usr/bin/env sh

#!/bin/bash

# Rofi theme
ROFI_THEME="$HOME/.config/rofi/control-center.rasi"

# Define actions
chosen=$(echo -e "󰐥 Power Off\n Reboot\n Lock\n Logout\n󰌵 Suspend\n󰒲 Bluetooth\n󰖩 Wi-Fi\n󰖎 Night Light\n󰕾 Volume\n󰃠 Brightness\n󰆘 Kill Process\n󰄛 Fun" | rofi -dmenu -i -p "Control Center" -theme "$ROFI_THEME")

case "$chosen" in
    "󰐥 Power Off") systemctl poweroff ;;
    " Reboot") systemctl reboot ;;
    " Lock") hyprlock ;;
    " Logout") hyprctl dispatch exit ;;
    "󰌵 Suspend") systemctl suspend ;;
    "󰒲 Bluetooth") bluetoothctl power toggle ;;
    "󰖩 Wi-Fi") nmcli radio wifi toggle ;;
    "󰖎 Night Light") hyprctl keyword monitor nightlight,1 ;;
    "󰕾 Volume")
        VOL=$(pamixer --get-volume)
        NEW_VOL=$(seq 0 10 100 | rofi -dmenu -i -p "Set Volume ($VOL%)" -theme "$ROFI_THEME")
        [ -n "$NEW_VOL" ] && pamixer --set-volume $NEW_VOL ;;
    "󰃠 Brightness")
        BRIGHT=$(brightnessctl get)
        MAX_BRIGHT=$(brightnessctl max)
        PERC=$(( BRIGHT * 100 / MAX_BRIGHT ))
        NEW_BRIGHT=$(seq 0 10 100 | rofi -dmenu -i -p "Set Brightness ($PERC%)" -theme "$ROFI_THEME")
        [ -n "$NEW_BRIGHT" ] && brightnessctl set $NEW_BRIGHT% ;;
    "󰆘 Kill Process")
        PROCESS=$(ps -e --format "pid cmd" | rofi -dmenu -i -p "Kill Process" -theme "$ROFI_THEME" | awk '{print $1}')
        [ -n "$PROCESS" ] && kill -9 "$PROCESS" ;;
    "󰄛 Fun")
        MSG=$(shuf -n 1 -e "You got this!" "Time for a break?" "Hack the planet!" "rm -rf / (just kidding)" "I see you 👀")
        notify-send "Fun Message" "$MSG" ;;
esac
