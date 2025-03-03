#!/bin/bash

# Launch rofi with position and theme options
selected=$(echo -e "[Top] Default\n[Bottom] Default\n[Top] Simple\n[Bottom] Simple" | rofi -dmenu -p "Select Waybar Layout:" -i)

# Check if a selection was made
if [ -z "$selected" ]; then
    echo "No selection made, exiting."
    exit 0
fi

# Use killall instead of pkill for more reliable termination
killall waybar

# Wait a moment to ensure waybar is fully terminated
sleep 1

# Extract position and theme from selection
if [[ "$selected" == *"Top"* ]]; then
    position="top"
elif [[ "$selected" == *"Bottom"* ]]; then
    position="bottom"
fi

# Handle based on theme selection
if [[ "$selected" == *"Simple"* ]]; then
    # Update the position in theme-2 config
    sed -i '3s/.*/"position": "'"$position"'",/' ~/.config/waybar/theme-2/config.jsonc

    # Use nohup to prevent terminal-related issues and disown the process
    nohup waybar -c ~/.config/waybar/theme-2/config.jsonc -s ~/.config/waybar/theme-2/style.css >/dev/null 2>&1 &
    disown
else
    # Default theme - update position in main config
    sed -i '5s/.*/"position": "'"$position"'",/' ~/.config/waybar/config.jsonc

    # Use nohup to prevent terminal-related issues and disown the process
    nohup waybar >/dev/null 2>&1 &
    disown
fi

echo "Waybar layout set to: $selected with position: $position"

# Exit cleanly
exit 0
