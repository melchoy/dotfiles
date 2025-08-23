#!/bin/bash
# Git status script for tmux
# Returns formatted git branch with icon

cd "$1" 2>/dev/null || exit 1

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    exit 0
fi

# Get current branch
branch=$(git branch --show-current 2>/dev/null)

if [ -n "$branch" ]; then
    echo " $branch"
fi
