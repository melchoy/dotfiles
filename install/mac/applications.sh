#!/bin/bash

source ~/.dotfiles/macos/common.sh

set -e  # Exit script if any command fails

echo "Installing Applications with Homebrew Cask"

# TODO: Make some apps optional
cask_apps=(
	"brave-browser"
	"1password"
	"visual-studio-code"
	#"alfred"
	"raycast"
	"slack"
)

for app in "${cask_apps[@]}"; do
	brew_install_or_update_cask "$app"
done
