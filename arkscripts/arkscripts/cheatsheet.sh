#!/bin/bash

# Script to generate a cleaner keybindings cheatsheet for Hyprland using Rofi
# Excludes common keybindings like workspace switching and multimedia keys

# Function to convert modifier keys to a more readable format
format_modifiers() {
  local mod="$1"
  mod=$(echo "$mod" | sed 's/\$mainMod/Super/g')
  mod=$(echo "$mod" | sed 's/SUPER/Super/g')
  mod=$(echo "$mod" | sed 's/SUPER_SHIFT/Super+Shift/g')
  mod=$(echo "$mod" | sed 's/SHIFT/Shift/g')
  mod=$(echo "$mod" | sed 's/CTRL/Ctrl/g')
  mod=$(echo "$mod" | sed 's/ALT/Alt/g')
  mod=$(echo "$mod" | sed 's/_/ + /g')
  mod=$(echo "$mod" | sed 's/ ,/ + /g')
  echo "$mod"
}

# Function to provide more descriptive action names
get_descriptive_action() {
  local action="$1"
  local target="$2"

  case "$target" in
    *"terminal"*)
      echo "Launch terminal"
      ;;
    *"$browser"*)
      echo "Launch browser"
      ;;
    *"$fileManager"*)
      echo "Launch file manager"
      ;;
    *"emacs"*)
      echo "Launch Emacs"
      ;;
    *"wall.sh"*)
      echo "Set random wallpaper"
      ;;
    *"select-wall.sh"*)
      echo "Select wallpaper"
      ;;
    *"waypaper"*)
      echo "Launch Waypaper"
      ;;
    *"hyprpicker"*)
      echo "Launch color picker"
      ;;
    *"hyprlock"*)
      echo "Lock screen"
      ;;
    *"rofi -show emoji"*)
      echo "Show emoji picker"
      ;;
    *"rofi -show window"*)
      echo "Show window switcher"
      ;;
    *"fzf-rofi.sh"*)
      echo "Show fuzzy finder"
      ;;
    *"volume.sh"*)
      echo "Adjust volume"
      ;;
    *"hyprshot"*)
      if [[ "$target" == *"region"* ]]; then
        echo "Screenshot selected region"
      else
        echo "Screenshot full screen"
      fi
      ;;
    *"cliphist"*)
      echo "Show clipboard history"
      ;;
    *"$video-editor"*)
      echo "Launch video editor"
      ;;
    *)
      # If it's an exec command but not recognized, return the target
      if [[ "$action" == "exec" ]]; then
        echo "Launch: $target"
      else
        echo "$action $target"
      fi
      ;;
  esac
}

# Path to your Hyprland config file
CONFIG_FILE="$HOME/.config/hypr/conf/input.conf"

# Check if the config file exists
if [ ! -f "$CONFIG_FILE" ]; then
  # Try the alternative path from the document
  CONFIG_FILE="$HOME/dotfiles/hypr/.config/hypr/conf/input.conf"
  if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found!"
    exit 1
  fi
fi

# Create theme directory if it doesn't exist
THEME_DIR="$HOME/.config/rofi/themes"
mkdir -p "$THEME_DIR"

# Path to the theme file
THEME_FILE="$THEME_DIR/keybinds-solarized.rasi"

# Create the Solarized theme file if it doesn't exist
cat > "$THEME_FILE" << 'EOL'
/**
 * Rofi Solarized Dark Theme for Hyprland Keybindings
 * Based on Solarized Dark color scheme by Ethan Schoonover
 */

* {
    /* Solarized Dark Colors */
    base03:     #002b36;
    base02:     #073642;
    base01:     #586e75;
    base00:     #657b83;
    base0:      #839496;
    base1:      #93a1a1;
    base2:      #eee8d5;
    base3:      #fdf6e3;
    yellow:     #b58900;
    orange:     #cb4b16;
    red:        #dc322f;
    magenta:    #d33682;
    violet:     #6c71c4;
    blue:       #268bd2;
    cyan:       #2aa198;
    green:      #859900;

    /* Theme settings */
    background-color:   transparent;
    text-color:         @base0;

    font:               "JetBrainsMono Nerd Font 12";
    border-color:       @blue;
    separatorcolor:     @blue;

    spacing:            2;
}

window {
    width:              700px;
    background-color:   @base03;
    border:             2px;
    border-color:       @blue;
    border-radius:      8px;
    padding:            15px;
}

mainbox {
    border:             0;
    padding:            0;
}

message {
    border:             1px dash 0px 0px;
    border-color:       @separatorcolor;
    padding:            1px;
}

textbox {
    text-color:         @text-color;
    padding:            8px;
}

listview {
    fixed-height:       false;
    dynamic:            true;
    border:             0px;
    spacing:            2px;
    scrollbar:          true;
    padding:            5px 5px 0px 5px;
    lines:              15;
}

