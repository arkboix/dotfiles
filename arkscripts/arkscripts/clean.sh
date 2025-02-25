#!/bin/bash

echo "🧹 Cleaning up system junk..."

kitty
# Clear pacman cache (Arch)
[[ -x "$(command -v pacman)" ]] && sudo pacman -Sc --noconfirm

# Clear orphan packages (Arch)
[[ -x "$(command -v pacman)" ]] && sudo pacman -Rns $(pacman -Qdtq) --noconfirm

# Clear systemd journal logs
sudo journalctl --vacuum-time=7d

# Clear cache
rm -rf ~/.cache/*
rm -rf /var/tmp/*

echo "✅ Cleanup done!"
notify-send "System Junk has been cleaned up."
