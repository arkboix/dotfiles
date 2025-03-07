#!/bin/bash

# Arkscripts - https://github.com/arkboix/dotfiles

# Get the full uname output
sysinfo=$(uname -a)

# Extract the first two words (Distro and Hostname)
distro=$(echo "$sysinfo" | awk '{print $1, $2}')

# Extract the kernel version
kernel=$(uname -r)

# Print in the desired format
echo "[  󰣨  $distro |  $kernel ]"
