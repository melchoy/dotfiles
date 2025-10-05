#!/bin/zsh

source ~/.dotfiles/common.sh

if [[ "$PLATFORM_NAME" == "mac" ]]; then
	brew_install_or_update_cask alacritty --no-quarantine

	# Symlink configuration files
	symlink_dotfile ~/.dotfiles/config/alacritty/alacritty.toml ~/.alacritty.toml

	# Configure dock visibility (default: hide from dock)
	ALACRITTY_HIDE_DOCK=${ALACRITTY_HIDE_DOCK:-true}
	ALACRITTY_PLIST="/Applications/Alacritty.app/Contents/Info.plist"

	if [[ "$ALACRITTY_HIDE_DOCK" == "true" ]]; then
		echo "🔧 Hiding Alacritty from dock..."
		if [[ -f "$ALACRITTY_PLIST" ]]; then
			# Add LSUIElement to hide from dock
			/usr/libexec/PlistBuddy -c "Add :LSUIElement bool true" "$ALACRITTY_PLIST" 2>/dev/null || \
			/usr/libexec/PlistBuddy -c "Set :LSUIElement true" "$ALACRITTY_PLIST"
			echo "✅ Alacritty hidden from dock"
		else
			echo "⚠️  Alacritty.app not found, skipping dock configuration"
		fi
	else
		echo "🔧 Showing Alacritty in dock..."
		if [[ -f "$ALACRITTY_PLIST" ]]; then
			# Remove LSUIElement to show in dock
			/usr/libexec/PlistBuddy -c "Delete :LSUIElement" "$ALACRITTY_PLIST" 2>/dev/null || true
			echo "✅ Alacritty visible in dock"
		else
			echo "⚠️  Alacritty.app not found, skipping dock configuration"
		fi
	fi
elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
	echo "TODO: Implement alacritty installation for Ubuntu"
fi
