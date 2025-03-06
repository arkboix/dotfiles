#!/usr/bin/env sh

SELECTED_WALL="$(swww query | awk '{print $8}')"

wal -i "$SELECTED_WALL"
ln -s ~/.cache/wal/colors-waybar.css ~/.config/waybar/colors-waybar.css


killall waybar
bash ~/arkscripts/reload.sh
