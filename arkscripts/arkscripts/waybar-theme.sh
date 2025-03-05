#!/bin/bash

# Define themes with their corresponding commands
declare -A themes=(
    ["Default"]="waybar"
    ["Opaque"]="waybar -c ~/.config/waybar/theme-2/config.jsonc -s ~/.config/waybar/theme-2/style.css"
    ["Simple"]="waybar -c ~/.config/waybar/theme-3/config.jsonc -s ~/.config/waybar/theme-3/style.css"
)

# Kill existing waybar instances
killall waybar

# Use rofi to select theme
selected_theme=$(printf '%s\n' "${!themes[@]}" | rofi -dmenu -p "Select Waybar Theme")

# Check if a theme was selected
if [[ -n "$selected_theme" ]]; then
    # Get the corresponding command
    theme_command="${themes[$selected_theme]}"

    # Update autostart configuration file
    autostart_file=~/.config/hypr/conf/autostart.conf

    # Use sed to replace the 13th line with the new theme command
    sed -i '13c\'"exec-once = $theme_command" "$autostart_file"

    # Launch the selected theme
    eval "$theme_command"

    # Notify user
    notify-send "Waybar Theme" "Switched to $selected_theme theme"
else
    # Notify if no theme was selected
    notify-send "Waybar Theme" "No theme selected"
fi
