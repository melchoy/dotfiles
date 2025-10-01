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
	echo "📋 Setup Instructions:"
	echo "1. SketchyBar should now be running"
	echo "2. You may want to hide the default macOS menu bar:"
	echo "   - Open System Settings → Control Center → Automatically hide and show the menu bar: Always"
	echo ""
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
