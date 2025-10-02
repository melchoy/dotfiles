#!/bin/bash

source ~/.dotfiles/common.sh

install_gitkraken_mac() {
	brew_install_or_update_cask gitkraken

	install_or_update_packages gitkraken-cli

	if [ -d "/Applications/Visual Studio Code.app" ]; then
		code --install-extension eamodio.gitlens --force
	fi
}

install_gitkraken_linux() {
	echo "GitKraken install for Ubuntu is not implemented yet"
	echo "Get off your arse and do it!"
	echo "Or install it manually from https://www.gitkraken.com/download"
}

if [[ "$PLATFORM_NAME" == "mac" ]]; then
	install_gitkraken_mac
elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
	install_gitkraken_linux
fi
