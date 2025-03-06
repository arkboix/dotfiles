#!/bin/bash

# Configuration file to store settings
CONFIG_FILE="$HOME/.config/hypr/custom_settings.conf"
# Command history file to store executed hyprctl commands
COMMAND_HISTORY="$HOME/.config/hypr/hyprctl_commands.log"

# Make sure the config file exists
touch "$CONFIG_FILE"
# Create or clear the command history file
> "$COMMAND_HISTORY"

# Function to show settings menu
show_settings_menu() {
    # Define available settings categories
    categories=(
        "Animations"
        "Decorations"
        "Input"
        "Workspace"
        "Miscellaneous"
        "Exit"
    )

    # Show categories in Rofi
    selected_category=$(printf "%s\n" "${categories[@]}" | rofi -dmenu -i -p "Select Settings Category")

    case "$selected_category" in
        "Animations")
            show_animation_settings
            ;;
        "Decorations")
            show_decoration_settings
            ;;
        "Input")
            show_input_settings
            ;;
        "Workspace")
            show_workspace_settings
            ;;
        "Miscellaneous")
            show_misc_settings
            ;;
        "Exit")
            exit 0
            ;;
        *)
            # If no valid selection, show main menu again
            show_settings_menu
            ;;
    esac
}

# Function to get current value of a setting
get_current_value() {
    local setting="$1"
    if grep -q "^$setting " "$CONFIG_FILE"; then
        grep "^$setting " "$CONFIG_FILE" | cut -d' ' -f2-
    else
        echo "Not set"
    fi
}

# Function to save setting and execute it
save_setting() {
    local setting="$1"
    local value="$2"

    # Remove existing setting if present
    sed -i "/^$setting /d" "$CONFIG_FILE"

    # Add new setting
    echo "$setting $value" >> "$CONFIG_FILE"

    # Notify user
    notify-send "Hyprland Settings" "Updated $setting to $value"

    # Apply setting immediately and record the command
    hyprctl keyword "$setting" "$value"
    echo "hyprctl keyword \"$setting\" \"$value\"" >> "$COMMAND_HISTORY"
}

# Animation settings menu
show_animation_settings() {
    options=(
        "animations:enabled ($(get_current_value "animations:enabled"))"
        "animations:duration ($(get_current_value "animations:duration"))"
        "animations:curve ($(get_current_value "animations:curve"))"
        "animations:windows ($(get_current_value "animations:windows"))"
        "animations:workspaces ($(get_current_value "animations:workspaces"))"
        "Back to main menu"
    )

    selected=$(printf "%s\n" "${options[@]}" | rofi -dmenu -i -p "Animation Settings")

    case "$selected" in
        "animations:enabled"*)
            toggle_value=$(get_current_value "animations:enabled")
            if [ "$toggle_value" = "true" ] || [ "$toggle_value" = "1" ]; then
                new_value="false"
            else
                new_value="true"
            fi
            save_setting "animations:enabled" "$new_value"
            show_animation_settings
            ;;
        "animations:duration"*)
            value=$(rofi -dmenu -i -p "Enter duration (ms)")
            if [[ "$value" =~ ^[0-9]+$ ]]; then
                save_setting "animations:duration" "$value"
            fi
            show_animation_settings
            ;;
        "animations:curve"*)
            curves=("default" "linear" "easeInOut" "easeInSine" "easeOutSine" "easeInQuad" "easeOutQuad" "easeInCubic" "easeOutCubic")
            selected_curve=$(printf "%s\n" "${curves[@]}" | rofi -dmenu -i -p "Select animation curve")
            if [ -n "$selected_curve" ]; then
                save_setting "animations:curve" "$selected_curve"
            fi
            show_animation_settings
            ;;
        "animations:windows"*)
            toggle_value=$(get_current_value "animations:windows")
            if [ "$toggle_value" = "true" ] || [ "$toggle_value" = "1" ]; then
                new_value="false"
            else
                new_value="true"
            fi
            save_setting "animations:windows" "$new_value"
            show_animation_settings
            ;;
        "animations:workspaces"*)
            toggle_value=$(get_current_value "animations:workspaces")
            if [ "$toggle_value" = "true" ] || [ "$toggle_value" = "1" ]; then
                new_value="false"
            else
                new_value="true"
            fi
            save_setting "animations:workspaces" "$new_value"
            show_animation_settings
            ;;
        "Back to main menu")
            show_settings_menu
            ;;
        *)
            show_animation_settings
            ;;
    esac
}

