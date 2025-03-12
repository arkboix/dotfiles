#!/usr/bin/env sh

# Arkscripts - https://github.com/arkboix/dotfiles

notify-send "Reloading"

# Waybar
waybar -c /home/arkboi/.config/waybar/minimal-floating/config.jsonc -s /home/arkboi/.config/waybar/minimal-floating/style.css
sleep 2
# Mako
pkill mako
mako &

# NWG Wrapper
pkill nwg-wrapper
nwg-wrapper -t bindings.pango -c bindings.css -p left -a end -mb 30 -ml 30

# Notifs
notify-send -t 2000 "Reloaded"
