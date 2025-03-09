#!/bin/bash

# Kill waybar before changing themes
killall -q waybar

# Create an array with theme options
options=("Light" "Dark")

# Use rofi to display a menu and capture user selection
selected=$(printf '%s\n' "${options[@]}" | rofi -dmenu -i -p "Choose theme:")

# Check if user made a selection (didn't press Esc)
if [ -n "$selected" ]; then
    # Apply the selected theme based on user choice
    case "$selected" in
        "Light")
            echo "Applying light theme..."
            ~/arkscripts/wal-light.sh
            ~/arkscripts/reload.sh
            ;;
        "Dark")
            echo "Applying dark theme..."
            ~/arkscripts/wal.sh
            ~/arkscripts/reload.sh
            ;;
        *)
            echo "Invalid selection: $selected"
            exit 1
            ;;
    esac

    # Optional: Restart waybar after theme change
    # sleep 1
    # waybar &
else
    echo "No selection made, exiting..."
fi
