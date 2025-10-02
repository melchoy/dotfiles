#!/bin/bash

DAY=$(date '+%a')
TIME=$(date '+%H:%M')

sketchybar --set "$NAME" icon="$DAY" label="$TIME"
