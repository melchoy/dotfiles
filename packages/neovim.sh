#!/bin/bash

source ~/.dotfiles/common.sh

package_list=(
	"neovim"
)

for util in "${package_list[@]}"; do
	install_or_update_packages "$util"
done

