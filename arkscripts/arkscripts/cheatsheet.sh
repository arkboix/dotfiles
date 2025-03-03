#!/bin/bash

# Set temp file for the overlay image
cheatsheet="/tmp/hypr-cheatsheet.png"

# Define colors 🎨
BG_COLOR="black"
TITLE_COLOR="yellow"
SECTION_COLOR="cyan"
TEXT_COLOR="white"

# Use IBM Plex Mono
FONT="IBM Plex Mono"

# Create the cheatsheet with smaller text and left alignment
convert -size 1000x600 xc:$BG_COLOR -fill $TITLE_COLOR -font "$FONT" -pointsize 26 \
    -gravity NorthWest -annotate +40+30 "Hyprland Cheatsheet" \
    -fill $SECTION_COLOR -pointsize 20 -annotate +40+80 "[ Windows ]" \
    -fill $TEXT_COLOR -pointsize 18 \
    -annotate +60+110 "SUPER+SHIFT+Arrow   Move Window" \
    -annotate +60+140 "SUPER+ALT+Arrow     Resize Window" \
    -annotate +60+170 "SUPER+T             Toggle Floating" \
    -annotate +60+200 "SUPER+F             Fullscreen" \
    -annotate +60+230 "SUPER+P             Pseudo Mode (Dwindle)" \
    -annotate +60+260 "SUPER+J             Toggle Split (Dwindle)" \
    -fill $SECTION_COLOR -pointsize 20 -annotate +40+300 "[ Workspaces ]" \
    -fill $TEXT_COLOR -pointsize 18 \
    -annotate +60+330 "SUPER+[1-9,0]       Switch workspace" \
    -annotate +60+360 "SUPER+SHIFT+[1-9,0] Move window to workspace" \
    -annotate +60+390 "SUPER+S             Special workspace" \
    -annotate +60+420 "SUPER+N             Cycle Layout" \
    -fill $SECTION_COLOR -pointsize 20 -annotate +40+460 "[ Apps ]" \
    -fill $TEXT_COLOR -pointsize 18 \
    -annotate +60+490 "SUPER+B  Browser" \
    -annotate +60+520 "SUPER+A  Video Editor" \
    -annotate +60+550 "SUPER+C  Wallpaper Selector" \
    -annotate +60+580 "SUPER+R  Color Picker" \
    -annotate +60+610 "SUPER+D  Emoji Picker" \
    -annotate +60+640 "SUPER+TAB Window Switcher" \
    -annotate +60+670 "SUPER+RETURN Terminal" \
    -fill $SECTION_COLOR -pointsize 20 -annotate +40+710 "[ Misc ]" \
    -fill $TEXT_COLOR -pointsize 18 \
    -annotate +60+740 "ALT+X   Random Wallpaper" \
    -annotate +60+770 "Print   Screenshot" \
    -annotate +60+800 "SUPER+V Clipboard Manager" \
    "$cheatsheet"

# Show overlay using swappy (it disappears on click)
swappy -f "$cheatsheet" &

# Close on ESC after 8 seconds
sleep 8 && wtype -k ESC
