#!/bin/bash
# Session info script for tmux
# Returns formatted session name with icon

session_name="$1"
if [ -n "$session_name" ]; then
    echo "🖥️ $session_name"
fi
