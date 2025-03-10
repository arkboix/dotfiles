#!/bin/bash

# Arkscripts - https://github.com/arkboix/dotfiles
# Rofi Solarized Dark Theme Selector
# This script presents a menu of available custom Solarized themes
# and applies the selected theme to the Rofi configuration

# Define the themes and their paths
declare -A themes
themes=(
    ["Default Simple"]="~/.config/rofi/themes/simple.rasi"
    ["Centered"]="~/.config/rofi/themes/centered.rasi"
    ["Compact"]="~/.config/rofi/themes/compact.rasi"
    ["Grid"]="~/.config/rofi/themes/grid.rasi"
    ["Minimal"]="~/.config/rofi/themes/minimal.rasi"
    ["Material"]="~/.config/rofi/themes/material.rasi"
    ["Fullscreen"]="~/.config/rofi/themes/fullscreen.rasi"
    ["Classic"]="~/.config/rofi/themes/classic.rasi"
    ["Translucent"]="~/.config/rofi/themes/translucent.rasi"
    ["Default Second"]="~/.config/rofi/themes/default.rasi"
)

# Path to Rofi config
config_file="$HOME/.config/rofi/config.rasi"

# Check if config file exists
if [ ! -f "$config_file" ]; then
    echo "Error: Rofi config file not found at $config_file"
    exit 1
fi

# Generate the menu items
menu_items=""
for theme_name in "${!themes[@]}"; do
    menu_items+="$theme_name\n"
done
menu_items=${menu_items%\\n}  # Remove trailing newline

# Show the Rofi menu
selected=$(echo -e "$menu_items" | rofi -dmenu -p "Select Theme" -theme ~/.config/rofi/themes/solarized.rasi)

# If a theme was selected
if [ -n "$selected" ] && [ -n "${themes[$selected]}" ]; then
    selected_theme_path="${themes[$selected]}"

    # Remove the last line from the config file (assumed to be the @theme line)
    sed -i '$ d' "$config_file"

    # Add the new theme line
    echo "@theme \"$selected_theme_path\"" >> "$config_file"

    # Notify the user
    notify-send "Rofi Theme" "Theme changed to: $selected"

    echo "Theme changed to: $selected"
    echo "Path: $selected_theme_path"
fi
