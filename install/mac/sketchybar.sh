#!/bin/bash

source ~/.dotfiles/common.sh

do_install() {
	echo "Installing/updating SketchyBar..."

	# SketchyBar installation via brew
	if [[ "$PLATFORM_NAME" != "mac" ]]; then
		echo "❌ SketchyBar is only supported on macOS"
		exit 1
	fi

	# Add the tap and install sketchybar
	brew tap FelixKratz/formulae
	install_or_update_package "sketchybar"

	# Setup sketchybar configuration
	echo ""
	echo "Setting up SketchyBar configuration..."

	# Create sketchybar config directory
	mkdir -p ~/.config/sketchybar

	# Symlink the sketchybar config
	symlink_dotfile "$DOTMANGR_CONFIGS_DIR/sketchybar" "$HOME/.config/sketchybar"

	# Make scripts executable
	chmod +x "$DOTMANGR_CONFIGS_DIR/sketchybar/sketchybarrc" 2>/dev/null || true
	chmod +x "$DOTMANGR_CONFIGS_DIR/sketchybar/plugins"/*.sh 2>/dev/null || true

	echo "✅ SketchyBar configuration installed"

	# Configure macOS security settings (what we can automate)
	echo ""
	echo "Configuring macOS security settings..."
	
	# Remove quarantine flags
	if command -v xattr &> /dev/null; then
		sudo xattr -rd com.apple.quarantine "$(brew --prefix)/bin/sketchybar" 2>/dev/null || true
		echo "✅ Removed quarantine flags from SketchyBar"
	fi
	
	# Start SketchyBar
	echo ""
	echo "Starting SketchyBar..."
	brew services start sketchybar

	# Wait a moment for it to start
	sleep 1

	if pgrep -x "sketchybar" > /dev/null; then
		echo "✅ SketchyBar is running"
	else
		echo "⚠️  SketchyBar may need accessibility permissions to start properly"
	fi

	# Provide setup instructions
	echo ""
	echo "📋 Optional Setup:"
	echo "For a cleaner look, hide the default macOS menu bar:"
	if [[ $(sw_vers -productVersion | cut -d. -f1) -ge 13 ]]; then
		echo "   • Open System Settings → Control Center → Automatically hide and show the menu bar: Always"
	else
		echo "   • Open System Preferences → Dock & Menu Bar → Automatically hide and show the menu bar"
	fi
	echo ""
	echo "Would you like to auto-hide the default menu bar now? (y/n)"
	read -r response
	if [[ "$response" =~ ^[Yy]$ ]]; then
		defaults write NSGlobalDomain _HIHideMenuBar -bool true
		killall Finder 2>/dev/null || true
		echo "✅ Default menu bar will now auto-hide"
	fi
	echo ""
	echo "✅ SketchyBar setup complete!"
	echo "For configuration examples, visit: https://github.com/FelixKratz/SketchyBar"
}

do_uninstall() {
	echo "Uninstalling SketchyBar..."

	# Stop the service
	brew services stop sketchybar 2>/dev/null || true

	# Remove the package
	brew uninstall sketchybar 2>/dev/null || true
	brew untap FelixKratz/formulae 2>/dev/null || true

	# Remove symlinks
	rm -f ~/.config/sketchybar 2>/dev/null || true

	echo "✅ SketchyBar uninstalled"
	echo "Note: Config files remain in ~/.dotfiles/config/sketchybar"
}

if [ "$1" == "--uninstall" ]; then
	do_uninstall
else
	do_install
fi
