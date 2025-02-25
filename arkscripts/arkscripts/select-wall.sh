#!/bin/bash

# Wallpaper directory
WALLPAPER_DIR="$HOME/wallpapers"

# Check if directory exists
if [[ ! -d "$WALLPAPER_DIR" ]]; then
    echo "Wallpaper directory not found: $WALLPAPER_DIR"
    exit 1
fi

# Select a wallpaper using Rofi
WALLPAPER=$(ls "$WALLPAPER_DIR" | rofi -dmenu -p "Select Wallpaper")

# If no selection, exit
[[ -z "$WALLPAPER" ]] && exit 1

# Full path to the selected wallpaper
WALLPAPER_PATH="$WALLPAPER_DIR/$WALLPAPER"

# Apply the wallpaper with Hyprpaper
hyprctl hyprpaper wallpaper "$WALLPAPER_PATH"
hyprctl hyprpaper reload "$WALLPAPER_PATH"

# Success message
echo "Wallpaper set to: $WALLPAPER_PATH"
