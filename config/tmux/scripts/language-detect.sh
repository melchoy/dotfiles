#!/bin/bash
# Language detection script for tmux
# Returns icons for detected project types

cd "$1" 2>/dev/null || exit 1

output=""

# Node.js
if [ -f "package.json" ]; then
    output="${output}󰖎 "
fi

# Go
if [ -f "go.mod" ] || ls *.go >/dev/null 2>&1; then
    output="${output}󰔭 "
fi

# Ruby
if [ -f "Gemfile" ] || ls *.rb >/dev/null 2>&1; then
    output="${output}󰕎 "
fi

# Python
if ls *.py >/dev/null 2>&1 || [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    output="${output}󰠌 "
fi

# Lua
if ls *.lua >/dev/null 2>&1; then
    output="${output} "
fi

echo "$output"
