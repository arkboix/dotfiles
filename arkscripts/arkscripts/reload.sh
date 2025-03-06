#!/usr/bin/env sh

notify-send "Reloading"

# Waybar
pkill waybar
sleep 1
waybar -c ~/.config/waybar/theme-4/config.jsonc -s ~/.config/waybar/theme-4/style.css
# Mako
pkill mako
mako &

# Notifs
notify-send -t 2000 "Reloaded"
