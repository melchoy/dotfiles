#!/bin/bash

source ~/.dotfiles/macos/common.sh

# Setup Homebrew
BREW_BIN=$([[ "$(uname -m)" == "arm64" ]] && echo "/opt/homebrew/bin" || echo "/usr/local/bin")
eval "$($BREW_BIN/brew shellenv)" &> /dev/null || true

echo "Checking for Homebrew..."
if command -v brew &> /dev/null; then
	echo "Homebrew is already installed."
	echo "Updating Homebrew..."
	brew update
else
	echo "Homebrew is not installed. Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"  
	eval "$($BREW_BIN/brew shellenv)"
fi

# A simple command line interface for the Mac App Store. 
#brew install mas