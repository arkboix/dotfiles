#!/bin/bash

# Define the path to the kitty config file
KITTY_CONFIG="$HOME/dotfiles/kitty/.config/kitty/kitty.conf"

# Check if the config file exists
if [ ! -f "$KITTY_CONFIG" ]; then
    echo "Error: Kitty config file not found at $KITTY_CONFIG"
    exit 1
fi

# Define available themes
THEMES=("solarized" "catppuccin" "nord")

# Use rofi to create a selection menu
SELECTED_THEME=$(printf "%s\n" "${THEMES[@]}" | rofi -dmenu -i -p "Select Kitty Theme:")

# If user cancels (presses Escape), exit gracefully
if [ -z "$SELECTED_THEME" ]; then
    echo "Theme selection cancelled"
    exit 0
fi

# Verify selected theme is in our list
if [[ ! " ${THEMES[*]} " =~ " ${SELECTED_THEME} " ]]; then
    echo "Error: Invalid theme selected"
    exit 1
fi

# Create the include line
INCLUDE_LINE="include ~/dotfiles/kitty/.config/kitty/${SELECTED_THEME}.conf"

# Backup the original file
cp "$KITTY_CONFIG" "${KITTY_CONFIG}.backup"

# Remove the first line and insert the new include line at the beginning
sed -i "1s|.*|${INCLUDE_LINE}|" "$KITTY_CONFIG"

# Reload kitty configuration if kitty is running
if pgrep -x "kitty" > /dev/null; then
    pkill -USR1 -x kitty
    echo "Kitty configuration reloaded with theme: $SELECTED_THEME"
else
    echo "Kitty theme changed to $SELECTED_THEME (will apply when you start kitty)"
fi


notify-send "Kitty Theme" "Set to: $SELECTED_THEME"
