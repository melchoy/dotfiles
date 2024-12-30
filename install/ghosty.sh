#!/bin/zsh

source ~/.dotfiles/common.sh

echo "Installing & Configuring Ghosty"

if [[ "$PLATFORM_NAME" == "mac" ]]; then
	install_or_update_package ghostty
elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
	echo "TODO: Implement Ghosty installation for Ubuntu"
fi

# Create & Symlink Ghosty Config Files
symlink_dotfile "$DOTMANGR_CONFIGS_DIR/ghosty" "$HOME/.config/ghosty"
