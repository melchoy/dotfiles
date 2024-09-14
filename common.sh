#!/bin/bash

OS_TYPE=$(uname -s)

if [[ "$OS_TYPE" == "Darwin" ]]; then
	PLATFORM_NAME="mac"
	INSTALL_PACKAGE_CMD="brew install"
	UPDATE_PACKAGE_CMD="brew upgrade"
	UPDATE_PACKAGE_MANAGER_CMD="brew update"
	CHECK_OUTDATED_PACKAGE_CMD="brew outdated --quiet"

	BREW_BIN=$([[ "$(uname -m)" == "arm64" ]] && echo "/opt/homebrew/bin" || echo "/usr/local/bin")
	[[ -x "$BREW_BIN/brew" ]] && eval "$($BREW_BIN/brew shellenv)" &>/dev/null || true

elif [[ "$OS_TYPE" == "Linux" && "$(lsb_release -si)" == "Ubuntu" ]]; then
	PLATFORM_NAME="ubuntu"
	INSTALL_PACKAGE_CMD="sudo apt-get install -y"
	UPDATE_PACKAGE_CMD="sudo apt-get upgrade -y"
	UPDATE_PACKAGE_MANAGER_CMD="sudo apt-get update"
	CHECK_OUTDATED_PACKAGE_CMD="apt list --upgradable"

else
	echo "Unknown operating system: $OS_TYPE"
	exit 1
fi

# TODO: Figure out which of these are still required!
DOTMANGR_BASE_DIR=~/.dotfiles
DOTMANGR_PLATFORM_DIR="$DOTMANGR_BASE_DIR/$PLATFORM_NAME"

DOTMANGR_INSTALL_DIR=$DOTMANGR_BASE_DIR/install
DOTMANGR_PLATFORM_INSTALL_DIR="$DOTMANGR_INSTALL_DIR/$PLATFORM_NAME"

#DOTMANGR_PLATFORMSETUP_DIR="$DOTMANGR_PLATFORM_DIR/setup"

DOT_SOURCE_BASE_DIR="$DOTMANGR_BASE_DIR/dots"

is_command_installed() {
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

is_package_outdated() {
	local cmd="$1"
	if eval "$CHECK_OUTDATED_PACKAGE_CMD" | grep -q "$cmd"; then
		return 0
	else
		return 1
	fi
}

clone_or_update_repo() {
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

update_package_manager() {
	echo "Updating package manager..."
  eval "$UPDATE_PACKAGE_MANAGER_CMD"
}

install_or_update_package() {
  local update_manager=false  # Default is false
  local cmds=()

  for arg in "$@"; do
    if [[ "$arg" == --update_manager ]]; then
      update_manager=true
    else
      cmds+=("$arg")  # Treat any other argument as a package name
    fi
  done

  if [[ "$update_manager" == true ]]; then
    update_package_manager
  fi

  for cmd in "${cmds[@]}"; do
    if is_command_installed "$cmd"; then
      if is_package_outdated "$cmd"; then
        echo "$cmd is outdated. Updating..."
        eval "$UPDATE_PACKAGE_CMD $cmd"
      fi
    else
      echo "$cmd is not installed. Installing..."
      eval "$INSTALL_PACKAGE_CMD $cmd"
    fi
  done
}
