#!/bin/bash

# Define the path to the swww cache directory
cache_dir="$HOME/.cache/swww/"

# Get current focused monitor
current_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')

# Construct the full path to the cache file
cache_file="$cache_dir$current_monitor"

# Check if the cache file exists and extract the wallpaper path
if [ -f "$cache_file" ]; then
    grep -v 'Lanczos3' "$cache_file" | head -n 1
fi
