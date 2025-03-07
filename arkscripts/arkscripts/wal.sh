#!/usr/bin/env sh

SELECTED_WALL="$(swww query | awk '{print $8}')"

wal -i "$SELECTED_WALL"


killall waybar
bash ~/arkscripts/reload.sh
