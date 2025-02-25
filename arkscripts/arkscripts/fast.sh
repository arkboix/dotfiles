#!/bin/bash

echo "🚀 Applying performance tweaks..."

# Step 1: Enable zswap for faster memory management
sudo bash -c "echo 1 > /sys/module/zswap/parameters/enabled"

# Step 2: Set CPU governor to performance mode
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo "performance" | sudo tee $cpu
done

# Step 3: Clear cache to free up RAM
echo "🧹 Clearing RAM cache..."
sudo sync; echo 3 | sudo tee /proc/sys/vm/drop_caches

# Step 4: Reduce swappiness (forces RAM usage before swap)
echo "🔧 Setting swappiness to 10..."
echo 10 | sudo tee /proc/sys/vm/swappiness

echo "✅ Performance tweaks applied!"
