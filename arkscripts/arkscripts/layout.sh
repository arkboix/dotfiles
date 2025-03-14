#!/bin/bash
# https://github.com/arkboix

# HYPR LAYOUTS


config="$HOME/.config/hypr/conf/looks.conf"

if [ ! -f "$config" ]; then
    echo "Config not found!"
    exit 1
fi


selected=$(echo -e "master\ndwindle" | rofi -dmenu)

if [ -z "$selected" ]; then
    echo "No select, exit"
    exit 1
fi

# use sed

sed -i "s/^layout =.*/layout = $selected/" "$config"

hyprctl reload # relaod hyperland

notify-send "layout to $selected"
