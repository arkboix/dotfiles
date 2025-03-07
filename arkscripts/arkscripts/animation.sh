#!/bin/bash

# Arkscripts - https://github.com/arkboix/dotfiles

# Define options
options=(
    "Enabled"
    "Disabled"
)

# Define corresponding commands
commands=(
    "hyprctl keyword animations:enabled 1"
    "hyprctl keyword animations:enabled 0"
)

# Show Rofi menu
selection=$(printf "%s\n" "${options[@]}" | rofi -dmenu -p "Main Scripts" -no-icons -columns 2)

# Execute the corresponding command
for i in "${!options[@]}"; do
    if [[ "${options[i]}" == "$selection" ]]; then
        eval "${commands[i]}"
        exit 0
    fi
  done
