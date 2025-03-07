#!/bin/bash

# Arkscripts - https://github.com/arkboix/dotfiles

get_metadata() {
    playerctl metadata --format '{"text": "🎵 {{artist}} - {{title}}", "tooltip": "{{album}}"}' 2>/dev/null || echo '{"text": "🎵 Not Playing", "tooltip": "No media playing"}'
}

# Send initial output
get_metadata

# Listen for player changes and update Waybar
playerctl -a metadata --format '{"text": "🎵 {{artist}} - {{title}}", "tooltip": "{{album}}"}' --follow | while read -r line; do
    echo "$line" > /tmp/playerctl-output.json  # Debugging step
    pkill -SIGRTMIN+10 waybar
done
