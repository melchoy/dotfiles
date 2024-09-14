#!/bin/bash
source ~/.dotfiles/common.sh

echo "Checking for Homebrew..."
if command -v brew &> /dev/null; then
	echo "Homebrew is already installed."
	update_package_manager
else
	echo "Homebrew is not installed. Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$($BREW_BIN/brew shellenv)"
	export PATH="$(dirname "$BREW_BIN"):$PATH"
fi

# A simple command line interface for the Mac App Store.
#brew install mas
