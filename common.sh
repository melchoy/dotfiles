#!/bin/bash

OS_TYPE=$(uname -s)
export DOTMANGR_BASE_DIR=~/.dotfiles

if [[ "$OS_TYPE" == "Darwin" ]]; then
	export DOTMANGR_PLATFORM_DIR="$DOTMANGR_BASE_DIR/macos" 
elif [[ "$OS_TYPE" == "Linux" && "$(lsb_release -si)" == "Ubuntu" ]]; then
	export DOTMANGR_PLATFORM_DIR="$DOTMANGR_BASE_DIR/macos"  
else
	echo "Unknown operating system: $OS_TYPE"
	exit 1
fi

export DOTMANGR_PLATFORMSETUP_DIR="$DOTMANGR_PLATFORM_DIR/setup"

check_command_installed() {
	local cmd="$1"
	local install_cmd="$2"
	if ! command -v "$cmd" &> /dev/null; then
		echo -e "$cmd is not installed!"
		echo -e "Installing $cmd..."
		eval "$install_cmd"
	else
		echo -e "$cmd is already installed! skipping..."
	fi
}

update_or_clone_repo() {
	local repo="$1"
	local local_path="$2"
	local auth_cmd="$3"
	local clone_cmd="$4"

	if [[ -d "$local_path" ]]; then
		echo -e "Updating $repo..."
		cd "$local_path"
		if git diff-index --quiet HEAD --; then
			git pull --rebase
		else
			echo -e "Local changes detected. Skipping pull for $repo."
		fi
	else
		[[ -n "$auth_cmd" ]] && eval "$auth_cmd"
		echo -e "Cloning $repo..."
		eval "$clone_cmd"
	fi
}