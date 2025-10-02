#!/bin/bash

source ~/.dotfiles/common.sh

package_list=(
	"git"
	"gh"
)

gh_extension_list=(
	"github/gh-copilot"
)

install_or_update_gh_extension() {
	local ext="$1"
	if gh extension list | grep -q "$ext"; then
		echo "Updating GitHub CLI extension: $ext"
		gh extension upgrade "$ext"
	else
		echo "Installing GitHub CLI extension: $ext"
		gh extension install "$ext"
	fi
}

for util in "${package_list[@]}"; do
	install_or_update_packages "$util"
done

# If gh is installed install gh extentions
if is_package_installed "gh"; then
	for ext in "${gh_extension_list[@]}"; do
		install_or_update_gh_extension "$ext"
	done
fi

if [[ "$PLATFORM_NAME" == "mac" ]]; then
  install_or_update_packages git-filter-repo

elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
  install_or_update_packages python3-pip -y
  pip3 install git-filter-repo
fi

symlink_dotfile "$DOTMANGR_CONFIGS_DIR/git/.gitconfig"
touch $HOME/.gitlocal
