#!/bin/bash

source ~/.dotfiles/common.sh

# TODO: Make some apps optional
cask_apps=(
	"brave-browser"
	"1password"

	# TODO: Choose one or the other
	#"alfred"
	"raycast"

	# TODO: Make Optional/Section Menu
	#"choosy"
	"chatgpt"
	"slack"
)

for app in "${cask_apps[@]}"; do
	brew_install_or_update_cask "$app"
done
