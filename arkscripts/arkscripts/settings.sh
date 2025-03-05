#!/bin/bash

# Hyprland Settings Script with Zenity

# Color for echo outputs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display error message
error_msg() {
    zenity --error --title="Error" --text="$1"
}

# Function to check if hyprctl is available
check_hyprland() {
    if ! command -v hyprctl &> /dev/null; then
        error_msg "Hyprland is not installed or hyprctl is not in PATH"
        exit 1
    fi
}

# Display Settings Menu
display_settings() {
    local choice=$(zenity --list --title="Display Settings" --column="Option" \
        "Change Refresh Rate" \
        "Toggle VRR" \
        "Adjust Display Scaling" \
        --width=300 --height=250)

    case "$choice" in
        "Change Refresh Rate")
            local rates=("60 Hz" "90 Hz" "120 Hz" "144 Hz" "240 Hz")
            local selected=$(zenity --list --title="Select Refresh Rate" \
                --column="Refresh Rates" "${rates[@]}" --width=200 --height=300)

            if [[ -n "$selected" ]]; then
                # Extract numeric value
                local hz=$(echo "$selected" | cut -d' ' -f1)
                hyprctl keyword monitor eDP-1,highrr,"$hz"
                zenity --info --title="Refresh Rate" --text="Refresh rate set to $selected"
            fi
            ;;

        "Toggle VRR")
            local vrr_status=$(zenity --question --title="VRR" --text="Enable Variable Refresh Rate?" \
                --ok-label="Yes" --cancel-label="No")

            if [[ $? -eq 0 ]]; then
                hyprctl keyword misc:vrr 1
                zenity --info --title="VRR" --text="Variable Refresh Rate Enabled"
            else
                hyprctl keyword misc:vrr 0
                zenity --info --title="VRR" --text="Variable Refresh Rate Disabled"
            fi
            ;;

        "Adjust Display Scaling")
            local scales=("1.0" "1.25" "1.5" "1.75" "2.0")
            local selected=$(zenity --list --title="Display Scaling" \
                --column="Scaling Factor" "${scales[@]}" --width=200 --height=300)

            if [[ -n "$selected" ]]; then
                hyprctl keyword monitor eDP-1,scale,"$selected"
                zenity --info --title="Display Scaling" --text="Display scaled to $selected"
            fi
            ;;
    esac
}

# Input Settings Menu
input_settings() {
    local choice=$(zenity --list --title="Input Settings" --column="Option" \
        "Mouse Sensitivity" \
        "Touchpad Natural Scroll" \
        "Tap to Click" \
        --width=300 --height=250)

    case "$choice" in
        "Mouse Sensitivity")
            local sensitivity=$(zenity --scale --title="Mouse Sensitivity" \
                --text="Adjust Mouse Sensitivity" \
                --min-value=-1 --max-value=1 --value=0 --step=0.1)

            if [[ -n "$sensitivity" ]]; then
                hyprctl keyword input:sensitivity "$sensitivity"
                zenity --info --title="Mouse Sensitivity" --text="Sensitivity set to $sensitivity"
            fi
            ;;

        "Touchpad Natural Scroll")
            local scroll_status=$(zenity --question --title="Natural Scroll" \
                --text="Enable Natural Scrolling?" \
                --ok-label="Yes" --cancel-label="No")

            if [[ $? -eq 0 ]]; then
                hyprctl keyword input:touchpad:natural_scroll true
                zenity --info --title="Natural Scroll" --text="Natural Scrolling Enabled"
            else
                hyprctl keyword input:touchpad:natural_scroll false
                zenity --info --title="Natural Scroll" --text="Natural Scrolling Disabled"
            fi
            ;;

        "Tap to Click")
            local tap_status=$(zenity --question --title="Tap to Click" \
                --text="Enable Tap to Click?" \
                --ok-label="Yes" --cancel-label="No")

            if [[ $? -eq 0 ]]; then
                hyprctl keyword input:touchpad:tap-to-click true
                zenity --info --title="Tap to Click" --text="Tap to Click Enabled"
            else
                hyprctl keyword input:touchpad:tap-to-click false
                zenity --info --title="Tap to Click" --text="Tap to Click Disabled"
            fi
            ;;
    esac
}

