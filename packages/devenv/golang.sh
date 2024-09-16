#!/bin/bash

source ~/.dotfiles/common.sh

if [[ "$PLATFORM_NAME" == "mac" ]]; then
	install_or_update_package golang

elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
	echo "GOLANG INSTALLER NOT YET IMPLEMENTED FOR UBUNTU"
	echo "Update this installer here ~/.dotfiles/packages/devenv/golang.sh to add ubuntu support"
fi
