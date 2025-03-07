#!/bin/bash

# Arkscripts - https://github.com/arkboix/dotfiles

echo "🚑 Running full system recovery..."

# Step 1: Check and reinstall base system packages
BASE_PKGS="base linux linux-zen linux-firmware networkmanager"
for pkg in $BASE_PKGS; do
    if ! pacman -Q $pkg &> /dev/null; then
        echo "🔄 Reinstalling $pkg..."
        sudo pacman -S --noconfirm $pkg
    fi
done

# Step 2: Fix broken package dependencies
echo "🔧 Fixing package dependencies..."
sudo pacman -Syu --noconfirm
sudo pacman -Qk | grep "missing" | awk '{print $2}' | sudo pacman -S --noconfirm -

# Step 3: Regenerate missing configs
if [[ ! -f "$HOME/.bashrc" ]]; then
    echo "⚠️ Missing .bashrc, restoring..."
    cp /etc/skel/.bashrc "$HOME/"
fi

if [[ ! -f "/etc/NetworkManager/NetworkManager.conf" ]]; then
    echo "⚠️ NetworkManager config missing, regenerating..."
    sudo systemctl restart NetworkManager
fi

# Step 4: Fix sudo (if broken)
if ! sudo -V &> /dev/null; then
    echo "🚨 Sudo is broken, restoring..."
    su -c "pacman -S --noconfirm sudo"
fi

# Step 5: Run filesystem checks (if boot issues)
echo "🛠 Running filesystem check..."
sudo fsck -A -y

echo "✅ System recovery completed!"
