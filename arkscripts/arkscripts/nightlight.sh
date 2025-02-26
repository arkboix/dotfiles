#!/bin/bash

sunset=$(hyprsunset | grep "Sunset" | awk '{print $2}')
current_time=$(date +%H:%M)

if [[ "$current_time" > "$sunset" ]]; then
    hyprsunset -t 3000
    notify-send "Night Mode" "Enabled warm colors for evening."
else
    hyprsunset -t 7000
    notify-send "Night Mode" "Daytime mode active."
fi
