#!/bin/bash

source ~/.dotfiles/common.sh

# TODO: Make some apps optional
cask_apps=(
	"vivaldi"
	"1password"

	# TODO: Choose one or the other
	#"alfred"
	"raycast"

	# TODO: Optional or Choose one
	#"iterm2"
	#"alacritty" # needs --no-quarantine"

	# TODO: Make Optional/Section Menu
	"choosy"
	"chatgpt"
	"slack"
)

for app in "${cask_apps[@]}"; do
	brew_install_or_update_cask "$app"
done

echo "Raycast setup:"
echo "  Open Raycast → Settings → Extensions → Script Commands → Add Directory: $HOME/.dotfiles/config/raycast/commands"
echo "  (Raycast cannot be configured programmatically; add once via UI)"
