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


if [[ "$PLATFORM_NAME" == "mac" ]]; then
	brew install lazygit
elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
	tar xf lazygit.tar.gz lazygit
	sudo install lazygit /usr/local/bin
fi

symlink_dotfile "$DOTMANGR_CONFIGS_DIR/git/.gitconfig"