# Decoration settings menu
show_decoration_settings() {
    options=(
        "decoration:rounding ($(get_current_value "decoration:rounding"))"
        "decoration:blur ($(get_current_value "decoration:blur"))"
        "decoration:blur:size ($(get_current_value "decoration:blur:size"))"
        "decoration:blur:passes ($(get_current_value "decoration:blur:passes"))"
        "decoration:active_opacity ($(get_current_value "decoration:active_opacity"))"
        "decoration:inactive_opacity ($(get_current_value "decoration:inactive_opacity"))"
        "decoration:shadow_range ($(get_current_value "decoration:shadow_range"))"
        "Back to main menu"
    )

    selected=$(printf "%s\n" "${options[@]}" | rofi -dmenu -i -p "Decoration Settings")

    case "$selected" in
        "decoration:rounding"*)
            value=$(rofi -dmenu -i -p "Enter corner rounding (px)")
            if [[ "$value" =~ ^[0-9]+$ ]]; then
                save_setting "decoration:rounding" "$value"
            fi
            show_decoration_settings
            ;;
        "decoration:blur"*)
            toggle_value=$(get_current_value "decoration:blur")
            if [ "$toggle_value" = "true" ] || [ "$toggle_value" = "1" ]; then
                new_value="false"
            else
                new_value="true"
            fi
            save_setting "decoration:blur" "$new_value"
            show_decoration_settings
            ;;
        "decoration:blur:size"*)
            value=$(rofi -dmenu -i -p "Enter blur size")
            if [[ "$value" =~ ^[0-9]+$ ]]; then
                save_setting "decoration:blur:size" "$value"
            fi
            show_decoration_settings
            ;;
        "decoration:blur:passes"*)
            value=$(rofi -dmenu -i -p "Enter blur passes")
            if [[ "$value" =~ ^[0-9]+$ ]]; then
                save_setting "decoration:blur:passes" "$value"
            fi
            show_decoration_settings
            ;;
        "decoration:active_opacity"*)
            value=$(rofi -dmenu -i -p "Enter active opacity (0.0-1.0)")
            if [[ "$value" =~ ^[0-9]*\.?[0-9]+$ ]] && (( $(echo "$value <= 1.0" | bc -l) )); then
                save_setting "decoration:active_opacity" "$value"
            fi
            show_decoration_settings
            ;;
        "decoration:inactive_opacity"*)
            value=$(rofi -dmenu -i -p "Enter inactive opacity (0.0-1.0)")
            if [[ "$value" =~ ^[0-9]*\.?[0-9]+$ ]] && (( $(echo "$value <= 1.0" | bc -l) )); then
                save_setting "decoration:inactive_opacity" "$value"
            fi
            show_decoration_settings
            ;;
        "decoration:shadow_range"*)
            value=$(rofi -dmenu -i -p "Enter shadow range (px)")
            if [[ "$value" =~ ^[0-9]+$ ]]; then
                save_setting "decoration:shadow_range" "$value"
            fi
            show_decoration_settings
            ;;
        "Back to main menu")
            show_settings_menu
            ;;
        *)
            show_decoration_settings
            ;;
    esac
}

