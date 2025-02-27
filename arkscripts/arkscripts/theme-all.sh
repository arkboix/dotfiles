#!/bin/bash

# Define paths to config files
WAYBAR_STYLE="$HOME/dotfiles/waybar/.config/waybar/style.css"
KITTY_CONFIG="$HOME/dotfiles/kitty/.config/kitty/kitty.conf"
ROFI_CONFIG="$HOME/dotfiles/rofi/.config/rofi/config.rasi"
MAKO_CONFIG="$HOME/.config/mako/config"
DOOM_CONFIG="$HOME/.config/doom/config.el"

# Define wallpapers for each theme
declare -A WALLPAPERS
WALLPAPERS["nord"]="$HOME/wallpapers/Anime-Japan-Street.png"
WALLPAPERS["solarized"]="$HOME/wallpapers/solarized8.jpg"

# Define theme-specific colors for mako
declare -A MAKO_BG_COLORS
MAKO_BG_COLORS["nord"]="#2E3440"
MAKO_BG_COLORS["solarized"]="#002b36"
MAKO_BG_COLORS["everforest"]="#2d353b"
MAKO_BG_COLORS["catppuccin"]="#1E1E2E"
MAKO_BG_COLORS["custom"]="#1a1b26"

declare -A MAKO_ACCENT_COLORS
MAKO_ACCENT_COLORS["nord"]="#88C0D0"
MAKO_ACCENT_COLORS["solarized"]="#268bd2"
MAKO_ACCENT_COLORS["everforest"]="#7fbbb3"
MAKO_ACCENT_COLORS["catppuccin"]="#89b4fa"
MAKO_ACCENT_COLORS["custom"]="#7aa2f7"

# Define doom emacs theme mappings
declare -A DOOM_THEMES
DOOM_THEMES["nord"]="doom-nord"
DOOM_THEMES["solarized"]="doom-solarized-dark"
DOOM_THEMES["everforest"]="doom-gruvbox"
DOOM_THEMES["catppuccin"]="doom-tomorrow-night"
DOOM_THEMES["custom"]="doom-tokyo-night"

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
ROFI_THEMES=("solarized" "nord")
NWG_THEMES=("solarized" "nord")
MAKO_THEMES=("solarized" "nord" "everforest" "catppuccin" "custom")
DOOM_THEME_NAMES=("solarized" "nord" "everforest" "catppuccin" "custom")

