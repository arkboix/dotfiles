#!/bin/bash
# Arkscripts - https://github.com/arkboix/dotfiles
# Define themes with their corresponding commands
declare -A themes=(
    ["Default"]="waybar"
    ["Opaque"]="waybar -c ~/.config/waybar/theme-2/config.jsonc -s ~/.config/waybar/theme-2/style.css"
    ["Simple"]="waybar -c ~/.config/waybar/theme-3/config.jsonc -s ~/.config/waybar/theme-3/style.css"
    ["Fluent"]="waybar -c ~/.config/waybar/theme-4/config.jsonc -s ~/.config/waybar/theme-4/style.css"
    ["Fluent Alt (Bottom)"]="waybar -c ~/.config/waybar/theme-5/config.jsonc -s ~/.config/waybar/theme-5/style.css"
    ["Minimal Fluent"]="waybar -c ~/.config/waybar/theme-6/config.jsonc -s ~/.config/waybar/theme-6/style.css"
)

# Kill existing waybar instances
killall waybar

# Use rofi to select theme
selected_theme=$(printf '%s\n' "${!themes[@]}" | rofi -dmenu -p "Select Waybar Theme")

# Check if a theme was selected
if [[ -n "$selected_theme" ]]; then
    # Get the corresponding command
    theme_command="${themes[$selected_theme]}"

    # Update autostart configuration file (13th line)
    autostart_file=~/.config/hypr/conf/autostart.conf
    sed -i '13c\'"exec-once = $theme_command" "$autostart_file"

    # Update reload script (line 8)
    reload_script=~/arkscripts/reload.sh
    sed -i '8c\'"$theme_command" "$reload_script"

    # Launch the selected theme
    eval "$theme_command"
    sleep 1
else
    # Notify if no theme was selected
    notify-send "Waybar Theme" "No theme selected"
    waybar
fi
