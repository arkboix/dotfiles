#!/bin/bash

HOUR=$(date +%H)
if [[ "$HOUR" -ge 18 ]] || [[ "$HOUR" -lt 6 ]]; then
    hyprsunset -O 3500 && notify-send "🌙 Night Mode Activated (3500K)"
else
    hyprsunset -x && notify-send "☀️ Night Mode Disabled"
fi
