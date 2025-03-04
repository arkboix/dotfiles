#!/bin/bash

# Display keybinds cheatsheet using yad
yad --list \
  --title="Cheat Sheet" \
  --no-buttons \
  --center \
  --text="<b>LEGEND:</b> S - Super | M - Alt | C - Ctrl | SPC - Space | SH - Shift" \
  --column="Keybind" \
  --column="Action" \
  --column="Command" \
  --timeout-indicator=bottom \
  "S + Enter" "Launch terminal" "kitty" \
  "C + SPC" "App Launcher" "Rofi" \
  "S + w" "Close Window" "" \
  "S + m" "Emoji Picker" "rofi-emoji" \
  "S + c" "Set wallpaper" "" \
  "S + m" "Exit Hyprland" "" \
  "S + U I O P" "Move Focus" "" \
  "S + s" "Scratchpad" "" \
  "S + SH + s" "Move to scratchpad" "" \
  "S + SH + Arrow" "Move Windows" "" \
  "S + M + Arrow" "Resize Windows" "" \
  "S + v" "Clipboard" ""
sleep 1
hyprctl dispatch resizeactive 600 400
