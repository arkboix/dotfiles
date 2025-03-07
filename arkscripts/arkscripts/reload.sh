#!/usr/bin/env sh

# Arkscripts - https://github.com/arkboix/dotfiles

notify-send "Reloading"

# Waybar
waybar
sleep 2
# Mako
pkill mako
mako &

# Notifs
notify-send -t 2000 "Reloaded"
