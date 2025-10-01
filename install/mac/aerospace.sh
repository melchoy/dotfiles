#!/bin/bash

source ~/.dotfiles/common.sh

do_install() {
	echo "Installing/updating Aerospace..."

	# Aerospace installation via brew
	if [[ "$PLATFORM_NAME" != "mac" ]]; then
		echo "❌ Aerospace is only supported on macOS"
		exit 1
	fi

	# Install or update aerospace
	brew_install_or_update_cask "nikitabobko/tap/aerospace"

	# Setup aerospace configuration
	echo ""
	echo "Setting up Aerospace configuration..."

	# Create aerospace config directory
	mkdir -p ~/.config/aerospace

	# Symlink the aerospace config
	symlink_dotfile "$DOTMANGR_CONFIGS_DIR/aerospace" "$HOME/.config/aerospace"

	echo "✅ Aerospace configuration installed"

	# Start Aerospace
	echo ""
	echo "Starting Aerospace..."
	open -a AeroSpace

	# Wait a moment for it to start
	sleep 1

	if pgrep -x "AeroSpace" > /dev/null; then
		echo "✅ Aerospace is running"
	else
		echo "⚠️  Aerospace may need accessibility permissions to start properly"
	fi

	# Provide setup instructions
	echo ""
	echo "📋 Setup Instructions:"
	echo "1. Grant Aerospace accessibility permissions:"
	if [[ $(sw_vers -productVersion | cut -d. -f1) -ge 13 ]]; then
		echo "   - Open System Settings → Privacy & Security → Accessibility"
	else
		echo "   - Open System Preferences → Security & Privacy → Privacy → Accessibility"
	fi
	echo "   - Click the + button and add AeroSpace"
	echo "2. AeroSpace will start automatically"
	echo ""
	echo "For configuration examples, visit: https://nikitabobko.github.io/AeroSpace/guide"
}

do_uninstall() {
	echo "Uninstalling Aerospace..."

	# Stop Aerospace
	pkill -9 AeroSpace 2>/dev/null || true

	# Remove from login items
	osascript -e 'tell application "System Events" to delete login item "AeroSpace"' 2>/dev/null || true

	# Uninstall the cask
	brew uninstall --cask aerospace 2>/dev/null || true
	brew untap nikitabobko/tap 2>/dev/null || true

	# Remove symlinks
	rm -rf ~/.config/aerospace 2>/dev/null || true

	echo "✅ Aerospace uninstalled"
	echo "Note: Config files remain in ~/.dotfiles/config/aerospace"
}

if [ "$1" == "--uninstall" ]; then
	do_uninstall
else
	do_install
fi
