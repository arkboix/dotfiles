#!/bin/bash

# Solarized Colors
BASE03="#002b36"
BASE02="#073642"
BASE01="#586e75"
BASE00="#657b83"
BASE0="#839496"
BASE1="#93a1a1"
BASE2="#eee8d5"
BASE3="#fdf6e3"
YELLOW="#b58900"
ORANGE="#cb4b16"
RED="#dc322f"
MAGENTA="#d33682"
VIOLET="#6c71c4"
BLUE="#268bd2"
CYAN="#2aa198"
GREEN="#859900"

# Time
TIME="<span foreground='$CYAN' size='xx-large'><b>⚡ $(date '+%H:%M:%S')</b></span>"

# System Stats
UPTIME="<span foreground='$GREEN'>⚡ UPTIME: $(uptime -p | sed 's/up //')</span>"
CPU="<span foreground='$RED'>⚡ CPU: $(top -bn1 | grep 'Cpu(s)' | awk '{print $2}')%</span>"
MEMORY="<span foreground='$VIOLET'>⚡ RAM: $(free -h | awk '/Mem:/ {print $3 "/" $2}')</span>"
SWAP="<span foreground='$MAGENTA'>⚡ SWAP: $(free -h | awk '/Swap:/ {print $3 "/" $2}')</span>"
DISK="<span foreground='$ORANGE'>⚡ DISK: $(df -h / | awk 'NR==2 {print $3 "/" $2}')</span>"

# Battery
if command -v acpi &> /dev/null; then
    BATTERY="<span foreground='$BLUE'>⚡ BATTERY: $(acpi | awk '{print $4}' | tr -d ',')</span>"
else
    BATTERY="<span foreground='$BLUE'>⚡ BATTERY: N/A</span>"
fi

# Volume
VOLUME="<span foreground='$MAGENTA'>⚡ VOLUME: $(pamixer --get-volume)%</span>"

# Extra BLOAT™
KERNEL="<span foreground='$YELLOW'>⚡ KERNEL: $(uname -r)</span>"
PACKAGES="<span foreground='$CYAN'>⚡ PACKAGES: $(pacman -Q | wc -l)</span>"
PROCESSES="<span foreground='$BASE1'>⚡ PROCESSES: $(ps aux --no-headers | wc -l)</span>"

# OUTPUT: Everything in One Line
echo -e "$TIME | $UPTIME | $CPU | $MEMORY | $SWAP | $DISK | $BATTERY | $VOLUME | $KERNEL | $PACKAGES | $PROCESSES"
