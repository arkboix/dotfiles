#!/bin/bash

# Arkscripts - https://github.com/arkboix/dotfiles

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

selection=$(zenity --list --title="Hyprland Config Editor" --column="Config Files" "${options[@]}" --width=600 --height=800)

for i in "${!options[@]}"; do
    if [[ "${options[i]}" == "$selection" ]]; then
        eval "${commands[i]}"
        exit 0
    fi
done
