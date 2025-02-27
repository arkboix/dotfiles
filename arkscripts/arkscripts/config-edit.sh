#!/bin/bash

# Define options
options=(
    "GUI Hyprland Tweak Tool"
    "Edit Hypr configs"
    "Edit Waybar configs"
    "Edit Rofi configs"
    "Edit Kitty configs"
    "Edit SwayNC configs"
    "Edit Hyprland Looks"
    "Edit Keybinds"
    "Edit Default Apps"
)

# Define corresponding commands
commands=(
    "hyprgui"
    "emacsclient -c ~/.config/hypr"
    "emacsclient -c ~/.config/waybar"
    "emacsclient -c ~/.config/rofi"
    "emacsclient -c ~/.config/kitty/kitty.conf"
    "emacsclient -c ~/.config/swaync"
    "emacsclient -c ~/.config/hypr/conf/looks.conf"
    "emacsclient -c ~/.config/hypr/conf/input.conf"
    "emacsclient -c ~/.config/hypr/conf/programs.conf"
)

# Show Rofi menu
selection=$(printf "%s\n" "${options[@]}" | rofi -dmenu -p "Edit Config:" -no-icons -columns 2)

# Execute the corresponding command
for i in "${!options[@]}"; do
    if [[ "${options[i]}" == "$selection" ]]; then
        eval "${commands[i]}"
        exit 0
    fi
  done
