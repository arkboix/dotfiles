#!/bin/bash

# Define options
options=(
    "Change Waybar Layout (NEW)"
    "Hyprland Settings App"
    "Edit Configs (GUI)"
    "Edit Configs"
    "Reload Waybar"
    "Set Wallpaper"
    "Clean System Junk"
    "Perform System Recovery (if bricked)"
    "Fasten System"
    "Emergency Wifi Fix"
    "Backup Files"
    "Night Light"
    "Send Info notification"
    "Update System"
 #   "Change Global Theme"
    "Change Display Settings"
    "Change Rofi Style (NEW THEMES AVAILABLE)"
)

# Define corresponding commands
commands=(
    "~/dotfiles/arkscripts/arkscripts/waybar-theme.sh"
    "~/dotfiles/arkscripts/arkscripts/settings.sh"
    "~/dotfiles/arkscripts/arkscripts/config-edit-gui.sh"
    "~/dotfiles/arkscripts/arkscripts/config-edit.sh"
    "pkill -SIGUSR2 waybar"
    "~/dotfiles/arkscripts/arkscripts/select-wall.sh"
    "~/dotfiles/arkscripts/arkscripts/clean.sh"
    "~/dotfiles/arkscripts/arkscripts/recover.sh"
    "~/dotfiles/arkscripts/arkscripts/fast.sh"
    "~/dotfiles/arkscripts/arkscripts/wifi.sh"
    "~/dotfiles/arkscripts/arkscripts/backup.sh"
    "~/dotfiles/arkscripts/arkscripts/nightlight.sh"
    "~/dotfiles/arkscripts/arkscripts/info.sh"
    "~/dotfiles/arkscripts/arkscripts/update.sh"
#    "~/dotfiles/arkscripts/arkscripts/theme-all.sh"
    "nwg-displays"
    "~/dotfiles/arkscripts/arkscripts/rofi-theme.sh"
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
