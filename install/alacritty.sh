#!/bin/zsh

source ~/.dotfiles/common.sh

if [[ "$PLATFORM_NAME" == "mac" ]]; then
	brew_install_or_update_cask alacritty --no-quarantine

	# Symlink configuration files
	symlink_dotfile ~/.dotfiles/config/alacritty/alacritty.toml ~/.alacritty.toml
elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
	echo "TODO: Implement alacritty installation for Ubuntu"
fi
