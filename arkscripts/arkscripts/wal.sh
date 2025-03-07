#!/usr/bin/env sh
# Arkscripts - https://github.com/arkboix/dotfiles
SELECTED_WALL="$(swww query | awk '{print $8}')"
ln -s ~/.cache/wal/colors-waybar.css ~/.config/waybar/pywal.css
ln -s ~/.cache/wal/colors-waybar.css ~/.config/waybar/theme-2/pywal.css
ln -s ~/.cache/wal/colors-waybar.css ~/.config/waybar/theme-3/pywal.css
ln -s ~/.cache/wal/colors-waybar.css ~/.config/waybar/theme-4/pywal.css
ln -s ~/.cache/wal/colors-waybar.css ~/.config/waybar/theme-5/pywal.css
ln -s ~/.cache/wal/colors-waybar.css ~/.config/waybar/theme-6/pywal.css

wal -i "$SELECTED_WALL"
