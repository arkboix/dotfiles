#!/bin/bash

# Path to Rofi configuration directory
ROFI_CONFIG_DIR="$HOME/.config/rofi"
ROFI_CONFIG_FILE="$ROFI_CONFIG_DIR/config.rasi"
THEMES_DIR="$ROFI_CONFIG_DIR/themes"

# Check if necessary directories and files exist
if [ ! -d "$THEMES_DIR" ]; then
    echo "Error: Themes directory not found at $THEMES_DIR"
    exit 1
fi

if [ ! -f "$ROFI_CONFIG_FILE" ]; then
    echo "Error: Rofi config file not found at $ROFI_CONFIG_FILE"
    exit 1
fi

# Get list of theme files and remove the .rasi extension
themes=()
for theme_file in "$THEMES_DIR"/*.rasi; do
    if [ -f "$theme_file" ]; then
        theme_name=$(basename "$theme_file" .rasi)
        themes+=("$theme_name")
    fi
done

# Check if any themes were found
if [ ${#themes[@]} -eq 0 ]; then
    echo "No themes found in $THEMES_DIR"
    exit 1
fi

# Display menu with available themes using rofi itself
selected_theme=$(printf "%s\n" "${themes[@]}" | rofi -dmenu -p "Select a theme:")

# Check if a theme was selected
if [ -z "$selected_theme" ]; then
    echo "No theme selected. Exiting."
    exit 0
fi

# Backup the original config
cp "$ROFI_CONFIG_FILE" "$ROFI_CONFIG_FILE.backup"

# Update the config.rasi file by replacing the @theme line
if grep -q "^@theme" "$ROFI_CONFIG_FILE"; then
    # Replace existing @theme line
    sed -i "s|^@theme.*|@theme \"~/.config/rofi/themes/$selected_theme.rasi\"|" "$ROFI_CONFIG_FILE"
else
    # Add @theme line if it doesn't exist
    echo "@theme \"~/.config/rofi/themes/$selected_theme.rasi\"" >> "$ROFI_CONFIG_FILE"
fi

echo "Theme updated to $selected_theme"
echo "Original config backed up at $ROFI_CONFIG_FILE.backup"
