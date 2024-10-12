
#!/bin/bash

source ~/.dotfiles/common.sh

echo "Reversing .DOTCONFIGS setup..."

### Uninstalling Homebrew Cask Applications ###
echo "Uninstalling Homebrew Cask Applications..."
if command -v brew &> /dev/null && casks=$(brew list --cask) && [ -n "$casks" ]; then
	for cask in $casks; do
		echo "Uninstalling $cask..."
		brew uninstall --cask "$cask"
	done
fi

### Removing Homebrew and all installed packages ###
echo "Removing Homebrew and all installed packages..."
if [ -d "/opt/homebrew" ]; then
	sudo rm -rf /opt/homebrew
elif [ -d "/usr/local/Homebrew" ]; then
	sudo rm -rf /usr/local/Homebrew
fi

echo "MacOS specific uninstallation completed."
