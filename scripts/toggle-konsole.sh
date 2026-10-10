#!/bin/bash
# Find konsole window and toggle it
if qdbus6 org.kde.konsole >/dev/null 2>&1; then
    # Toggle visibility
    windowId=$(xdotool search --class konsole | head -n 1) # wayland?
    # qdbus is better
    # But wait, wayland doesn't let you toggle windows easily without kwin scripts!
fi
