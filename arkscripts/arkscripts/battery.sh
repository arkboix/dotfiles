#!/bin/bash
# Enhanced battery monitor script
# Monitors battery continuously and provides notifications for:
# - Low battery warnings at different thresholds
# - Full charge notification
# - Charging/discharging status changes

# Arkscripts - https://github.com/arkboix/dotfiles

# Configuration
LOW_BATTERY_CRITICAL=10  # Critical battery level (%)
LOW_BATTERY_WARNING=20   # Warning battery level (%)
LOW_BATTERY_NOTICE=30    # Notice battery level (%)
BATTERY_FULL=100         # Full battery level (%)
CHECK_INTERVAL=60        # Check every 60 seconds
BATTERY_PATH="/sys/class/power_supply/BAT0"  # Path to battery info
NOTIFICATION_TIMEOUT=10000  # 10 seconds for notifications

# Variables to track state changes
previous_status="Unknown"
previous_level=0
critical_notified=false
warning_notified=false
notice_notified=false
full_notified=false

# Function to show notifications
show_notification() {
    level=$1
    status=$2
    urgency=$3
    title=$4
    message=$5

    # Use notify-send with proper urgency level
    notify-send -u "$urgency" -t "$NOTIFICATION_TIMEOUT" "$title" "$message"

    # Optionally play a sound based on urgency
    if [ "$urgency" = "critical" ]; then
        paplay /usr/share/sounds/freedesktop/stereo/suspend-error.oga
    elif [ "$urgency" = "normal" ]; then
        paplay /usr/share/sounds/freedesktop/stereo/message.oga
    fi
}

# Main loop
while true; do
    # Check if battery exists
    if [ ! -d "$BATTERY_PATH" ]; then
        echo "Battery not found at $BATTERY_PATH"
        sleep $CHECK_INTERVAL
        continue
    fi

    # Get battery information
    current_level=$(cat "$BATTERY_PATH/capacity")
    current_status=$(cat "$BATTERY_PATH/status")

    # Debug info
    echo "Battery: $current_level%, Status: $current_status"

    # Handle status changes
    if [ "$current_status" != "$previous_status" ]; then
        if [ "$current_status" = "Charging" ]; then
            show_notification "$current_level" "$current_status" "normal" "Battery Charging" "Battery is now charging ($current_level%)"
            # Reset notification flags when charging starts
            critical_notified=false
            warning_notified=false
            notice_notified=false
        elif [ "$current_status" = "Discharging" ]; then
            show_notification "$current_level" "$current_status" "normal" "Battery Discharging" "Charger disconnected ($current_level%)"
            # Reset full notification flag when discharging starts
            full_notified=false
        fi
    fi

    # Handle level-based notifications
    if [ "$current_status" = "Discharging" ]; then
        # Critical battery level
        if [ "$current_level" -le "$LOW_BATTERY_CRITICAL" ] && [ "$critical_notified" = false ]; then
            show_notification "$current_level" "$current_status" "critical" "Battery Critical" "Battery level is $current_level%!\nConnect charger immediately!"
            critical_notified=true
            # Repeat critical notifications more frequently
            sleep 30
            continue
        # Warning battery level
        elif [ "$current_level" -le "$LOW_BATTERY_WARNING" ] && [ "$warning_notified" = false ]; then
            show_notification "$current_level" "$current_status" "critical" "Battery Low" "Battery level is $current_level%\nPlease connect charger soon."
            warning_notified=true
        # Notice battery level
        elif [ "$current_level" -le "$LOW_BATTERY_NOTICE" ] && [ "$notice_notified" = false ]; then
            show_notification "$current_level" "$current_status" "normal" "Battery Notice" "Battery level is $current_level%"
            notice_notified=true
        fi
    # Handle full battery notification
    elif [ "$current_status" = "Charging" ] || [ "$current_status" = "Full" ]; then
        if [ "$current_level" -ge "$BATTERY_FULL" ] && [ "$full_notified" = false ]; then
            show_notification "$current_level" "$current_status" "normal" "Battery Full" "Battery is fully charged\nYou can disconnect the charger"
            full_notified=true
        fi
    fi

    # Reset notification flags if battery level increases
    if [ "$current_level" -gt "$LOW_BATTERY_CRITICAL" ]; then
        critical_notified=false
    fi
    if [ "$current_level" -gt "$LOW_BATTERY_WARNING" ]; then
        warning_notified=false
    fi
    if [ "$current_level" -gt "$LOW_BATTERY_NOTICE" ]; then
        notice_notified=false
    fi

    # Update previous values
    previous_status="$current_status"
    previous_level=$current_level

    # Wait before checking again
    sleep $CHECK_INTERVAL
done
