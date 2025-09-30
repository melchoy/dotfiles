#!/bin/bash

source ~/.dotfiles/common.sh

echo "Installing/updating yabai..."

# Function to get the installed yabai version
get_installed_version() {
	if command -v yabai &> /dev/null; then
		yabai --version 2>/dev/null | grep -oP 'yabai-v\K[0-9]+\.[0-9]+\.[0-9]+' || echo ""
	else
		echo ""
	fi
}

# Function to get the latest yabai version from GitHub
get_latest_version() {
	curl -s "https://api.github.com/repos/koekeishiya/yabai/releases/latest" | grep -oP '"tag_name": "v\K[0-9]+\.[0-9]+\.[0-9]+'
}

# Function to install or update yabai
install_or_update_yabai() {
	local action="$1"

	if [[ "$action" == "update" ]]; then
		echo "Stopping yabai service..."
		yabai --stop-service 2>/dev/null || true
	fi

	echo "${action^}ing yabai using official installer..."
	curl -L https://raw.githubusercontent.com/koekeishiya/yabai/master/scripts/install.sh | sh /dev/stdin

	if [[ $? -ne 0 ]]; then
		echo "❌ Failed to ${action} yabai"
		return 1
	fi

	configure_scripting_addition

	echo "Starting yabai service..."
	yabai --start-service

	echo "✅ Yabai ${action} complete"
}

# Function to configure the scripting addition
configure_scripting_addition() {
	local yabai_path=$(which yabai)
	local yabai_hash=$(shasum -a 256 "$yabai_path" | cut -d " " -f 1)
	local user=$(whoami)
	local sudoers_file="/private/etc/sudoers.d/yabai"

	echo "Configuring scripting addition..."

	# Create or update the sudoers file
	if [[ -f "$sudoers_file" ]]; then
		# Check if the hash needs updating
		if ! sudo grep -q "$yabai_hash" "$sudoers_file" 2>/dev/null; then
			echo "Updating sudoers file with new yabai hash..."
			echo "$user ALL=(root) NOPASSWD: sha256:$yabai_hash $yabai_path --load-sa" | sudo tee "$sudoers_file" > /dev/null
		else
			echo "Sudoers file is already up to date."
		fi
	else
		echo "Creating sudoers file..."
		echo "$user ALL=(root) NOPASSWD: sha256:$yabai_hash $yabai_path --load-sa" | sudo tee "$sudoers_file" > /dev/null
	fi

	# Load the scripting addition
	echo "Loading scripting addition..."
	sudo yabai --load-sa 2>/dev/null || true
}

# Main installation logic
if [[ "$PLATFORM_NAME" != "mac" ]]; then
	echo "❌ Yabai is only supported on macOS"
	exit 1
fi

# Check if yabai is installed
INSTALLED_VERSION=$(get_installed_version)

if [[ -z "$INSTALLED_VERSION" ]]; then
	echo "Yabai is not installed."
	install_or_update_yabai "install"
else
	echo "Yabai $INSTALLED_VERSION is currently installed."

	# Check for updates
	echo "Checking for updates..."
	LATEST_VERSION=$(get_latest_version)

	if [[ -z "$LATEST_VERSION" ]]; then
		echo "⚠️  Could not fetch latest version. Skipping update check."
	elif [[ "$INSTALLED_VERSION" == "$LATEST_VERSION" ]]; then
		echo "Yabai is already up to date ($INSTALLED_VERSION)."

		# Still ensure scripting addition is properly configured
		configure_scripting_addition
	else
		echo "Update available: $INSTALLED_VERSION → $LATEST_VERSION"
		install_or_update_yabai "update"
	fi
fi

# Provide setup instructions
echo ""
echo "📋 Setup Instructions:"
echo "1. Grant yabai accessibility permissions:"
if [[ $(sw_vers -productVersion | cut -d. -f1) -ge 13 ]]; then
	echo "   - Open System Settings → Privacy & Security → Accessibility"
else
	echo "   - Open System Preferences → Security & Privacy → Privacy → Accessibility"
fi
echo "   - Click the + button and add yabai"
echo "2. Create a yabai configuration file at ~/.config/yabai/yabairc"
echo "3. Make it executable: chmod +x ~/.config/yabai/yabairc"
echo "4. Add this line to the top of your yabairc:"
echo "   yabai -m signal --add event=dock_did_restart action=\"sudo yabai --load-sa\""
echo "   sudo yabai --load-sa"
echo ""
echo "For configuration examples, visit: https://github.com/koekeishiya/yabai/wiki"
