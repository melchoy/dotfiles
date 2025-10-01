#!/bin/bash

# Update workspace appearance based on if it's focused
if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME background.color=0xff89b4fa \
                        icon.color=0xff1e1e2e
else
  sketchybar --set $NAME background.color=0xff494d64 \
                        icon.color=0xffffffff
fi
