#!/bin/bash

source ~/.dotfiles/common.sh

export BREW_BIN=$([[ "$(uname -m)" == "arm64" ]] && echo "/opt/homebrew/bin" || echo "/usr/local/bin")
eval "$($BREW_BIN/brew shellenv)" &> /dev/null || true

brew_install_or_update() {
	local package_name="$1"

	if brew list "$package_name" > /dev/null; then
		if brew outdated | grep -q "^$package_name"; then
			echo "$package_name is outdated. Updating..."
			brew upgrade "$package_name"
		else
			echo "$package_name is already up-to-date."
		fi
	else
		echo "$package_name is not installed. Installing..."
		brew install "$package_name"
	fi
}

brew_install_or_update_cask() {
	local app_name="$1"

	if brew list --cask "$app_name" &> /dev/null; then
		if brew outdated --cask | grep -q "^$app_name"; then
			echo "$app_name is outdated. Updating..."
			brew upgrade --cask "$app_name"
		else
			echo "$app_name is already up-to-date."
		fi
	else
		echo "Installing $app_name..."
		brew install --cask --force "$app_name"
	fi
}
