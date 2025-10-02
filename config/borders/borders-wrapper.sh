#!/bin/bash
# Borders wrapper script - loads configuration and starts borders

# Source the borders configuration
source "$HOME/.config/borders/bordersrc"

# Execute borders with the configured parameters
exec /opt/homebrew/bin/borders \
  active_color="$BORDERS_ACTIVE_COLOR" \
  inactive_color="$BORDERS_INACTIVE_COLOR" \
  width="$BORDERS_WIDTH" \
  style="$BORDERS_STYLE" \
  hidpi="$BORDERS_HIDPI"
