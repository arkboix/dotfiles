#!/bin/bash

# Improved Keybind Menu Script for Rofi
# Based on Arkscripts keybinds

# Define the data for keybinds with proper key abbreviations
keybind_data() {
    cat << EOF
S + Enter - Launch terminal
C + SPC - App Launcher
S + w - Close Window
S + m - Emoji Picker
S + c - Set wallpaper
S + q - Exit Hyprland
S + U - Move Focus Left
S + I - Move Focus Right
S + O - Move Focus Up
S + P - Move Focus Down
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
