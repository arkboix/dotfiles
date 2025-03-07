#!/usr/bin/env sh
# Arkscripts - https://github.com/arkboix/dotfiles
SELECTED_WALL="$(swww query | awk '{print $8}')"

wal -i "$SELECTED_WALL"


killall waybar
bash ~/arkscripts/reload.sh
