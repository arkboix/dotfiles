#!/bin/bash
# Arkscripts - https://github.com/arkboix/dotfiles

# Kill existing waybar instances
killall waybar
killall gBar

# Discover all theme folders in .config/waybar
waybar_config_dir="$HOME/.config/waybar"
declare -A themes

# Add gBar (not waybar) as a special case
themes["gBar (Not Waybar)"]="gBar bar 0"

# Find all subdirectories in the waybar config directory
for folder in "$waybar_config_dir"/*; do
    if [ -d "$folder" ] && [ -f "$folder/config.jsonc" ] && [ -f "$folder/style.css" ]; then
        folder_name=$(basename "$folder")
        themes["$folder_name"]="waybar -c $waybar_config_dir/$folder_name/config.jsonc -s $waybar_config_dir/$folder_name/style.css"
    fi
done

# Use rofi to select theme
selected_theme=$(printf '%s\n' "${!themes[@]}" | sort | rofi -dmenu -p "Select Waybar Theme")

# Check if a theme was selected
if [[ -n "$selected_theme" ]]; then
    # Get the corresponding command
    theme_command="${themes[$selected_theme]}"

    # Update autostart configuration file
    autostart_file="$HOME/.config/hypr/conf/autostart.conf"

    # Look for line that starts with exec-once = waybar and replace it
    if grep -q "^exec-once = waybar" "$autostart_file"; then
        sed -i '/^exec-once = waybar/c\exec-once = '"$theme_command" "$autostart_file"
    elif grep -q "^exec-once = gBar" "$autostart_file"; then
        sed -i '/^exec-once = gBar/c\exec-once = '"$theme_command" "$autostart_file"
    else
        # If neither waybar nor gBar is found, append the command
        echo "exec-once = $theme_command" >> "$autostart_file"
    fi

    # Update reload script
    reload_script="$HOME/arkscripts/reload.sh"
    if [ -f "$reload_script" ]; then
        # Look for line that starts with waybar and replace it
        if grep -q "^waybar" "$reload_script"; then
            sed -i '/^waybar/c\'"$theme_command" "$reload_script"
        # Also check for gBar
        elif grep -q "^gBar" "$reload_script"; then
            sed -i '/^gBar/c\'"$theme_command" "$reload_script"
        else
            # If no waybar or gBar command found, add it at line 8 (fallback to original behavior)
            sed -i '8c\'"$theme_command" "$reload_script"
        fi
    fi

    # Launch the selected theme
    eval "$theme_command"
    notify-send "Waybar Theme" "Set to: $selected_theme"
    sleep 1
else
    # Notify if no theme was selected
    notify-send "Waybar Theme" "No theme selected"

    # Default theme fallback
    default_folder="theme-6" # Keeping original default
    if [ -d "$waybar_config_dir/$default_folder" ]; then
        waybar -c "$waybar_config_dir/$default_folder/config.jsonc" -s "$waybar_config_dir/$default_folder/style.css"
    else
        # If default folder doesn't exist, use the first available theme
        first_theme=$(ls -d "$waybar_config_dir"/*/ 2>/dev/null | head -1)
        if [ -n "$first_theme" ]; then
            folder_name=$(basename "$first_theme")
            waybar -c "$waybar_config_dir/$folder_name/config.jsonc" -s "$waybar_config_dir/$folder_name/style.css"
        fi
    fi
fi