# Appearance Settings Menu
appearance_settings() {
    local choice=$(zenity --list --title="Appearance Settings" --column="Option" \
        "Change GTK Theme" \
        "Window Border Size" \
        "Border Color" \
        --width=300 --height=250)

    case "$choice" in
        "Change GTK Theme")
            local themes=($(ls /usr/share/themes))
            local selected=$(zenity --list --title="GTK Themes" \
                --column="Available Themes" "${themes[@]}" --width=300 --height=400)

            if [[ -n "$selected" ]]; then
                gsettings set org.gnome.desktop.interface gtk-theme "$selected"
                zenity --info --title="GTK Theme" --text="Theme set to $selected"
            fi
            ;;

        "Window Border Size")
            local border_size=$(zenity --scale --title="Border Size" \
                --text="Adjust Window Border Size" \
                --min-value=1 --max-value=5 --value=2 --step=1)

            if [[ -n "$border_size" ]]; then
                hyprctl keyword general:border_size "$border_size"
                zenity --info --title="Border Size" --text="Border size set to $border_size"
            fi
            ;;

        "Border Color")
            local color=$(zenity --color-selection --title="Choose Border Color")

            if [[ -n "$color" ]]; then
                # Convert color to RGBA format for Hyprland
                rgba_color=$(echo "$color" | sed 's/rgb(/rgba(/; s/)/,1.0)/')
                hyprctl keyword general:col.active_border "$rgba_color"
                zenity --info --title="Border Color" --text="Border color updated"
            fi
            ;;
    esac
}

# Workspace Settings Menu
workspace_settings() {
    local choice=$(zenity --list --title="Workspace Settings" --column="Option" \
        "Bind Workspace to Monitor" \
        "Adjust Workspace Gaps" \
        --width=300 --height=250)

    case "$choice" in
        "Bind Workspace to Monitor")
            local monitors=($(hyprctl monitors | grep Monitor | cut -d: -f2 | tr -d ' '))
            local selected_monitor=$(zenity --list --title="Select Monitor" \
                --column="Available Monitors" "${monitors[@]}" --width=300 --height=250)

            if [[ -n "$selected_monitor" ]]; then
                local workspace=$(zenity --entry --title="Workspace Number" \
                    --text="Enter workspace number to bind:")

                if [[ -n "$workspace" ]]; then
                    hyprctl keyword workspace "$workspace" output "$selected_monitor"
                    zenity --info --title="Workspace Binding" \
                        --text="Workspace $workspace bound to $selected_monitor"
                fi
            fi
            ;;

        "Adjust Workspace Gaps")
            local inner_gaps=$(zenity --scale --title="Inner Gaps" \
                --text="Adjust Inner Workspace Gaps" \
                --min-value=0 --max-value=20 --value=5 --step=1)

            local outer_gaps=$(zenity --scale --title="Outer Gaps" \
                --text="Adjust Outer Workspace Gaps" \
                --min-value=0 --max-value=20 --value=10 --step=1)

            if [[ -n "$inner_gaps" ]] && [[ -n "$outer_gaps" ]]; then
                hyprctl keyword general:gaps_in "$inner_gaps"
                hyprctl keyword general:gaps_out "$outer_gaps"
                zenity --info --title="Workspace Gaps" \
                    --text="Inner gaps: $inner_gaps, Outer gaps: $outer_gaps"
            fi
            ;;
    esac
}

# Main Menu
main_menu() {
    check_hyprland

    local choice=$(zenity --list --title="Hyprland Settings" --column="Option" \
        "Display Settings" \
        "Input Settings" \
        "Appearance Settings" \
        "Workspace Settings" \
        --width=300 --height=300)

    case "$choice" in
        "Display Settings") display_settings ;;
        "Input Settings") input_settings ;;
        "Appearance Settings") appearance_settings ;;
        "Workspace Settings") workspace_settings ;;
    esac
}

# Run the script
main_menu
