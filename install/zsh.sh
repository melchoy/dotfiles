#!/bin/bash

source ~/.dotfiles/common.sh

echo "Installing & Configuring ZSH"

# Install Oh My Zsh
install_or_update_ohmyzsh() {
	if [ ! -d "$HOME/.oh-my-zsh" ]; then
		echo "Installing OhMyZsh..."
		export KEEP_ZSHRC=yes
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc --unattended
	elif [ -f "$HOME/.zshrc" ]; then
		echo "OhMyZsh Already Installed, updating..."
		#zsh -c "source ~/.zshrc && command -v omz >/dev/null 2>&1 && omz update"
	fi
}

# Install ZSH & Oh My Zsh
install_or_update_packages "zsh"

# Create & Symlink ZSH Config Files
echo "Creating & Symlinking ZSH DOTCONFIGS"
touch "$HOME/.zshrc-local"
touch "$HOME/.zprofile-local"
symlink_dotfile "$DOTMANGR_CONFIGS_DIR/zsh/.zshrc"
symlink_dotfile "$DOTMANGR_CONFIGS_DIR/zsh/.zprofile"