# Find common themes among applications
find_common_themes() {
    local apps=("$@")
    local common=()

    # Start with all themes from the first app
    if [[ " ${apps[*]} " =~ " waybar " ]]; then
        common=("${WAYBAR_THEMES[@]}")
    elif [[ " ${apps[*]} " =~ " kitty " ]]; then
        common=("${KITTY_THEMES[@]}")
    elif [[ " ${apps[*]} " =~ " rofi " ]]; then
        common=("${ROFI_THEMES[@]}")
    elif [[ " ${apps[*]} " =~ " nwg " ]]; then
        common=("${NWG_THEMES[@]}")
    elif [[ " ${apps[*]} " =~ " mako " ]]; then
        common=("${MAKO_THEMES[@]}")
    elif [[ " ${apps[*]} " =~ " doom " ]]; then
        common=("${DOOM_THEME_NAMES[@]}")
    else
        return
    fi

    # Filter by themes available in other selected apps
    local temp_common=()
    if [[ " ${apps[*]} " =~ " waybar " ]] && [[ "${common[*]}" != "${WAYBAR_THEMES[*]}" ]]; then
        for theme in "${common[@]}"; do
            if [[ " ${WAYBAR_THEMES[*]} " =~ " ${theme} " ]]; then
                temp_common+=("$theme")
            fi
        done
        common=("${temp_common[@]}")
        temp_common=()
    fi

    if [[ " ${apps[*]} " =~ " kitty " ]] && [[ "${#common[@]}" -gt 0 ]]; then
        for theme in "${common[@]}"; do
            if [[ " ${KITTY_THEMES[*]} " =~ " ${theme} " ]]; then
                temp_common+=("$theme")
            fi
        done
        common=("${temp_common[@]}")
        temp_common=()
    fi

    if [[ " ${apps[*]} " =~ " rofi " ]] && [[ "${#common[@]}" -gt 0 ]]; then
        for theme in "${common[@]}"; do
            if [[ " ${ROFI_THEMES[*]} " =~ " ${theme} " ]]; then
                temp_common+=("$theme")
            fi
        done
        common=("${temp_common[@]}")
        temp_common=()
    fi

    if [[ " ${apps[*]} " =~ " nwg " ]] && [[ "${#common[@]}" -gt 0 ]]; then
        for theme in "${common[@]}"; do
            if [[ " ${NWG_THEMES[*]} " =~ " ${theme} " ]]; then
                temp_common+=("$theme")
            fi
        done
        common=("${temp_common[@]}")
        temp_common=()
    fi

    if [[ " ${apps[*]} " =~ " mako " ]] && [[ "${#common[@]}" -gt 0 ]]; then
        for theme in "${common[@]}"; do
            if [[ " ${MAKO_THEMES[*]} " =~ " ${theme} " ]]; then
                temp_common+=("$theme")
            fi
        done
        common=("${temp_common[@]}")
        temp_common=()
    fi

    if [[ " ${apps[*]} " =~ " doom " ]] && [[ "${#common[@]}" -gt 0 ]]; then
        for theme in "${common[@]}"; do
            if [[ " ${DOOM_THEME_NAMES[*]} " =~ " ${theme} " ]]; then
                temp_common+=("$theme")
            fi
        done
        common=("${temp_common[@]}")
        temp_common=()
    fi

    # Further filter by themes with wallpapers
    if [[ " ${apps[*]} " =~ " wallpaper " ]] && [[ "${#common[@]}" -gt 0 ]]; then
        temp_common=()
        for theme in "${common[@]}"; do
            if [[ -n "${WALLPAPERS[$theme]}" ]]; then
                temp_common+=("$theme")
            fi
        done
        common=("${temp_common[@]}")
    fi

    echo "${common[@]}"
}

# First, ask which application to configure
APP_OPTIONS=("waybar" "kitty" "rofi" "wallpaper" "nwg" "mako" "doom" "all" "waybar+kitty" "waybar+rofi" "kitty+rofi" "wallpaper+all")
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

# Function to apply rofi theme
apply_rofi_theme() {
    local theme=$1
    # Check if theme is valid for rofi
    if [[ ! " ${ROFI_THEMES[*]} " =~ " ${theme} " ]]; then
        echo "Error: Invalid theme for Rofi: $theme"
        return 1
    fi

    # Create the theme line
    THEME_LINE="@theme \"/home/$(whoami)/.config/rofi/themes/${theme}.rasi\""

    # Backup the original file
    cp "$ROFI_CONFIG" "${ROFI_CONFIG}.backup"

    # Remove the last line and add the new theme line
    sed -i '$ d' "$ROFI_CONFIG"
    echo "$THEME_LINE" >> "$ROFI_CONFIG"

    echo "Rofi theme changed to $theme"
}

# Function to apply wallpaper
apply_wallpaper() {
    local theme=$1
    # Check if theme has a wallpaper
    if [[ -z "${WALLPAPERS[$theme]}" ]]; then
        echo "Error: No wallpaper defined for theme: $theme"
        return 1
    fi

    local wallpaper="${WALLPAPERS[$theme]}"

    # Check if wallpaper file exists
    if [ ! -f "$wallpaper" ]; then
        echo "Error: Wallpaper file not found at $wallpaper"
        return 1
    fi

    # Preload and set the wallpaper using hyprpaper
    hyprctl hyprpaper preload "$wallpaper"
    hyprctl hyprpaper wallpaper "eDP-1,$wallpaper"

    echo "Wallpaper set to $wallpaper for theme $theme"
}

