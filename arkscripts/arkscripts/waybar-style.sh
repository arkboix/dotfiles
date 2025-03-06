#!/bin/bash

# Waybar Theme Toggle Script with Rofi
# Toggles between Solarized and Nord themes

WAYBAR_DIR="$HOME/.config/waybar"
MAIN_CSS="$WAYBAR_DIR/style.css"
THEME2_CSS="$WAYBAR_DIR/theme-2/style.css"
THEME3_CSS="$WAYBAR_DIR/theme-3/style.css"
THEME4_CSS="$WAYBAR_DIR/theme-4/style.css"
THEME5_CSS="$WAYBAR_DIR/theme-5/style.css"  # Added theme-5 CSS file
RELOAD_SCRIPT="$HOME/arkscripts/reload.sh"  # Custom reload script

# Function to comment/uncomment lines in a file
# Args: $1 = file, $2 = start line, $3 = end line, $4 = action (comment/uncomment)
toggle_lines() {
    local file=$1
    local start_line=$2
    local end_line=$3
    local action=$4

    if [ "$action" = "comment" ]; then
        # Comment out the lines
        sed -i "${start_line},${end_line}s/^/\/\* /;${start_line},${end_line}s/$/ \*\//" "$file"
    elif [ "$action" = "uncomment" ]; then
        # Uncomment the lines (remove /* and */ from each line)
        sed -i "${start_line},${end_line}s/^\/\* //;${start_line},${end_line}s/ \*\/$//" "$file"
    fi
}

# Function to activate Solarized theme
activate_solarized() {
    echo "Activating Solarized theme..."

    # Main style.css
    toggle_lines "$MAIN_CSS" 6 21 "uncomment"  # Uncomment Solarized lines
    toggle_lines "$MAIN_CSS" 24 39 "comment"   # Comment out Nord lines

    # theme-2/style.css
    toggle_lines "$THEME2_CSS" 2 17 "uncomment"  # Uncomment Solarized lines
    toggle_lines "$THEME2_CSS" 20 35 "comment"   # Comment out Nord lines

    # theme-3/style.css
    toggle_lines "$THEME3_CSS" 2 17 "uncomment"  # Uncomment Solarized lines
    toggle_lines "$THEME3_CSS" 21 36 "comment"   # Comment out Nord lines

    # theme-4/style.css
    toggle_lines "$THEME4_CSS" 2 17 "uncomment"  # Uncomment Solarized lines
    toggle_lines "$THEME4_CSS" 20 35 "comment"   # Comment out Nord lines

    # theme-5/style.css
    toggle_lines "$THEME5_CSS" 2 17 "uncomment"  # Uncomment Solarized lines
    toggle_lines "$THEME5_CSS" 21 36 "comment"   # Comment out Nord lines

    echo "Solarized theme activated. Reloading Waybar..."
    $RELOAD_SCRIPT  # Run custom reload script

    # Notify user
    notify-send "Waybar Theme" "Solarized theme activated" -i color-select
}

# Function to activate Nord theme
activate_nord() {
    echo "Activating Nord theme..."

    # Main style.css
    toggle_lines "$MAIN_CSS" 6 21 "comment"    # Comment out Solarized lines
    toggle_lines "$MAIN_CSS" 24 39 "uncomment" # Uncomment Nord lines

    # theme-2/style.css
    toggle_lines "$THEME2_CSS" 2 17 "comment"    # Comment out Solarized lines
    toggle_lines "$THEME2_CSS" 20 35 "uncomment" # Uncomment Nord lines

    # theme-3/style.css
    toggle_lines "$THEME3_CSS" 2 17 "comment"    # Comment out Solarized lines
    toggle_lines "$THEME3_CSS" 21 36 "uncomment" # Uncomment Nord lines

    # theme-4/style.css
    toggle_lines "$THEME4_CSS" 2 17 "comment"    # Comment out Solarized lines
    toggle_lines "$THEME4_CSS" 20 35 "uncomment" # Uncomment Nord lines

    # theme-5/style.css
    toggle_lines "$THEME5_CSS" 2 17 "comment"    # Comment out Solarized lines
    toggle_lines "$THEME5_CSS" 21 36 "uncomment" # Uncomment Nord lines

    echo "Nord theme activated. Reloading Waybar..."
    $RELOAD_SCRIPT  # Run custom reload script

    # Notify user
    notify-send "Waybar Theme" "Nord theme activated" -i color-select
}

# Function to determine current theme
get_current_theme() {
    # Check if Solarized is uncommented in main CSS (line 6)
    if grep -q "^/\* " <<< "$(sed -n '6p' "$MAIN_CSS")"; then
        echo "nord"  # Line 6 is commented, so Solarized is inactive
    else
        echo "solarized"  # Line 6 is not commented, so Solarized is active
    fi
}

# Main script logic
if [ "$1" = "rofi" ] || [ -z "$1" ]; then
    # Get current theme for marking in rofi
    current=$(get_current_theme)

    # Show Rofi menu with current theme marked
    if [ "$current" = "solarized" ]; then
        selected=$(echo -e "Solarized ✓\nNord" | rofi -dmenu -i -p "Select Waybar Theme" -no-custom)
    else
        selected=$(echo -e "Solarized\nNord ✓" | rofi -dmenu -i -p "Select Waybar Theme" -no-custom)
    fi

    # Process selection
    case "$selected" in
        "Solarized"*)
            activate_solarized
            ;;
        "Nord"*)
            activate_nord
            ;;
        *)
            echo "No theme selected"
            exit 0
            ;;
    esac
else
    # Command line options still available
    case "$1" in
        solarized)
            activate_solarized
            ;;
        nord)
            activate_nord
            ;;
        toggle)
            current=$(get_current_theme)
            if [ "$current" = "solarized" ]; then
                activate_nord
            else
                activate_solarized
            fi
            ;;
        *)
            echo "Usage: $0 {solarized|nord|toggle|rofi}"
            echo "  solarized: Switch to Solarized theme"
            echo "  nord: Switch to Nord theme"
            echo "  toggle: Toggle between themes"
            echo "  rofi: Show Rofi menu for selection (default if no argument provided)"
            exit 1
            ;;
    esac
fi

exit 0
