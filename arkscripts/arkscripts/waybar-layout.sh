#!/bin/bash

# Launch rofi with position and theme options
selected=$(echo -e "[Top] Default\n[Bottom] Default\n[Top] Simple\n[Bottom] Simple\n[Top] Floating" | rofi -dmenu -p "Select Waybar Layout:" -i)

# Check if a selection was made
if [ -z "$selected" ]; then
    echo "No selection made, exiting."
    exit 0
fi

# Kill any running Waybar instances
killall waybar

# Wait for termination
sleep 1

# Extract position from selection
if [[ "$selected" == *"Top"* ]]; then
    position="top"
elif [[ "$selected" == *"Bottom"* ]]; then
    position="bottom"
fi

# Determine the config file based on the theme
if [[ "$selected" == *"Simple"* ]]; then
    config="$HOME/.config/waybar/theme-2/config.jsonc"
    style="$HOME/.config/waybar/theme-2/style.css"
elif [[ "$selected" == *"Floating"* ]]; then
    config="$HOME/.config/waybar/theme-3/config.jsonc"
    style="$HOME/.config/waybar/theme-3/style.css"
else
    config="$HOME/.config/waybar/config.jsonc"
    style=""
fi

# Update position in the selected config file
sed -i '3s/.*/"position": "'"$position"'",/' "$config"

# Launch Waybar with the correct theme
if [ -n "$style" ]; then
    nohup waybar -c "$config" -s "$style" >/dev/null 2>&1 &
else
    nohup waybar -c "$config" >/dev/null 2>&1 &
fi

disown

echo "Waybar layout set to: $selected with position: $position"
exit 0
