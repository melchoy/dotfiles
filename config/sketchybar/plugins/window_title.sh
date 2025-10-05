#!/bin/bash

# Get focused window title from aerospace
WINDOW_TITLE=$(aerospace list-windows --focused | awk -F'|' '{print $2}' | xargs)

# Truncate if too long (optional - adjust max length as needed)
MAX_LENGTH=50
if [ ${#WINDOW_TITLE} -gt $MAX_LENGTH ]; then
  WINDOW_TITLE="${WINDOW_TITLE:0:$MAX_LENGTH}..."
fi

# Update sketchybar
if [ -n "$WINDOW_TITLE" ]; then
  sketchybar --set window_title label="$WINDOW_TITLE"
else
  sketchybar --set window_title label="No active window"
fi
