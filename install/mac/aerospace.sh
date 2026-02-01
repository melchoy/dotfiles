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

	# Install borders (for window highlighting)
	echo ""
	echo "Installing borders for window highlighting..."
	if ! brew list borders &>/dev/null; then
		brew tap FelixKratz/formulae 2>/dev/null || true
	fi
	install_or_update_package "borders"

	# Setup borders configuration
	echo ""
	echo "Setting up borders configuration..."
	mkdir -p ~/.config/borders
	symlink_dotfile "$DOTMANGR_CONFIGS_DIR/borders" "$HOME/.config/borders"
	chmod +x "$DOTMANGR_CONFIGS_DIR/borders/borders-launch.sh"
	echo "✅ Borders configuration installed"

	# Setup aerospace configuration
	echo ""
	echo "Setting up Aerospace configuration..."

	# Create aerospace config directory
	mkdir -p ~/.config/aerospace

	# Symlink the aerospace config
	symlink_dotfile "$DOTMANGR_CONFIGS_DIR/aerospace" "$HOME/.config/aerospace"

	echo "✅ Aerospace configuration installed"

	# Configure macOS security settings (what we can automate)
	echo ""
	echo "Configuring macOS security settings..."
	
	# Disable Gatekeeper warnings for these apps
	if command -v spctl &> /dev/null; then
		sudo spctl --add /Applications/AeroSpace.app 2>/dev/null || true
		sudo xattr -rd com.apple.quarantine /Applications/AeroSpace.app 2>/dev/null || true
		echo "✅ Removed quarantine flags from AeroSpace"
	fi
	
	# Remove AeroSpace from System Events login items so only our LaunchAgent starts it
	osascript -e 'tell application "System Events" to delete login item "AeroSpace"' 2>/dev/null || true

	# Setup LaunchAgents: borders and AeroSpace (write plists with __HOME__ substituted)
	echo ""
	echo "Setting up borders and AeroSpace launch agents..."

	mkdir -p ~/Library/LaunchAgents

	launchctl unload ~/Library/LaunchAgents/com.felixkratz.borders.plist 2>/dev/null || true
	launchctl unload ~/Library/LaunchAgents/com.felixkratz.aerospace.plist 2>/dev/null || true

	sed "s|__HOME__|$HOME|g" "$DOTMANGR_CONFIGS_DIR/mac/launchagents/com.felixkratz.borders.plist" \
		> ~/Library/LaunchAgents/com.felixkratz.borders.plist
	sed "s|__HOME__|$HOME|g" "$DOTMANGR_CONFIGS_DIR/mac/launchagents/com.felixkratz.aerospace.plist" \
		> ~/Library/LaunchAgents/com.felixkratz.aerospace.plist

	launchctl load ~/Library/LaunchAgents/com.felixkratz.borders.plist
	launchctl load ~/Library/LaunchAgents/com.felixkratz.aerospace.plist

	chmod +x "$DOTMANGR_CONFIGS_DIR/mac/launchagents/aerospace-wrapper.sh"

	echo "✅ Borders and AeroSpace launch agents installed and loaded"
	echo "   Edit ~/.config/borders/bordersrc to customize colors/width"

	# Start AeroSpace now only if not disabled
	[[ -f "$HOME/.env.local" ]] && source "$HOME/.env.local"
	if [[ "$DISABLE_AEROSPACE" != "1" ]]; then
		echo ""
		echo "Starting Aerospace..."
		open -a AeroSpace
		sleep 1
		if pgrep -x "AeroSpace" > /dev/null; then
			echo "✅ Aerospace is running"
		else
			echo "⚠️  Aerospace may need accessibility permissions to start properly"
		fi
	fi

	# Provide setup instructions
	echo ""
	echo "📋 Manual Setup Required:"
	echo "Grant Accessibility permissions (cannot be automated):"
	if [[ $(sw_vers -productVersion | cut -d. -f1) -ge 13 ]]; then
		echo "   1. Open System Settings → Privacy & Security → Accessibility"
	else
		echo "   1. Open System Preferences → Security & Privacy → Privacy → Accessibility"
	fi
	echo "   2. Click the lock icon and authenticate"
	echo "   3. Click the + button and add:"
	echo "      • AeroSpace (/Applications/AeroSpace.app)"
	echo "      • borders ($(which borders))"
	echo ""
	echo "Would you like to open System Settings now? (y/n)"
	read -r response
	if [[ "$response" =~ ^[Yy]$ ]]; then
		if [[ $(sw_vers -productVersion | cut -d. -f1) -ge 13 ]]; then
			open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
		else
			open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
		fi
		echo "⏸️  Waiting for you to grant permissions... Press Enter when done."
		read -r
	fi
	echo ""
	echo "✅ Setup complete! AeroSpace and borders will start automatically"
	echo "For configuration examples, visit: https://nikitabobko.github.io/AeroSpace/guide"
}

do_uninstall() {
	echo "Uninstalling Aerospace..."

	# First unload and remove AeroSpace login LaunchAgent
	launchctl unload ~/Library/LaunchAgents/com.felixkratz.aerospace.plist 2>/dev/null || true
	rm -f ~/Library/LaunchAgents/com.felixkratz.aerospace.plist 2>/dev/null || true

	# Stop Aerospace and borders
	pkill -9 AeroSpace 2>/dev/null || true
	launchctl unload ~/Library/LaunchAgents/com.felixkratz.borders.plist 2>/dev/null || true
	rm -f ~/Library/LaunchAgents/com.felixkratz.borders.plist 2>/dev/null || true
	pkill -9 borders 2>/dev/null || true

	osascript -e 'tell application "System Events" to delete login item "AeroSpace"' 2>/dev/null || true

	brew uninstall --cask aerospace 2>/dev/null || true
	brew untap nikitabobko/tap 2>/dev/null || true
	brew uninstall borders 2>/dev/null || true

	rm -rf ~/.config/aerospace 2>/dev/null || true
	rm -rf ~/.config/borders 2>/dev/null || true

	echo "✅ Aerospace and borders uninstalled"
	echo "Note: Config files remain in ~/.dotfiles/config/aerospace and ~/.dotfiles/config/borders"
}

if [ "$1" == "--uninstall" ]; then
	do_uninstall
else
	do_install
fi
