#!/bin/bash

source ~/.dotfiles/common.sh

set -e  # Exit script if any command fails

echo "Installing & Configuring ZSH"

# TODO: Review the powerline font installer

# Install Fira Code Nerd Font for Poweline Prompt Support in Oh My Zsh
# Function to install Fira Code Nerd Font
install_fira_code_nerd_font() {
	echo "Installing Fira Code Nerd Font..."

	brew install --cask font-fira-code-nerd-font

	echo "Fira Code Nerd Font installed successfully."

	# Verify the font installation
	echo "Verifying font installation..."
	if ls ~/Library/Fonts | grep -i "FiraCodeNerdFont"; then
		echo "Fira Code Nerd Font is installed at ~/Library/Fonts"
	else
		echo "Error: Fira Code Nerd Font is not installed properly."
	fi
}

# Function to ensure proper permissions and refresh font cache
refresh_font_cache() {
	echo "Setting proper permissions and refreshing font cache..."

	# Ensure proper permissions
	chmod 644 ~/Library/Fonts/FiraCodeNerdFont*.ttf

	# Refresh font cache using fc-cache
	echo "Using fc-cache to refresh font cache."
	fc-cache -f -v

	echo "Font cache refreshed."
}

# Install Oh My Zsh
install_or_update_ohmyzsh() {
	if [ ! -d "$HOME/.oh-my-zsh" ]; then
		echo "Installing OhMyZsh..."
		export KEEP_ZSHRC=yes
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc --unattended
	else
		echo "OhMyZsh Already Installed, updating..."
		zsh -c "source ~/.zshrc && omz update"
	fi
}

#install_fira_code_nerd_font
#refresh_font_cache

install_or_update_package "zsh"
install_or_update_ohmyzsh

