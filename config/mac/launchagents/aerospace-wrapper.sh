#!/bin/bash
# Launch AeroSpace at login only when ENABLE_AEROSPACE=1 in ~/.env.local (plist sets HOME).

[[ -f "$HOME/.env.local" ]] && source "$HOME/.env.local"
[[ "$ENABLE_AEROSPACE" != "1" ]] && exit 0
open -a AeroSpace
exit 0
