#!/bin/bash
# Borders wrapper script - loads configuration and starts borders

# Source the borders configuration
source "$HOME/.config/borders/bordersrc"

# Set safe defaults for all variables
: "${BORDERS_ACTIVE_COLOR:=0xffc6a0f6}"
: "${BORDERS_INACTIVE_COLOR:=0x00000000}"
: "${BORDERS_WIDTH:=3.0}"
: "${BORDERS_RADIUS:=1}"
: "${BORDERS_STYLE:=round}"
: "${BORDERS_OPACITY:=1.0}"
: "${BORDERS_BLUR:=0}"
: "${BORDERS_SHADOW:=0}"
: "${BORDERS_ANIMATION:=0}"
: "${BORDERS_DISPLAY:=all}"
: "${BORDERS_SPACES:=all}"
: "${BORDERS_IGNORE:=Dock,Menu Bar}"
: "${BORDERS_HIDPI:=on}"
: "${BORDERS_BLACKLIST:=}"
: "${BORDERS_WHITELIST:=}"

# Build arguments array
args=(
  --active-color "$BORDERS_ACTIVE_COLOR"
  --inactive-color "$BORDERS_INACTIVE_COLOR"
  --width "$BORDERS_WIDTH"
  --radius "$BORDERS_RADIUS"
  --style "$BORDERS_STYLE"
  --opacity "$BORDERS_OPACITY"
  --blur "$BORDERS_BLUR"
  --shadow "$BORDERS_SHADOW"
  --animation "$BORDERS_ANIMATION"
  --display "$BORDERS_DISPLAY"
  --spaces "$BORDERS_SPACES"
  --ignore "$BORDERS_IGNORE"
)

# Add blacklist if specified
if [ -n "$BORDERS_BLACKLIST" ]; then
  args+=(--blacklist "$BORDERS_BLACKLIST")
fi

# Add whitelist if specified
if [ -n "$BORDERS_WHITELIST" ]; then
  args+=(--whitelist "$BORDERS_WHITELIST")
fi

# Add hidpi flag only if enabled
if [ "$BORDERS_HIDPI" = "on" ]; then
  args+=(--hidpi)
fi

# Execute borders with all arguments
exec /opt/homebrew/bin/borders "${args[@]}"
