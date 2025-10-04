#!/bin/zsh
# @raycast.schemaVersion 1
# @raycast.title Cursor (DX)
# @raycast.mode silent
# @raycast.packageName Dev
# @raycast.icon ./icons/cursor-dx.png

# Prefer VS Code CLI (skips shell env resolver), then PATH, then app
CLI="/Applications/Cursor.app/Contents/Resources/app/bin/cursor"
if [[ -x "$CLI" ]]; then
  nohup "$CLI" --reuse-window >/dev/null 2>&1 & disown
elif command -v code >/dev/null 2>&1; then
  nohup code --reuse-window >/dev/null 2>&1 & disown
else
  nohup open -a "Cursor" >/dev/null 2>&1 & disown
fi