# Input settings menu
show_input_settings() {
    options=(
        "input:sensitivity ($(get_current_value "input:sensitivity"))"
        "input:kb_layout ($(get_current_value "input:kb_layout"))"
        "input:follow_mouse ($(get_current_value "input:follow_mouse"))"
        "input:touchpad:natural_scroll ($(get_current_value "input:touchpad:natural_scroll"))"
        "input:touchpad:tap-to-click ($(get_current_value "input:touchpad:tap-to-click"))"
        "Back to main menu"
    )

    selected=$(printf "%s\n" "${options[@]}" | rofi -dmenu -i -p "Input Settings")

    case "$selected" in
        "input:sensitivity"*)
            value=$(rofi -dmenu -i -p "Enter mouse sensitivity (-1.0 to 1.0)")
            if [[ "$value" =~ ^-?[0-9]*\.?[0-9]+$ ]] && (( $(echo "$value <= 1.0 && $value >= -1.0" | bc -l) )); then
                save_setting "input:sensitivity" "$value"
            fi
            show_input_settings
            ;;
        "input:kb_layout"*)
            value=$(rofi -dmenu -i -p "Enter keyboard layout (e.g., us,de,fr)")
            if [ -n "$value" ]; then
                save_setting "input:kb_layout" "$value"
            fi
            show_input_settings
            ;;
        "input:follow_mouse"*)
            options=("0 (disabled)" "1 (focus follows mouse)" "2 (mouse warps to center of focused window)")
            value=$(printf "%s\n" "${options[@]}" | rofi -dmenu -i -p "Select focus follow mode")
            if [[ "$value" =~ ^[0-2] ]]; then
                save_setting "input:follow_mouse" "${value:0:1}"
            fi
            show_input_settings
            ;;
        "input:touchpad:natural_scroll"*)
            toggle_value=$(get_current_value "input:touchpad:natural_scroll")
            if [ "$toggle_value" = "true" ] || [ "$toggle_value" = "1" ]; then
                new_value="false"
            else
                new_value="true"
            fi
            save_setting "input:touchpad:natural_scroll" "$new_value"
            show_input_settings
            ;;
        "input:touchpad:tap-to-click"*)
            toggle_value=$(get_current_value "input:touchpad:tap-to-click")
            if [ "$toggle_value" = "true" ] || [ "$toggle_value" = "1" ]; then
                new_value="false"
            else
                new_value="true"
            fi
            save_setting "input:touchpad:tap-to-click" "$new_value"
            show_input_settings
            ;;
        "Back to main menu")
            show_settings_menu
            ;;
        *)
            show_input_settings
            ;;
    esac
}

# Workspace settings menu
show_workspace_settings() {
    options=(
        "workspace:swipe_fingers ($(get_current_value "workspace:swipe_fingers"))"
        "workspace:swipe_distance ($(get_current_value "workspace:swipe_distance"))"
        "workspace:swipe_invert ($(get_current_value "workspace:swipe_invert"))"
        "workspace:swipe_min_speed_to_force ($(get_current_value "workspace:swipe_min_speed_to_force"))"
        "workspace:gaps_in ($(get_current_value "general:gaps_in"))"
        "workspace:gaps_out ($(get_current_value "general:gaps_out"))"
        "Back to main menu"
    )

    selected=$(printf "%s\n" "${options[@]}" | rofi -dmenu -i -p "Workspace Settings")

    case "$selected" in
        "workspace:swipe_fingers"*)
            value=$(rofi -dmenu -i -p "Enter number of fingers for swipe (usually 3 or 4)")
            if [[ "$value" =~ ^[0-9]+$ ]]; then
                save_setting "workspace:swipe_fingers" "$value"
            fi
            show_workspace_settings
            ;;
        "workspace:swipe_distance"*)
            value=$(rofi -dmenu -i -p "Enter swipe distance")
            if [[ "$value" =~ ^[0-9]+$ ]]; then
                save_setting "workspace:swipe_distance" "$value"
            fi
            show_workspace_settings
            ;;
        "workspace:swipe_invert"*)
            toggle_value=$(get_current_value "workspace:swipe_invert")
            if [ "$toggle_value" = "true" ] || [ "$toggle_value" = "1" ]; then
                new_value="false"
            else
                new_value="true"
            fi
            save_setting "workspace:swipe_invert" "$new_value"
            show_workspace_settings
            ;;
        "workspace:swipe_min_speed_to_force"*)
            value=$(rofi -dmenu -i -p "Enter minimum swipe speed")
            if [[ "$value" =~ ^[0-9]+$ ]]; then
                save_setting "workspace:swipe_min_speed_to_force" "$value"
            fi
            show_workspace_settings
            ;;
        "workspace:gaps_in"*)
            value=$(rofi -dmenu -i -p "Enter inner gaps size (px)")
            if [[ "$value" =~ ^[0-9]+$ ]]; then
                save_setting "general:gaps_in" "$value"
            fi
            show_workspace_settings
            ;;
        "workspace:gaps_out"*)
            value=$(rofi -dmenu -i -p "Enter outer gaps size (px)")
            if [[ "$value" =~ ^[0-9]+$ ]]; then
                save_setting "general:gaps_out" "$value"
            fi
            show_workspace_settings
            ;;
        "Back to main menu")
            show_settings_menu
            ;;
        *)
            show_workspace_settings
            ;;
    esac
}

