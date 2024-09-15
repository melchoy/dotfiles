#!/bin/bash

source ~/.dotfiles/common.sh

package_list=(
	"git"
	"gh"
)

for util in "${package_list[@]}"; do
	install_or_update_packages "$util"
done

if [[ "$PLATFORM_NAME" == "mac" ]]; then
  brew install git-filter-repo

elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
  sudo apt update
  sudo apt install python3-pip -y
  pip3 install git-filter-repo
fi

