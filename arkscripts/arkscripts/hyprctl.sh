#!/bin/bash

# This script replays all Hyprland commands that were executed in the settings manager
# It reads from the hyprctl_commands.log file that records all executed commands

COMMAND_LOG="$HOME/.config/hypr/hyprctl_commands.log"

if [ ! -f "$COMMAND_LOG" ]; then
    echo "Command log file not found. Run the settings manager first."
    exit 1
fi

echo "Applying Hyprland commands from last session..."

# Execute each command from the log
while IFS= read -r cmd; do
    if [ -n "$cmd" ]; then
        echo "Executing: $cmd"
        eval "$cmd"
    fi
done < "$COMMAND_LOG"

echo "All commands have been executed successfully!"
