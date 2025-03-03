#!/bin/bash
yad --title "Hyprland Keybinds" --text "$(grep '^bind' ~/.config/hypr/conf/input.conf | sed 's/bind = //')" --width=500 --height=600
