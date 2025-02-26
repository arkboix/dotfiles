#!/bin/bash

# Define the path to the waybar style.css file
WAYBAR_STYLE="$HOME/dotfiles/waybar/.config/waybar/style.css"

# Check if the style file exists
if [ ! -f "$WAYBAR_STYLE" ]; then
    echo "Error: Waybar style file not found at $WAYBAR_STYLE"
    exit 1
fi

# Define available themes
THEMES=("solarized" "nord" "everforest" "custom")

# Use rofi to create a selection menu
SELECTED_THEME=$(printf "%s\n" "${THEMES[@]}" | rofi -dmenu -i -p "Select Waybar Theme:")

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

# Create the import line with proper username expansion
IMPORT_LINE="@import url(\"file:/home/$(whoami)/dotfiles/waybar/.config/waybar/${SELECTED_THEME}.css\");"

# Backup the original file
cp "$WAYBAR_STYLE" "${WAYBAR_STYLE}.backup"

# Remove the second line and insert the new import line
sed -i "2s|.*|${IMPORT_LINE}|" "$WAYBAR_STYLE"

# Restart waybar to apply changes
pkill -SIGUSR2 waybar

echo "Waybar theme changed to $SELECTED_THEME"
