#!/usr/bin/env sh

notify-send "Reloading" "Has been reloaded succesfully"
# Arkscripts - https://github.com/arkboix/dotfiles
pkill waybar

# Waybar
waybar -c /home/arkboi/.config/waybar/minimal-floating/config.jsonc -s /home/arkboi/.config/waybar/minimal-floating/style.css

sleep 1
pkill swaync
swaync &


# NWG Wrapper
pkill nwg-wrapper
nwg-wrapper -t bindings.pango -c bindings.css -p left -a end -mb 30 -ml 30


