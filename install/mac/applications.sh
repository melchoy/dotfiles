#!/bin/bash

source ~/.dotfiles/common.sh

# TODO: Make some apps optional
cask_apps=(
	"brave-browser"
	"1password"
	"visual-studio-code"
	#"alfred"
	"raycast"
	"slack"
)

brew_install_or_update_cask() {
	local app_name="$1"

	if brew list --cask "$app_name" &> /dev/null; then
		if brew outdated --cask | grep -q "^$app_name"; then
  		echo "$app_name is outdated. Updating..."
  		brew upgrade --cask "$app_name"
		fi
	else
		echo "Installing $app_name..."
		brew install --cask --force "$app_name"
	fi
}

for app in "${cask_apps[@]}"; do
	brew_install_or_update_cask "$app"
done