# Miscellaneous settings menu
show_misc_settings() {
    options=(
        "misc:disable_hyprland_logo ($(get_current_value "misc:disable_hyprland_logo"))"
        "misc:disable_splash_rendering ($(get_current_value "misc:disable_splash_rendering"))"
        "misc:force_default_wallpaper ($(get_current_value "misc:force_default_wallpaper"))"
        "misc:vfr ($(get_current_value "misc:vfr"))"
        "misc:mouse_move_enables_dpms ($(get_current_value "misc:mouse_move_enables_dpms"))"
        "general:border_size ($(get_current_value "general:border_size"))"
        "general:cursor_inactive_timeout ($(get_current_value "general:cursor_inactive_timeout"))"
        "Back to main menu"
    )

    selected=$(printf "%s\n" "${options[@]}" | rofi -dmenu -i -p "Miscellaneous Settings")

    case "$selected" in
        "misc:disable_hyprland_logo"*)
            toggle_value=$(get_current_value "misc:disable_hyprland_logo")
            if [ "$toggle_value" = "true" ] || [ "$toggle_value" = "1" ]; then
                new_value="false"
            else
                new_value="true"
            fi
            save_setting "misc:disable_hyprland_logo" "$new_value"
            show_misc_settings
            ;;
        "misc:disable_splash_rendering"*)
            toggle_value=$(get_current_value "misc:disable_splash_rendering")
            if [ "$toggle_value" = "true" ] || [ "$toggle_value" = "1" ]; then
                new_value="false"
            else
                new_value="true"
            fi
            save_setting "misc:disable_splash_rendering" "$new_value"
            show_misc_settings
            ;;
        "misc:force_default_wallpaper"*)
            value=$(rofi -dmenu -i -p "Enter value (0-5, 0 to disable)")
            if [[ "$value" =~ ^[0-5]$ ]]; then
                save_setting "misc:force_default_wallpaper" "$value"
            fi
            show_misc_settings
            ;;
        "misc:vfr"*)
            toggle_value=$(get_current_value "misc:vfr")
            if [ "$toggle_value" = "true" ] || [ "$toggle_value" = "1" ]; then
                new_value="false"
            else
                new_value="true"
            fi
            save_setting "misc:vfr" "$new_value"
            show_misc_settings
            ;;
        "misc:mouse_move_enables_dpms"*)
            toggle_value=$(get_current_value "misc:mouse_move_enables_dpms")
            if [ "$toggle_value" = "true" ] || [ "$toggle_value" = "1" ]; then
                new_value="false"
            else
                new_value="true"
            fi
            save_setting "misc:mouse_move_enables_dpms" "$new_value"
            show_misc_settings
            ;;
        "general:border_size"*)
            value=$(rofi -dmenu -i -p "Enter border size (px)")
            if [[ "$value" =~ ^[0-9]+$ ]]; then
                save_setting "general:border_size" "$value"
            fi
            show_misc_settings
            ;;
        "general:cursor_inactive_timeout"*)
            value=$(rofi -dmenu -i -p "Enter cursor inactive timeout (seconds)")
            if [[ "$value" =~ ^[0-9]+$ ]]; then
                save_setting "general:cursor_inactive_timeout" "$value"
            fi
            show_misc_settings
            ;;
        "Back to main menu")
            show_settings_menu
            ;;
        *)
            show_misc_settings
            ;;
    esac
}

# Create hyprctl.sh script that records and applies all executed commands
create_hyprctl_script() {
    cat > "$HOME/.config/hypr/hyprctl.sh" << EOF
#!/bin/bash

# Generated by Hyprland Settings Manager
# This script applies all hyprctl commands that were executed in the settings manager

EOF

    # Add all executed commands to the script
    if [ -f "$COMMAND_HISTORY" ]; then
        cat "$COMMAND_HISTORY" >> "$HOME/.config/hypr/hyprctl.sh"
    fi

    # Make the script executable
    chmod +x "$HOME/.config/hypr/hyprctl.sh"

    # Create sample entry for hyprland.conf to autostart
    echo -e "\n# Add the following line to your hyprland.conf to autostart:"
    echo "# exec-once = ~/.config/hypr/hyprctl.sh"

    notify-send "Hyprland Settings" "Created hyprctl.sh script to apply settings on startup."
}

# Initial menu display
show_settings_menu

# Create hyprctl.sh script when exiting
create_hyprctl_script
