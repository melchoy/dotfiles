#!/bin/bash

source ~/.dotfiles/common.sh

if [[ "$PLATFORM_NAME" == "mac" ]]; then
  install_or_update_package "visual-studio-code"

	symlink_dotfile ~/.dotfiles/configs/vscode/macos/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
	symlink_dotfile ~/.dotfiles/configs/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
	symlink_dotfile ~/.dotfiles/configs/vscode/snippets ~/Library/Application\ Support/Code/User/snippets

elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
  echo "Ubuntu Installation of VSCode is not Implemented Yet"
fi


