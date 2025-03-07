#!/usr/bin/env sh

notify-send "Reloading"

# Waybar
pkill waybar
sleep 1
waybar
# Mako
pkill mako
mako &

# Notifs
notify-send -t 2000 "Reloaded"
