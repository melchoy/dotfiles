
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

install_fira_code_nerd_font
refresh_font_cache
