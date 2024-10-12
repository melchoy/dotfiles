#!/bin/bash

source ~/.dotfiles/common.sh

package_list=(
	"ripgrep"
	"neovim"
)

for util in "${package_list[@]}"; do
	install_or_update_packages "$util"
done

clone_or_update_repo "melchoy/nvim" ~/.config/nvim
