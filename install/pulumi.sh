#!/bin/bash

source ~/.dotfiles/common.sh

echo "Installing & Configuring Starship Prompt"

if [[ "$PLATFORM_NAME" == "mac" ]]; then
	install_or_update_packages pulumi
elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
	echo "TODO: Implement Pulumi installation for Ubuntu"
	# curl -fsSL https://get.pulumi.com | sh
fi

