#!/bin/zsh
# @raycast.schemaVersion 1
# @raycast.title Visual Studio Code (DX)
# @raycast.mode silent
# @raycast.packageName Dev
# @raycast.icon ./icons/vscode-dx.png

# Prefer VS Code CLI (skips shell env resolver), then PATH, then app
CLI="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
if [[ -x "$CLI" ]]; then
  nohup "$CLI" --reuse-window >/dev/null 2>&1 & disown
elif command -v code >/dev/null 2>&1; then
  nohup code --reuse-window >/dev/null 2>&1 & disown
else
  nohup open -a "Visual Studio Code" >/dev/null 2>&1 & disown
fi



