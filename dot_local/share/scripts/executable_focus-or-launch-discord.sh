#!/usr/bin/env bash

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/discord-focus-state"

# Get the currently focused window ID
FOCUSED_ID=$(niri msg --json windows | jq -r '.[] | select(.is_focused) | .id' | head -1)

# Find Discord window ID using niri msg --json windows and jq
DISCORD_ID=$(niri msg --json windows | jq -r '.[] | select(.app_id | contains("discord")) | .id' | head -1)

if [ -n "$DISCORD_ID" ]; then
    # Discord is running
    if [ "$FOCUSED_ID" = "$DISCORD_ID" ]; then
        # Discord is focused, switch to previous window
        if [ -f "$STATE_FILE" ] && [ -s "$STATE_FILE" ]; then
            PREV_ID=$(cat "$STATE_FILE")
            niri msg action focus-window --id "$PREV_ID" 2>/dev/null || niri msg action focus-window --id "$DISCORD_ID"
        else
            # No previous window recorded, keep Discord focused
            niri msg action focus-window --id "$DISCORD_ID"
        fi
    else
        # Discord is not focused, save current window and focus Discord
        [ -n "$FOCUSED_ID" ] && echo "$FOCUSED_ID" > "$STATE_FILE"
        niri msg action focus-window --id "$DISCORD_ID"
    fi
else
    # Discord is not running, launch it
    [ -n "$FOCUSED_ID" ] && echo "$FOCUSED_ID" > "$STATE_FILE"
    brave --app="https://discord.com/channels/884261781709656095/928471775803760700" &
fi
