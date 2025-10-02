#!/bin/zsh
# @raycast.schemaVersion 1
# @raycast.title Cursor (DX)
# @raycast.mode silent
# @raycast.packageName Dev
# @raycast.icon ./icons/cursor.png

# Launch via login shell; prefer Cursor CLI (bypasses resolver), then PATH, then app
/bin/zsh -l -c '
  CLI="/Applications/Cursor.app/Contents/Resources/app/bin/cursor"
  if [[ -x "$CLI" ]]; then
    nohup "$CLI" --reuse-window >/dev/null 2>&1 & disown
  elif command -v cursor >/dev/null 2>&1; then
    nohup cursor --reuse-window >/dev/null 2>&1 & disown
  else
    nohup open -a "Cursor" >/dev/null 2>&1 & disown
  fi
'


