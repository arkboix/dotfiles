#!/bin/bash

# Set window size
WIDTH=300
HEIGHT=250
WAYBAR_HEIGHT=30  # Adjust if needed

# Get screen width from Hyprland
SCREEN_WIDTH=$(hyprctl monitors | awk '/^\s*ID/ {getline; print $3}' | cut -d'x' -f1)

# Calculate centered position
X_POS=$(( (SCREEN_WIDTH / 2) - (WIDTH / 2) ))
Y_POS=$((WAYBAR_HEIGHT))

# Close existing instance
if pgrep -f "yad --calendar" > /dev/null; then
    pkill -f "yad --calendar"
else
    # Launch calendar in floating mode
    yad --calendar --undecorated --fixed --close-on-unfocus --no-buttons \
        --width=$WIDTH --height=$HEIGHT &

    # Wait for it to spawn
    sleep 0.2

    # Move window using Hyprland's rules
    WINDOW_ID=$(hyprctl clients | grep -B4 "yad" | awk '/Window ID/ {print $3}')
    if [[ -n "$WINDOW_ID" ]]; then
        hyprctl dispatch movewindowpixel exact "$WINDOW_ID $X_POS $Y_POS"
    fi
fi
