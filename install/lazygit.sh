#!/bin/bash

source ~/.dotfiles/common.sh

echo "Installing lazygit..."

if [[ "$PLATFORM_NAME" == "mac" ]]; then
	install_or_update_packages lazygit
elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
	# Install lazygit from GitHub releases for Ubuntu
	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')

	if command -v lazygit &> /dev/null; then
		INSTALLED_VERSION=$(lazygit --version | grep -oP 'version=\K[^,]+')
		if [[ "$INSTALLED_VERSION" == "$LAZYGIT_VERSION" ]]; then
			echo "Lazygit $INSTALLED_VERSION is already up to date."
		else
			echo "Updating lazygit from $INSTALLED_VERSION to $LAZYGIT_VERSION..."
			curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
			tar xf lazygit.tar.gz lazygit
			sudo install lazygit /usr/local/bin
			rm -f lazygit.tar.gz lazygit
		fi
	else
		echo "Installing lazygit $LAZYGIT_VERSION..."
		curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
		tar xf lazygit.tar.gz lazygit
		sudo install lazygit /usr/local/bin
		rm -f lazygit.tar.gz lazygit
	fi
fi

# Create lazygit config directory
mkdir -p ~/.config/lazygit

# Symlink the lazygit configuration
symlink_dotfile "$DOTMANGR_CONFIGS_DIR/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"

echo "✅ Lazygit installation and configuration complete"
