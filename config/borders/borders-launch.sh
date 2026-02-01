#!/bin/bash
# Borders launch script - loads configuration and starts borders (or sleeps if disabled)

[[ -f "$HOME/.env.local" ]] && source "$HOME/.env.local"
[[ "$DISABLE_AEROSPACE" == "1" ]] && exec sleep infinity

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

# Build arguments array using key=value syntax (works for both start and live updates)
args=(
  active_color="$BORDERS_ACTIVE_COLOR"
  inactive_color="$BORDERS_INACTIVE_COLOR"
  width="$BORDERS_WIDTH"
  radius="$BORDERS_RADIUS"
  style="$BORDERS_STYLE"
  opacity="$BORDERS_OPACITY"
  blur="$BORDERS_BLUR"
  shadow="$BORDERS_SHADOW"
  animation="$BORDERS_ANIMATION"
  display="$BORDERS_DISPLAY"
  spaces="$BORDERS_SPACES"
  ignore="$BORDERS_IGNORE"
)

# Add blacklist if specified
if [ -n "$BORDERS_BLACKLIST" ]; then
  args+=(blacklist="$BORDERS_BLACKLIST")
fi

# Add whitelist if specified
if [ -n "$BORDERS_WHITELIST" ]; then
  args+=(whitelist="$BORDERS_WHITELIST")
fi

# Add hidpi option
if [ "$BORDERS_HIDPI" = "on" ]; then
  args+=(hidpi)
else
  args+=(hidpi=off)
fi

# Execute borders with all arguments
exec /opt/homebrew/bin/borders "${args[@]}"
