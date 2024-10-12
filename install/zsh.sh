#!/bin/bash

source ~/.dotfiles/common.sh

echo "Installing & Configuring ZSH"

# TODO: Review the powerline font installer

check_font_installed() {
  local font_name=$1
  if ls ~/Library/Fonts | grep -i "$font_name"; then
    echo "$font_name is installed."
  else
    echo "Error: $font_name is not installed."
  fi
}

# Install Fira Code Nerd Font for Poweline Prompt Support in Oh My Zsh
install_fira_code_nerd_font() {
	echo "Installing Nerd Fonts..."

	# TODO: MacOs only need Linux Equivalent
	brew_install_or_update_cask font-fira-code-nerd-font
	brew_install_or_update_cask font-0xproto-nerd-font

	echo "Nerd Fonts installed successfully."

	# Verify the font installation
	check_font_installed "FiraCodeNerdFont"
	check_font_installed "0xProtoNerdFont"
}

# Function to ensure proper permissions and refresh font cache
refresh_font_cache() {
	echo "Setting proper permissions and refreshing font cache..."

	# Ensure proper permissions
	chmod 644 ~/Library/Fonts/FiraCodeNerdFont*.ttf

	# Refresh font cache using fc-cache
	echo "Using fc-cache to refresh font cache."
	#fc-cache -f -v

	echo "Font cache refreshed."
}

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

# Install Fira Code Nerd Font & Refresh Font Cache
# TODO: Review the powerline font installer & change the font
install_fira_code_nerd_font
refresh_font_cache

# Install ZSH & Oh My Zsh
install_or_update_packages "zsh"
install_or_update_ohmyzsh

# Create & Symlink ZSH Config Files
echo "Creating & Symlinking ZSH DOTCONFIGS"
touch "$HOME/.zshrc-local"
touch "$HOME/.zprofile-local"
symlink_dotfile "$DOTMANGR_CONFIGS_DIR/zsh/.zshrc"
symlink_dotfile "$DOTMANGR_CONFIGS_DIR/zsh/.zprofile"




