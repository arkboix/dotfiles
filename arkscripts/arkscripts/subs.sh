#!/bin/bash

# Configuration
CHANNEL="ArkboiX"  # Change this to your desired channel

# Function to get subscriber count for a YouTube channel
get_youtube_subscribers() {
    channel_handle=$1

    # Ensure the channel handle is formatted correctly
    if [[ ! $channel_handle == @* ]]; then
        channel_handle="@$channel_handle"
    fi

    # Create the URL
    url="https://www.youtube.com/$channel_handle/about"

    # Use curl to fetch the page with a browser-like User-Agent
    user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"

    # Fetch the page
    response=$(curl -s -A "$user_agent" "$url")

    if [ $? -ne 0 ]; then
        echo "Error"
        return 1
    fi

    # Extract subscriber count using grep and regex
    subscriber_count=$(echo "$response" | grep -o '"subscriberCountText":{"simpleText":"[^"]*"' | grep -o '"[^"]*"$' | tr -d '"' | sed 's/ subscribers//')

    if [ -n "$subscriber_count" ]; then
        echo "$subscriber_count"
        return 0
    fi

    # Alternative pattern matching for subscriber count
    subscriber_count=$(echo "$response" | grep -o '[0-9.]\+[KMB]\? subscribers' | head -1 | sed 's/ subscribers//')

    if [ -n "$subscriber_count" ]; then
        echo "$subscriber_count"
        return 0
    fi

    # If we get here, we couldn't find the subscriber count
    echo "0"
    return 1
}

# Get subscriber count
SUBS=$(get_youtube_subscribers "$CHANNEL")
CHANNEL_URL="https://www.youtube.com/@$CHANNEL"

# Format output for Waybar (JSON)
echo "{\"text\":\"$SUBS Subscribers\", \"tooltip\":\"@$CHANNEL: $SUBS Subscribers\", \"class\":\"custom-youtube\", \"alt\":\"YouTube\", \"percentage\":100}"
