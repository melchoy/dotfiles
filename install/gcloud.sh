#!/bin/bash

source ~/.dotfiles/common.sh

echo "Installing & Configuring Starship Prompt"

if [[ "$PLATFORM_NAME" == "mac" ]]; then
	brew_install_or_update_cask google-cloud-sdk
elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
	echo "TODO: Implement GCP installation for Ubuntu"
fi

