#!/bin/bash

# Arkscripts - https://github.com/arkboix/dotfiles

distro=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
kernel=$(uname -r)
uptime=$(uptime -p | sed 's/up //')
ram=$(free -h | awk '/Mem:/ {print $3 "/" $2}')

notify-send "System Info" \
    "🖥️ Distro: $distro\n🐧 Kernel: $kernel\n⏳ Uptime: $uptime\n🧠 RAM: $ram"
