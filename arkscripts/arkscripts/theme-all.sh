#!/bin/bash

# Define paths to config files
WAYBAR_STYLE="$HOME/dotfiles/waybar/.config/waybar/style.css"
KITTY_CONFIG="$HOME/dotfiles/kitty/.config/kitty/kitty.conf"

# Define function to check if a file exists
check_file() {
    if [ ! -f "$1" ]; then
        echo "Error: File not found at $1"
        return 1
    fi
    return 0
}

# Define available themes for each application
WAYBAR_THEMES=("solarized" "nord" "everforest" "custom")
KITTY_THEMES=("solarized" "catppuccin" "nord")

# Find common themes between both applications
COMMON_THEMES=()
for theme in "${WAYBAR_THEMES[@]}"; do
    if [[ " ${KITTY_THEMES[*]} " =~ " ${theme} " ]]; then
        COMMON_THEMES+=("$theme")
    fi
done

# First, ask which application to configure
APP_OPTIONS=("waybar" "kitty" "both")
SELECTED_APP=$(printf "%s\n" "${APP_OPTIONS[@]}" | rofi -dmenu -i -p "Select Application:")

# Exit if canceled
if [ -z "$SELECTED_APP" ]; then
    echo "Selection cancelled"
    exit 0
fi

# Function to apply waybar theme
apply_waybar_theme() {
    local theme=$1
    # Check if theme is valid for waybar
    if [[ ! " ${WAYBAR_THEMES[*]} " =~ " ${theme} " ]]; then
        echo "Error: Invalid theme for Waybar: $theme"
        return 1
    fi

    # Create the import line with proper username expansion and semicolon
    IMPORT_LINE="@import url(\"file:/home/$(whoami)/dotfiles/waybar/.config/waybar/${theme}.css\");"

    # Backup the original file
    cp "$WAYBAR_STYLE" "${WAYBAR_STYLE}.backup"

    # Remove the second line and insert the new import line
    sed -i "2s|.*|${IMPORT_LINE}|" "$WAYBAR_STYLE"

    # Restart waybar to apply changes
    pkill waybar && waybar &

    echo "Waybar theme changed to $theme"
}

# Function to apply kitty theme
apply_kitty_theme() {
    local theme=$1
    # Check if theme is valid for kitty
    if [[ ! " ${KITTY_THEMES[*]} " =~ " ${theme} " ]]; then
        echo "Error: Invalid theme for Kitty: $theme"
        return 1
    fi

    # Create the include line
    INCLUDE_LINE="include ~/dotfiles/kitty/.config/kitty/${theme}.conf"

    # Backup the original file
    cp "$KITTY_CONFIG" "${KITTY_CONFIG}.backup"

    # Completely replace the first line with the new include line
    # Use a temporary file to ensure we're properly replacing the first line
    echo "$INCLUDE_LINE" > /tmp/kitty_first_line
    tail -n +2 "$KITTY_CONFIG" > /tmp/kitty_rest
    cat /tmp/kitty_first_line /tmp/kitty_rest > "$KITTY_CONFIG"
    rm /tmp/kitty_first_line /tmp/kitty_rest

    # Reload kitty configuration if kitty is running
    if pgrep -x "kitty" > /dev/null; then
        pkill -USR1 -x kitty
        echo "Kitty configuration reloaded with theme: $theme"
    else
        echo "Kitty theme changed to $theme (will apply when you start kitty)"
    fi
}

# Handle different application selections
case "$SELECTED_APP" in
    "waybar")
        # Check if waybar style file exists
        check_file "$WAYBAR_STYLE" || exit 1

        # Select theme for waybar
        SELECTED_THEME=$(printf "%s\n" "${WAYBAR_THEMES[@]}" | rofi -dmenu -i -p "Select Waybar Theme:")

        # Exit if canceled
        if [ -z "$SELECTED_THEME" ]; then
            echo "Theme selection cancelled"
            exit 0
        fi

        apply_waybar_theme "$SELECTED_THEME"
        ;;

    "kitty")
        # Check if kitty config file exists
        check_file "$KITTY_CONFIG" || exit 1

        # Select theme for kitty
        SELECTED_THEME=$(printf "%s\n" "${KITTY_THEMES[@]}" | rofi -dmenu -i -p "Select Kitty Theme:")

        # Exit if canceled
        if [ -z "$SELECTED_THEME" ]; then
            echo "Theme selection cancelled"
            exit 0
        fi

        apply_kitty_theme "$SELECTED_THEME"
        ;;

    "both")
        # Check if both config files exist
        check_file "$WAYBAR_STYLE" || exit 1
        check_file "$KITTY_CONFIG" || exit 1

        # If applying to both, only show common themes
        if [ ${#COMMON_THEMES[@]} -eq 0 ]; then
            echo "Error: No common themes found between Waybar and Kitty"
            exit 1
        fi

        # Select a common theme
        SELECTED_THEME=$(printf "%s\n" "${COMMON_THEMES[@]}" | rofi -dmenu -i -p "Select Theme for Both:")

        # Exit if canceled
        if [ -z "$SELECTED_THEME" ]; then
            echo "Theme selection cancelled"
            exit 0
        fi

        apply_waybar_theme "$SELECTED_THEME"
        apply_kitty_theme "$SELECTED_THEME"
        ;;

    *)
        echo "Invalid option selected"
        exit 1
        ;;
esac

echo "Theme switching completed successfully!"
