#!/bin/bash

source ~/.dotfiles/common.sh

echo "Installing & Configuring Starship Prompt"

if [[ "$PLATFORM_NAME" == "mac" ]]; then
	install_or_update_package starship
elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
	# Install Starship Prompt
	# curl -fsSL https://starship.rs/install.sh | bash
	echo "TODO: Implement starship installation for Ubuntu"
fi

# Create & Symlink Starship Config Files
echo "Creating & Symlinking Starship DOTCONFIGS"
symlink_dotfile "$DOTMANGR_CONFIGS_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
