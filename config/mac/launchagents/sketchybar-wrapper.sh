#!/bin/bash
# Run Sketchybar at login unless DISABLE_SKETCHYBAR=1 in ~/.env.local (plist sets HOME).

[[ -f "$HOME/.env.local" ]] && source "$HOME/.env.local"
if [[ "$DISABLE_SKETCHYBAR" == "1" ]]; then
	exec sleep infinity
fi
if [[ -x /opt/homebrew/opt/sketchybar/bin/sketchybar ]]; then
	exec /opt/homebrew/opt/sketchybar/bin/sketchybar
fi
if [[ -x /usr/local/opt/sketchybar/bin/sketchybar ]]; then
	exec /usr/local/opt/sketchybar/bin/sketchybar
fi
exec sleep infinity
