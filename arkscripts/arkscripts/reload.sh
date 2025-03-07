#!/usr/bin/env sh

# Arkscripts - https://github.com/arkboix/dotfiles

notify-send "Reloading"

# Waybar
waybar -c ~/.config/waybar/theme-3/config.jsonc -s ~/.config/waybar/theme-3/style.css
sleep 2
# Mako
pkill mako
mako &

# Notifs
notify-send -t 2000 "Reloaded"
