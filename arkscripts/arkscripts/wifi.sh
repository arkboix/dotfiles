#!/bin/bash
# Arkscripts - https://github.com/arkboix/dotfiles
echo "🔄 Resetting network interfaces..."

# Restart NetworkManager
sudo systemctl restart NetworkManager

# Check for internet connection
if ping -c 1 google.com &> /dev/null; then
    echo "✅ Internet is working!"
    exit 0
fi

echo "❌ No internet detected. Trying fallback..."

# Try reconnecting to WiFi
sudo nmcli networking off
sleep 2
sudo nmcli networking on

# Restart DHCP
sudo systemctl restart dhcpcd

# Try reconnecting
if ping -c 1 google.com &> /dev/null; then
    echo "✅ Internet restored!"
else
    echo "❌ Still no internet. Try rebooting."
fi
