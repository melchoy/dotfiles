#!/bin/bash

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ $PERCENTAGE = "" ]; then
  exit 0
fi

# Set icon and color based on charging status and battery level
if [[ $CHARGING != "" ]]; then
  ICON="󰂄"
  COLOR=0xff89b4fa  # Blue when charging
elif [[ $PERCENTAGE -le 20 ]]; then
  ICON="󰁹"
  COLOR=0xfff38ba8  # Red when low
elif [[ $PERCENTAGE -le 50 ]]; then
  ICON="󰁹"
  COLOR=0xfff9e2af  # Yellow when medium
else
  ICON="󰁹"
  COLOR=0xffa6e3a1  # Green when good
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%" label.color=0xffffffff
