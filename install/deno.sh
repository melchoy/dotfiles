#!/bin/bash

source ~/.dotfiles/common.sh

install_deno() {
	if [[ "$PLATFORM_NAME" == "mac" ]]; then
		install_or_update_package deno
		
		# Verify installation
		if command -v deno &> /dev/null; then
			echo "Deno installed successfully:"
			deno --version
		else
			echo "Warning: Deno installation may have failed - command not found in PATH"
		fi

	elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
		echo "DENO INSTALLER NOT YET IMPLEMENTED FOR UBUNTU"
		echo "Update this installer here ~/.dotfiles/install/deno.sh to add ubuntu support"
	fi
}

uninstall_deno() {
	if [[ "$PLATFORM_NAME" == "mac" ]]; then
		if is_package_installed "deno"; then
			echo "Uninstalling Deno..."
			brew uninstall deno
		else
			echo "Deno is not installed via Homebrew."
		fi
	elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
		echo "DENO UNINSTALLER NOT YET IMPLEMENTED FOR UBUNTU"
	fi
}

# Parse command line arguments
if [[ "$1" == "--uninstall" ]]; then
	uninstall_deno
else
	install_deno
fi