element {
    border:             0;
    padding:            4px;
    border-radius:      4px;
}

element-text {
    background-color:   inherit;
    text-color:         inherit;
    vertical-align:     0.5;
}

element.normal.normal {
    background-color:   @base03;
    text-color:         @base0;
}

element.selected.normal {
    background-color:   @base02;
    text-color:         @base3;
}

element.alternate.normal {
    background-color:   @base03;
    text-color:         @base0;
}

scrollbar {
    width:              4px;
    border:             0;
    handle-width:       8px;
    padding:            0;
    handle-color:       @blue;
    background-color:   @base02;
}

inputbar {
    spacing:            0;
    text-color:         @base3;
    padding:            5px;
    border:             0px 0px 1px 0px;
    border-color:       @separatorcolor;
    background-color:   @base02;
    children:           [ prompt, textbox-prompt-colon, entry ];
}

prompt {
    spacing:            0;
    text-color:         @blue;
    background-color:   inherit;
}

textbox-prompt-colon {
    expand:             false;
    str:                " ";
    margin:             0px 0.3em 0em 0em;
    text-color:         @blue;
    background-color:   inherit;
}

entry {
    spacing:            0;
    text-color:         @base3;
    background-color:   inherit;
}
EOL

# Parse the bind commands and extract the keybindings
# Excludes common keybindings like workspace switching and system/media keys
{
  echo "🔍 HYPRLAND KEYBINDINGS CHEATSHEET"
  echo "═════════════════════════════════════"

  grep "^bind" "$CONFIG_FILE" | \
    grep -v "workspace, [0-9]" | \
    grep -v "movetoworkspace, [0-9]" | \
    grep -v "movefocus" | \
    grep -v "XF86" | \
    while read -r line; do
      # Extract the keys part
      keys=$(echo "$line" | sed -E 's/bind\s*=\s*([^,]+).*/\1/g' | sed 's/^ *//;s/ *$//')

      # Extract the action part
      action=$(echo "$line" | sed -E 's/bind\s*=\s*[^,]+,\s*([^,]+).*/\1/g' | sed 's/^ *//;s/ *$//')

      # Extract the target/command part (if exists)
      target=""
      if [[ "$line" =~ bind[[:space:]]*=[[:space:]]*[^,]+,[[:space:]]*[^,]+,[[:space:]]*(.*) ]]; then
        target=${BASH_REMATCH[1]}
        target=$(echo "$target" | sed 's/^ *//;s/ *$//')
      fi

      # Format the keys
      formatted_keys=$(format_modifiers "$keys")

      # Get descriptive action
      descriptive_action=$(get_descriptive_action "$action" "$target")

      # Categorize commands
      if [[ "$action" == "exec" ]]; then
        echo "🚀 $formatted_keys │ $descriptive_action"
      elif [[ "$action" == "killactive" ]]; then
        echo "🪟 $formatted_keys │ Close window"
      elif [[ "$action" == "togglefloating" ]]; then
        echo "🪟 $formatted_keys │ Toggle floating"
      elif [[ "$action" == "fullscreen" ]]; then
        echo "🪟 $formatted_keys │ Toggle fullscreen"
      elif [[ "$action" == "pseudo" ]]; then
        echo "🪟 $formatted_keys │ Toggle pseudo tiling"
      elif [[ "$action" == "togglesplit" ]]; then
        echo "🪟 $formatted_keys │ Toggle split direction"
      elif [[ "$action" == "exit" ]]; then
        echo "⚙️  $formatted_keys │ Exit Hyprland"
      elif [[ "$action" == "pin" ]]; then
        echo "📌 $formatted_keys │ Pin window"
      elif [[ "$action" == "movewindow" ]]; then
        dir=""
        case "$target" in
          "l") dir="left" ;;
          "r") dir="right" ;;
          "u") dir="up" ;;
          "d") dir="down" ;;
          *) dir="$target" ;;
        esac
        echo "🪟 $formatted_keys │ Move window $dir"
      elif [[ "$action" == "resizeactive" ]]; then
        echo "🪟 $formatted_keys │ Resize window"
      elif [[ "$action" == "togglespecialworkspace" ]]; then
        echo "📋 $formatted_keys │ Toggle scratchpad"
      elif [[ "$action" == "layoutmsg" ]]; then
        echo "📐 $formatted_keys │ $descriptive_action"
      else
        echo "⚙️  $formatted_keys │ $descriptive_action"
      fi
    done | sort
} > /tmp/hypr_keybinds.txt

# Display the keybindings using Rofi with our custom theme
rofi -dmenu -i -p "Keybindings" -theme "$THEME_FILE" -markup-rows < /tmp/hypr_keybinds.txt

# Clean up
rm /tmp/hypr_keybinds.txt
