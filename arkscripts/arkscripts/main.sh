#!/bin/bash

# Arkscripts - https://github.com/arkboix/dotfiles

# Define options
options=(
    "Change Animations intensity"
    "Change Global Theme"
    "Switch between Layouts"
    "Open Dock"
    "Close Dock"
    "Kill Proccess"
#    "Change Waybar Style (NEW)"
    "Change Waybar Layout"
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
    "Night Light ON"
    "Night Light OFF"
    "Send Info notification"
    "Update System"
    "Change Display Settings"
    "Change Rofi Style"
)

# Define corresponding commands
commands=(
    "~/dotfiles/arkscripts/arkscripts/animation.sh"
    "~/dotfiles/arkscripts/arkscripts/theme-all.sh"
    "~/dotfiles/arkscripts/arkscripts/layout.sh"
    "nwg-dock-hyprland -mb 5 -l overlay -c 'rofi -show drun' -x"
    "killall nwg-dock-hyprland"
    "~/dotfiles/arkscripts/arkscripts/kill-process.sh"
 #   "~/dotfiles/arkscripts/arkscripts/waybar-style.sh"
    "~/dotfiles/arkscripts/arkscripts/waybar-theme.sh"
    "~/dotfiles/arkscripts/arkscripts/settings.sh"
    "~/dotfiles/arkscripts/arkscripts/config-edit-gui.sh"
    "~/dotfiles/arkscripts/arkscripts/config-edit.sh"
    "pkill waybar && ~/dotfiles/arkscripts/arkscripts/reload.sh"
    "~/dotfiles/arkscripts/arkscripts/select-wall.sh"
    "~/dotfiles/arkscripts/arkscripts/clean.sh"
    "~/dotfiles/arkscripts/arkscripts/recover.sh"
    "~/dotfiles/arkscripts/arkscripts/fast.sh"
    "~/dotfiles/arkscripts/arkscripts/wifi.sh"
    "~/dotfiles/arkscripts/arkscripts/backup.sh"
    "~/dotfiles/arkscripts/arkscripts/nightlight.sh"
    "~/dotfiles/arkscripts/arkscripts/nightlight-off.sh"
    "~/dotfiles/arkscripts/arkscripts/info.sh"
    "~/dotfiles/arkscripts/arkscripts/update.sh"
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