# Function to apply nwg-wrapper theme
apply_nwg_theme() {
    local theme=$1
    # Check if theme is valid for nwg
    if [[ ! " ${NWG_THEMES[*]} " =~ " ${theme} " ]]; then
        echo "Error: Invalid theme for NWG-Wrapper: $theme"
        return 1
    fi

    # Kill existing nwg-wrapper instances
    killall nwg-wrapper 2>/dev/null

    # Start nwg-wrapper with the selected theme
    nwg-wrapper -t "$theme.txt" -p right -mr 30 &

    echo "NWG-Wrapper theme changed to $theme"
}

# Function to apply mako theme
apply_mako_theme() {
    local theme=$1
    # Check if theme is valid for mako
    if [[ ! " ${MAKO_THEMES[*]} " =~ " ${theme} " ]]; then
        echo "Error: Invalid theme for Mako: $theme"
        return 1
    fi

    # Get background and accent colors for the theme
    local bg_color="${MAKO_BG_COLORS[$theme]}"
    local accent_color="${MAKO_ACCENT_COLORS[$theme]}"

    # Check if colors are defined
    if [[ -z "$bg_color" || -z "$accent_color" ]]; then
        echo "Error: Missing color definitions for Mako theme: $theme"
        return 1
    fi

    # Backup the original file
    cp "$MAKO_CONFIG" "${MAKO_CONFIG}.backup"

    # Update the background and border colors in the mako config
    # We're assuming these are on lines 2 and 3 as specified
    sed -i "2s|.*|background-color=$bg_color|" "$MAKO_CONFIG"
    sed -i "3s|.*|border-color=$accent_color|" "$MAKO_CONFIG"

    # Reload mako
    pkill mako
    mako &

    echo "Mako theme changed to $theme with background: $bg_color and accent: $accent_color"
}

