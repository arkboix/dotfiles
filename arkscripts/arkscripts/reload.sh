#!/usr/bin/env sh

# Arkscripts - https://github.com/arkboix/dotfiles

notify-send "Reloading"

# Waybar
pkill waybar
sleep 1
waybar -c ~/.config/waybar/theme-3/config.jsonc -s ~/.config/waybar/theme-3/style.css
# Mako
pkill mako
mako &

# Notifs
notify-send -t 2000 "Reloaded"
