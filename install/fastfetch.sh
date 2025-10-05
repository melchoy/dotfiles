#!/bin/bash

source ~/.dotfiles/common.sh

echo "Installing fastfetch..."

if [[ "$PLATFORM_NAME" == "mac" ]]; then
	install_or_update_packages fastfetch
elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
	install_or_update_packages fastfetch
fi

# Symlink the entire fastfetch config directory
symlink_dotfile "$DOTMANGR_CONFIGS_DIR/fastfetch" "$HOME/.config/fastfetch"

echo "✅ Fastfetch installation and configuration complete"