# Function to apply doom emacs theme
apply_doom_theme() {
    local theme=$1
    # Check if theme is valid for doom
    if [[ ! " ${DOOM_THEME_NAMES[*]} " =~ " ${theme} " ]]; then
        echo "Error: Invalid theme for Doom Emacs: $theme"
        return 1
    fi

    # Get the doom theme name
    local doom_theme="${DOOM_THEMES[$theme]}"

    # Check if doom theme is defined
    if [[ -z "$doom_theme" ]]; then
        echo "Error: Missing Doom theme mapping for: $theme"
        return 1
    fi

    # Backup the original file
    cp "$DOOM_CONFIG" "${DOOM_CONFIG}.backup"

    # Update line 35 with the correct theme setting
    # Using the correct syntax as specified
    sed -i "35s|.*|(setq doom-theme '$doom_theme)|" "$DOOM_CONFIG"

    # Sync and restart emacs daemon
    ~/.emacs.d/bin/doom sync
    pkill emacs
    emacs --daemon

    echo "Doom Emacs theme changed to $doom_theme"
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

    "rofi")
        # Check if rofi config file exists
        check_file "$ROFI_CONFIG" || exit 1

        # Select theme for rofi
        SELECTED_THEME=$(printf "%s\n" "${ROFI_THEMES[@]}" | rofi -dmenu -i -p "Select Rofi Theme:")

        # Exit if canceled
        if [ -z "$SELECTED_THEME" ]; then
            echo "Theme selection cancelled"
            exit 0
        fi

        apply_rofi_theme "$SELECTED_THEME"
        ;;

    "nwg")
        # Select theme for nwg-wrapper
        SELECTED_THEME=$(printf "%s\n" "${NWG_THEMES[@]}" | rofi -dmenu -i -p "Select NWG-Wrapper Theme:")

        # Exit if canceled
        if [ -z "$SELECTED_THEME" ]; then
            echo "Theme selection cancelled"
            exit 0
        fi

        apply_nwg_theme "$SELECTED_THEME"
        ;;

    "mako")
        # Check if mako config file exists
        check_file "$MAKO_CONFIG" || exit 1

        # Select theme for mako
        SELECTED_THEME=$(printf "%s\n" "${MAKO_THEMES[@]}" | rofi -dmenu -i -p "Select Mako Theme:")

        # Exit if canceled
        if [ -z "$SELECTED_THEME" ]; then
            echo "Theme selection cancelled"
            exit 0
        fi

        apply_mako_theme "$SELECTED_THEME"
        ;;

    "doom")
        # Check if doom config file exists
        check_file "$DOOM_CONFIG" || exit 1

        # Select theme for doom
        SELECTED_THEME=$(printf "%s\n" "${DOOM_THEME_NAMES[@]}" | rofi -dmenu -i -p "Select Doom Emacs Theme:")

        # Exit if canceled
        if [ -z "$SELECTED_THEME" ]; then
            echo "Theme selection cancelled"
            exit 0
        fi

        apply_doom_theme "$SELECTED_THEME"
        ;;

    "wallpaper")
        # Get available themes with wallpapers
        WALLPAPER_THEMES=()
        for theme in "${!WALLPAPERS[@]}"; do
            WALLPAPER_THEMES+=("$theme")
        done

        # Select theme for wallpaper
        SELECTED_THEME=$(printf "%s\n" "${WALLPAPER_THEMES[@]}" | rofi -dmenu -i -p "Select Wallpaper Theme:")

        # Exit if canceled
        if [ -z "$SELECTED_THEME" ]; then
            echo "Wallpaper selection cancelled"
            exit 0
        fi

        apply_wallpaper "$SELECTED_THEME"
        ;;

    "all")
        # Check if all config files exist
        check_file "$WAYBAR_STYLE" || exit 1
        check_file "$KITTY_CONFIG" || exit 1
        check_file "$ROFI_CONFIG" || exit 1
        check_file "$MAKO_CONFIG" || exit 1
        check_file "$DOOM_CONFIG" || exit 1

        # Find common themes among all apps
        COMMON_THEMES=($(find_common_themes "waybar" "kitty" "rofi" "nwg" "mako" "doom"))

        if [ ${#COMMON_THEMES[@]} -eq 0 ]; then
            echo "Error: No common themes found among all applications"
            exit 1
        fi

        # Select a common theme
        SELECTED_THEME=$(printf "%s\n" "${COMMON_THEMES[@]}" | rofi -dmenu -i -p "Select Theme for All Apps:")

        # Exit if canceled
        if [ -z "$SELECTED_THEME" ]; then
            echo "Theme selection cancelled"
            exit 0
        fi

        apply_waybar_theme "$SELECTED_THEME"
        apply_kitty_theme "$SELECTED_THEME"
        apply_rofi_theme "$SELECTED_THEME"
        apply_nwg_theme "$SELECTED_THEME"
        apply_mako_theme "$SELECTED_THEME"
        apply_doom_theme "$SELECTED_THEME"

        # Apply wallpaper if available for this theme
        if [[ -n "${WALLPAPERS[$SELECTED_THEME]}" ]]; then
            apply_wallpaper "$SELECTED_THEME"
        fi
        ;;

    "wallpaper+all")
        # Check if all config files exist
        check_file "$WAYBAR_STYLE" || exit 1
        check_file "$KITTY_CONFIG" || exit 1
        check_file "$ROFI_CONFIG" || exit 1
        check_file "$MAKO_CONFIG" || exit 1
        check_file "$DOOM_CONFIG" || exit 1

        # Find common themes among all apps that also have wallpapers
        COMMON_THEMES=($(find_common_themes "waybar" "kitty" "rofi" "nwg" "mako" "doom" "wallpaper"))

        if [ ${#COMMON_THEMES[@]} -eq 0 ]; then
            echo "Error: No common themes found among all applications with wallpapers"
            exit 1
        fi

        # Select a common theme
        SELECTED_THEME=$(printf "%s\n" "${COMMON_THEMES[@]}" | rofi -dmenu -i -p "Select Theme for Everything:")

        # Exit if canceled
        if [ -z "$SELECTED_THEME" ]; then
            echo "Theme selection cancelled"
            exit 0
        fi

        apply_waybar_theme "$SELECTED_THEME"
        apply_kitty_theme "$SELECTED_THEME"
        apply_rofi_theme "$SELECTED_THEME"
        apply_nwg_theme "$SELECTED_THEME"
        apply_mako_theme "$SELECTED_THEME"
        apply_doom_theme "$SELECTED_THEME"
        apply_wallpaper "$SELECTED_THEME"
        ;;

    "waybar+kitty")
        # Check if both config files exist
        check_file "$WAYBAR_STYLE" || exit 1
        check_file "$KITTY_CONFIG" || exit 1

        # Find common themes between waybar and kitty
        COMMON_THEMES=($(find_common_themes "waybar" "kitty"))

        if [ ${#COMMON_THEMES[@]} -eq 0 ]; then
            echo "Error: No common themes found between Waybar and Kitty"
            exit 1
        fi

        # Select a common theme
        SELECTED_THEME=$(printf "%s\n" "${COMMON_THEMES[@]}" | rofi -dmenu -i -p "Select Theme for Waybar+Kitty:")

        # Exit if canceled
        if [ -z "$SELECTED_THEME" ]; then
            echo "Theme selection cancelled"
            exit 0
        fi

        apply_waybar_theme "$SELECTED_THEME"
        apply_kitty_theme "$SELECTED_THEME"

        # Apply wallpaper if available for this theme
        if [[ -n "${WALLPAPERS[$SELECTED_THEME]}" ]]; then
            apply_wallpaper "$SELECTED_THEME"
        fi
        ;;

    "waybar+rofi")
        # Check if both config files exist
        check_file "$WAYBAR_STYLE" || exit 1
        check_file "$ROFI_CONFIG" || exit 1

        # Find common themes between waybar and rofi
        COMMON_THEMES=($(find_common_themes "waybar" "rofi"))

        if [ ${#COMMON_THEMES[@]} -eq 0 ]; then
            echo "Error: No common themes found between Waybar and Rofi"
            exit 1
        fi

        # Select a common theme
        SELECTED_THEME=$(printf "%s\n" "${COMMON_THEMES[@]}" | rofi -dmenu -i -p "Select Theme for Waybar+Rofi:")

        # Exit if canceled
        if [ -z "$SELECTED_THEME" ]; then
            echo "Theme selection cancelled"
            exit 0
        fi

        apply_waybar_theme "$SELECTED_THEME"
        apply_rofi_theme "$SELECTED_THEME"

        # Apply wallpaper if available for this theme
        if [[ -n "${WALLPAPERS[$SELECTED_THEME]}" ]]; then
            apply_wallpaper "$SELECTED_THEME"
        fi
        ;;

    "kitty+rofi")
        # Check if both config files exist
        check_file "$KITTY_CONFIG" || exit 1
        check_file "$ROFI_CONFIG" || exit 1

        # Find common themes between kitty and rofi
        COMMON_THEMES=($(find_common_themes "kitty" "rofi"))

        if [ ${#COMMON_THEMES[@]} -eq 0 ]; then
            echo "Error: No common themes found between Kitty and Rofi"
            exit 1
        fi

        # Select a common theme
        SELECTED_THEME=$(printf "%s\n" "${COMMON_THEMES[@]}" | rofi -dmenu -i -p "Select Theme for Kitty+Rofi:")

        # Exit if canceled
        if [ -z "$SELECTED_THEME" ]; then
            echo "Theme selection cancelled"
            exit 0
        fi

        apply_kitty_theme "$SELECTED_THEME"
        apply_rofi_theme "$SELECTED_THEME"

        # Apply wallpaper if available for this theme
        if [[ -n "${WALLPAPERS[$SELECTED_THEME]}" ]]; then
            apply_wallpaper "$SELECTED_THEME"
        fi
        ;;

    *)
        echo "Invalid option selected"
        exit 1
        ;;
esac

echo "Theme switching completed successfully!"
notify-send "Global Theme" "New Theme Set: $SELECTED_THEME"
