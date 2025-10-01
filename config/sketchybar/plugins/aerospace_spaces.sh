#!/bin/bash

# Get focused workspace
FOCUSED=$(aerospace list-workspaces --focused)

# Check numbered workspaces (1-9)
for i in {1..9}; do
  HAS_WINDOWS=$(aerospace list-windows --workspace "$i" 2>/dev/null)
  
  if [ "$i" = "$FOCUSED" ]; then
    # Focused workspace - always show in bright blue
    sketchybar --set space.$i drawing=on \
                              background.color=0xff89b4fa \
                              icon.color=0xff1e1e2e
  elif [ -n "$HAS_WINDOWS" ]; then
    # Has windows - show in gray
    sketchybar --set space.$i drawing=on \
                              background.color=0xff6c7086 \
                              icon.color=0xffffffff
  else
    # Empty and not focused - hide
    sketchybar --set space.$i drawing=off
  fi
done

# Check named workspaces (like S for Slack)
for workspace in S; do
  HAS_WINDOWS=$(aerospace list-windows --workspace "$workspace" 2>/dev/null)
  
  if [ "$workspace" = "$FOCUSED" ]; then
    sketchybar --set space.$workspace drawing=on \
                                      background.color=0xff89b4fa \
                                      icon.color=0xff1e1e2e
  elif [ -n "$HAS_WINDOWS" ]; then
    sketchybar --set space.$workspace drawing=on \
                                      background.color=0xff6c7086 \
                                      icon.color=0xffffffff
  else
    sketchybar --set space.$workspace drawing=off
  fi
done
