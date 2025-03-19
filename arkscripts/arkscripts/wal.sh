#!/usr/bin/env sh
# Arkscripts - https://github.com/arkboix/dotfiles
SELECTED_WALL="$(bash ~/arkscripts/swww.sh)"

rm ~/.config/waybar/android/pywal.css
rm ~/.config/waybar/fluent/pywal.css
rm ~/.config/waybar/material-bottom/pywal.css
rm ~/.config/waybar/opaque/pywal.css
rm ~/.config/waybar/opaque-minimal/pywal.css
rm ~/.config/waybar/floating/pywal.css
rm ~/.config/waybar/fluent-alt-bottom/pywal.css
rm ~/.config/waybar/minimal-floating/pywal.css
rm ~/.config/waybar/opaque-alt/pywal.css
rm ~/.config/waybar/simple/pywal.css
rm ~/.config/waybar/floating-opaque/pywal.css
rm ~/.config/wlogout/pywal.css

touch ~/.config/waybar/android/pywal.css
touch ~/.config/waybar/fluent/pywal.css
touch ~/.config/waybar/material-bottom/pywal.css
touch ~/.config/waybar/opaque/pywal.css
touch ~/.config/waybar/opaque-minimal/pywal.css
touch ~/.config/waybar/floating/pywal.css
touch ~/.config/waybar/fluent-alt-bottom/pywal.css
touch ~/.config/waybar/minimal-floating/pywal.css
touch ~/.config/waybar/opaque-alt/pywal.css
touch ~/.config/waybar/simple/pywal.css
touch ~/.config/waybar/floating-opaque/pywal.css
touch ~/.config/wlogout/pywal.css

wal -i "$SELECTED_WALL"
wallust theme base16-gruvbox-hard-dark


cat ~/.cache/wal/colors-waybar.css > ~/.config/waybar/android/pywal.css
cat ~/.cache/wal/colors-waybar.css > ~/.config/waybar/fluent/pywal.css
cat ~/.cache/wal/colors-waybar.css > ~/.config/waybar/material-bottom/pywal.css
cat ~/.cache/wal/colors-waybar.css > ~/.config/waybar/opaque/pywal.css
cat ~/.cache/wal/colors-waybar.css > ~/.config/waybar/opaque-minimal/pywal.css
cat ~/.cache/wal/colors-waybar.css > ~/.config/waybar/floating/pywal.css
cat ~/.cache/wal/colors-waybar.css > ~/.config/waybar/fluent-alt-bottom/pywal.css
cat ~/.cache/wal/colors-waybar.css > ~/.config/waybar/minimal-floating/pywal.css
cat ~/.cache/wal/colors-waybar.css > ~/.config/waybar/opaque-alt/pywal.css
cat ~/.cache/wal/colors-waybar.css > ~/.config/waybar/floating-opaque/pywal.css
cat ~/.cache/wal/colors-waybar.css > ~/.config/waybar/simple/pywal.css
cat ~/.cache/wal/colors-waybar.css > ~/.config/wlogout/pywal.css
