#!/bin/bash

# Improved Keybind Menu Script for Rofi
# Based on Arkscripts keybinds

# Define the data for keybinds with proper key abbreviations
keybind_data() {
    cat << EOF
S + Enter - Launch terminal
S + SHIFT + Q - Open Global theme Switcher
S + SHIFT + D - Open ArkScripts
S + SHIFT + A - Reload
S + SHIFT + Z - Choose Waybar Theme
S + Tab - Toggle Overview
C + SPC - App Launcher
S + w - Close Window
S + m - Emoji Picker
S + c - Set wallpaper
S + q - Exit Hyprland
S + L_ARROW - Move Focus Left
S + R_ARROW - Move Focus Right
S + U_ARROW - Move Focus Up
S + D_ARROW - Move Focus Down
S + s - Toggle Scratchpad
S + v - Clipboard
S + b - Launch Browser
S + a - Launch Video Editor
S + l - Lock Screen
S + t - Toggle Floating
S + f - Fullscreen
S + x - Launch Terminal (Left-Hand)
S + z - Launch Menu (Left-Hand)
EOF
}

# Create a legend for key abbreviations
create_legend() {
    echo "LEGEND: S = Super, C = Ctrl, A = Alt, SH = Shift, SPC = Space"
}

# Main function
main() {
    # Get keybind data and legend
    local kb_data=$(keybind_data)

    # Use rofi to display the menu
    rofi -dmenu -i -p "Keybinds" \
        -mesg "$legend" \
        -no-custom \
        -width 500 \
        -theme-str 'element { children: [element-text]; }' \
        -theme-str 'element-text { vertical-align: 0.5; }' \
        <<< "$kb_data"
}

# Run the main function
main
