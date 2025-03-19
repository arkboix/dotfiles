#!/bin/bash
# https://github.com/arkboix

# HYPR ROUNDING


config="$HOME/.config/hypr/conf/looks.conf"

if [ ! -f "$config" ]; then
    echo "Config not found!"
    exit 1
fi


selected=$(echo -e "0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15" | rofi -dmenu -p "Rounding Intensity")

if [ -z "$selected" ]; then
    echo "No select, exit"
    exit 1
fi

# use sed

sed -i "s/^rounding =.*/rounding = $selected/" "$config"

hyprctl reload # relaod hyperland

notify-send "Rounding Intensity" "Current: 0"
