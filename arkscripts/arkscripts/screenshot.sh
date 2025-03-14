#!/bin/bash

# Define the output file
output="$HOME/Pictures/screenshots/shot_$(date +"%Y-%m-%d-%H-%M-%S").png"

# Create output folder if it does not exist
mkdir -p "$HOME/Pictures/screenshots"


screenshot() {
    if [ "$1" = "region" ]; then
        # Take a screenshot with GRIM and slurp
        if grim -g "$(slurp)" "$output"; then
            notify-send "Screenshot saved" "$output"
            wl-copy < "$output"
        else
            notify-send "Screenshot failed" "Could not take screenshot"
            exit 1
        fi
    fi

    if [ "$1" = "full" ]; then
        if grim "$output"; then
            wl-copy < "$output"
            notify-send "Screenshot saved" "$output"
        else
            notify-send "Cancelled"
            exit 1
        fi
    fi
}

screenshot "$1"
