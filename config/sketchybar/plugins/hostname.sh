#!/bin/bash

# Get the computer's sharing name
COMPUTER_NAME=$(scutil --get ComputerName)

# Update the sketchybar item
sketchybar --set hostname label="$COMPUTER_NAME"
