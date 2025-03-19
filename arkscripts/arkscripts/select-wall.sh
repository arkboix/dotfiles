#!/bin/bash
# Arkscripts - https://github.com/arkboix/dotfiles
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */
# This script for selecting wallpapers

# WALLPAPERS PATHS
target_terminal=kitty
wallDIRS=("$HOME/wallpapers" "$HOME/wallpapers-extra")
SCRIPTSDIR="$HOME/arkscripts"

# Directory for swaync
iDIR="$HOME/.config/swaync/images"
iDIRi="$HOME/.config/swaync/icons"

# Variables
focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')

# Monitor details
scale_factor=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .scale')
monitor_height=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .height')

icon_size=$(echo "scale=1; ($monitor_height * 3) / ($scale_factor * 150)" | bc)

# Apply limit
adjusted_icon_size=$(echo "$icon_size" | awk '{if ($1 < 15) $1 = 20; if ($1 > 25) $1 = 25; print $1}')

# Rofi icon size override
rofi_override="element-icon{size:${adjusted_icon_size}%;}"

# swww transition config
FPS=60
TYPE="random"
DURATION=1
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"

# Check if swaybg is running
if pidof swaybg > /dev/null; then
  pkill swaybg
fi

# Retrieve image files from multiple directories
PICS=()
for dir in "${wallDIRS[@]}"; do
  while IFS= read -r -d '' file; do
    PICS+=("$file")
  done < <(find -L "$dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.pnm" -o -iname "*.tga" -o -iname "*.tiff" -o -iname "*.webp" -o -iname "*.bmp" -o -iname "*.farbfeld" -o -iname "*.png" -o -iname "*.gif" \) -print0)
done

RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
RANDOM_PIC_NAME=". random"

# Rofi command
rofi_command="rofi -dmenu -p Gallery -theme wallpaper -theme-str $rofi_override -me-select-entry w -me-accept-entry MousePrimary"

# Sorting Wallpapers
menu() {
  IFS=$'\n' sorted_options=($(sort <<<"${PICS[*]}"))
  printf "%s\x00icon\x1f%s\n" "$RANDOM_PIC_NAME" "$RANDOM_PIC"
  for pic_path in "${sorted_options[@]}"; do
    pic_name=$(basename "$pic_path")
    printf "%s\x00icon\x1f%s\n" "$(echo "$pic_name" | cut -d. -f1)" "$pic_path"
  done
}

# Initiate swww if not running
swww query || swww-daemon --format xrgb

# Choice of wallpapers
main() {
  choice=$(menu | $rofi_command)
  choice=$(echo "$choice" | xargs)
  RANDOM_PIC_NAME=$(echo "$RANDOM_PIC_NAME" | xargs)

  if [[ -z "$choice" ]]; then
    exit 0
  fi

  if [[ "$choice" == "$RANDOM_PIC_NAME" ]]; then
    swww img -o "$focused_monitor" "$RANDOM_PIC" $SWWW_PARAMS;
    bash "$SCRIPTSDIR/wal.sh"  # Apply colors and restart Waybar via wal.sh
    bash "$SCRIPTSDIR/reload.sh"  # Restart Waybar via reload.sh
    exit 0
  fi

  pic_index=-1
  for i in "${!PICS[@]}"; do
    filename=$(basename "${PICS[$i]}")
    if [[ "$filename" == "$choice"* ]]; then
      pic_index=$i
      break
    fi
  done

  if [[ $pic_index -ne -1 ]]; then
    swww img -o "$focused_monitor" "${PICS[$pic_index]}" $SWWW_PARAMS
  else
    exit 1
  fi
}

if pidof rofi > /dev/null; then
  pkill rofi
fi

main
pkill waybar  # Kill Waybar
pkill swaync
bash "$SCRIPTSDIR/wal.sh"  # Apply colors and restart Waybar via wal.sh
bash "$SCRIPTSDIR/reload.sh"  # Restart Waybar via reload.sh (ensures it runs)
