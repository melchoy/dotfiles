#!/bin/bash

VOLUME=$(osascript -e 'output volume of (get volume settings)')

ICON="󰕾"
if [ "$VOLUME" -eq 0 ]; then
  ICON="󰖁"
fi

sketchybar --set "$NAME" icon="$ICON" label="${VOLUME}%"
