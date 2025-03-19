#!/bin/bash

# Script to select animation level for Hyprland

# Path to Hyprland config file
HYPRLAND_CONF="$HOME/.config/hypr/hyprland.conf"

# Check if the config file exists
if [ ! -f "$HYPRLAND_CONF" ]; then
    echo "Error: Hyprland config file not found at $HYPRLAND_CONF"
    exit 1
fi

# Use rofi to prompt for animation level
ANIMATION_LEVEL=$(echo -e "high\nmedium\nlow" | rofi -dmenu -p "Select animation level:")

# Check if user selected an option
if [ -z "$ANIMATION_LEVEL" ]; then
    echo "No animation level selected. Exiting."
    exit 0
fi

# Validate selection
if [[ ! "$ANIMATION_LEVEL" =~ ^(high|medium|low)$ ]]; then
    echo "Invalid selection: $ANIMATION_LEVEL"
    exit 1
fi

# Create backup of the config file
cp "$HYPRLAND_CONF" "$HYPRLAND_CONF.bak"

# Replace the animation source line in the config file
sed -i "s|source = ~/.config/hypr/conf/animations/.*|source = ~/.config/hypr/conf/animations/$ANIMATION_LEVEL.conf|" "$HYPRLAND_CONF"

# Check if the replacement was successful
if grep -q "source = ~/.config/hypr/conf/animations/$ANIMATION_LEVEL.conf" "$HYPRLAND_CONF"; then
    echo "Animation level set to $ANIMATION_LEVEL"
    echo "Config file updated successfully."

    # Optionally reload Hyprland config
    if command -v hyprctl &> /dev/null; then
        echo "Reloading Hyprland configuration..."
        hyprctl reload
    else
        echo "Hyprland configuration updated. You may need to reload or restart Hyprland for changes to take effect."
    fi
else
    echo "Error: Failed to update config file."
    echo "Restoring backup..."
    mv "$HYPRLAND_CONF.bak" "$HYPRLAND_CONF"
    exit 1
fi
