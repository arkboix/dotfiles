#!/bin/bash

# Get default sink
SINK=$(pactl get-default-sink)

while true; do
    # Get volume level in percentage
    VOLUME=$(pactl get-sink-volume "$SINK" | awk '{print $5}' | tr -d '%')

    # Generate visualizer bars (█ for full, ░ for empty)
    BAR_COUNT=$((VOLUME / 10))
    BAR=$(printf '█%.0s' $(seq 1 $BAR_COUNT))
    EMPTY=$(printf '░%.0s' $(seq 1 $((10 - BAR_COUNT))))

    # Output JSON for Waybar
    echo "{\"text\": \"$BAR$EMPTY\", \"tooltip\": \"Volume: $VOLUME%\"}"

    sleep 0.2  # Adjust for smoother updates
done
