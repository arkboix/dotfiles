#!/bin/bash

# Launch rofi with position options
selected=$(echo -e "Top\nBottom" | rofi -dmenu -p "Select Waybar Position:" -i)

# Check if a selection was made
if [ -z "$selected" ]; then
    echo "No selection made, exiting."
    exit 0
fi

# Convert selection to lowercase for config file
position=$(echo "$selected" | tr '[:upper:]' '[:lower:]')

# Use sed to replace the 5th line with the new position
# The -i flag edits the file in place
sed -i '5s/.*/"position": "'"$position"'",/' ~/.config/waybar/config.jsonc

# Restart waybar to apply changes
bash ~/arkscripts/reload.sh


echo "Waybar position set to: $selected"
