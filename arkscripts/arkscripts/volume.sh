#!/bin/bash
# Arkscripts - https://github.com/arkboix/dotfiles


# Configuration
NOTIFICATION_ID_FILE="/tmp/volume_notification_id"
VOLUME_ICON="audio-volume-high-symbolic"
MUTED_ICON="audio-volume-muted-symbolic"
NOTIFICATION_TIMEOUT=2000  # ms

# Function to get current volume and mute status
get_volume_info() {
    # Get volume percentage
    VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]+(?=%)' | head -1)

    # Check if muted
    MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -q "yes" && echo "true" || echo "false")

    # Select icon based on volume and mute status
    if [ "$MUTED" = "true" ]; then
        ICON=$MUTED_ICON
    elif [ $VOLUME -ge 70 ]; then
        ICON="audio-volume-high-symbolic"
    elif [ $VOLUME -ge 30 ]; then
        ICON="audio-volume-medium-symbolic"
    else
        ICON="audio-volume-low-symbolic"
    fi
}

# Function to create/update notification
update_notification() {
    # Create volume bar
    BAR=$(seq -s "█" $(($VOLUME / 5)) | sed 's/[0-9]//g')

    # Build notification message
    if [ "$MUTED" = "true" ]; then
        SUMMARY="Volume: Muted"
        BODY="[$BAR]"
    else
        SUMMARY="Volume: ${VOLUME}%"
        BODY="[$BAR]"
    fi

    # Check if we already have a notification ID
    if [ -f "$NOTIFICATION_ID_FILE" ]; then
        NOTIFICATION_ID=$(cat "$NOTIFICATION_ID_FILE")
        # Update existing notification
        RESPONSE=$(makoctl notify -r "$NOTIFICATION_ID" -a "Volume Control" -i "$ICON" -t "$NOTIFICATION_TIMEOUT" "$SUMMARY" "$BODY")
    else
        # Create new notification
        RESPONSE=$(makoctl notify -a "Volume Control" -i "$ICON" -t "$NOTIFICATION_TIMEOUT" "$SUMMARY" "$BODY")
    fi

    # Extract notification ID from response (makoctl outputs the ID)
    NEW_ID=$(echo "$RESPONSE" | awk '{print $1}')
    echo "$NEW_ID" > "$NOTIFICATION_ID_FILE"
}

# Function to handle volume increase
increase_volume() {
    pactl set-sink-volume @DEFAULT_SINK@ +5%
    get_volume_info
    update_notification
}

# Function to handle volume decrease
decrease_volume() {
    pactl set-sink-volume @DEFAULT_SINK@ -5%
    get_volume_info
    update_notification
}

# Function to toggle mute
toggle_mute() {
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    get_volume_info
    update_notification
}

# Parse command line arguments
case "$1" in
    up|increase)
        increase_volume
        ;;
    down|decrease)
        decrease_volume
        ;;
    mute|toggle)
        toggle_mute
        ;;
    *)
        # If no arguments, just show current volume
        get_volume_info
        update_notification
        ;;
esac

exit 0
