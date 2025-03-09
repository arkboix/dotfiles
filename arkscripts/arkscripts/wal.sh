#!/usr/bin/env sh
# Arkscripts - https://github.com/arkboix/dotfiles
SELECTED_WALL="$(swww query | awk '{print $8}')"
rm ~/.config/waybar/pywal.css
rm ~/.config/waybar/theme-2/pywal.css
rm ~/.config/waybar/theme-3/pywal.css
rm ~/.config/waybar/theme-4/pywal.css
rm ~/.config/waybar/theme-5/pywal.css
rm ~/.config/waybar/theme-6/pywal.css
rm ~/.config/waybar/theme-7/pywal.css
rm ~/.config/wlogout/pywal.css

touch ~/.config/waybar/pywal.css
touch ~/.config/waybar/theme-2/pywal.css
touch ~/.config/waybar/theme-3/pywal.css
touch ~/.config/waybar/theme-4/pywal.css
touch ~/.config/waybar/theme-5/pywal.css
touch ~/.config/waybar/theme-6/pywal.css
touch ~/.config/waybar/theme-7/pywal.css
touch ~/.config/wlogout/pywal.css

wal -i "$SELECTED_WALL"

cat ~/.cache/wal/colors-waybar.css > ~/.config/waybar/pywal.css
cat ~/.cache/wal/colors-waybar.css > ~/.config/waybar/theme-2/pywal.css
cat ~/.cache/wal/colors-waybar.css > ~/.config/waybar/theme-3/pywal.css
cat ~/.cache/wal/colors-waybar.css > ~/.config/waybar/theme-4/pywal.css
cat ~/.cache/wal/colors-waybar.css > ~/.config/waybar/theme-5/pywal.css
cat ~/.cache/wal/colors-waybar.css > ~/.config/waybar/theme-6/pywal.css
cat ~/.cache/wal/colors-waybar.css > ~/.config/waybar/theme-7/pywal.css
cat ~/.cache/wal/colors-waybar.css > ~/.config/wlogout/pywal.css
