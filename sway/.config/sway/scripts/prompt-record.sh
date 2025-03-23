#!/bin/bash

swaynag -t warning -m "Do you want to screen record?" \
    -b "Yes" "exec kitty ~/.config/sway/scripts/record.sh" \
    -b "No" "exit"
