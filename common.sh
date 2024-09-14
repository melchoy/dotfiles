#!/bin/bash

OS_TYPE=$(uname -s)

if [[ "$OS_TYPE" == "Darwin" ]]; then
	PLATFORM_NAME="mac"
	INSTALL_PACKAGE_CMD="brew install"
	UPDATE_PACKAGE_CMD="brew upgrade"
	UPDATE_PACKAGE_MANAGER_CMD="brew update"
	OUTDATED_PACKAGE_LIST=$(brew outdated --quiet 2>/dev/null)
	INSTALLED_PACKAGE_CHECK_CMD="brew list --cask | grep -q '^$package_name$' || brew list | grep -q '^$package_name$'"

	BREW_BIN=$([[ "$(uname -m)" == "arm64" ]] && echo "/opt/homebrew/bin" || echo "/usr/local/bin")
	[[ -x "$BREW_BIN/brew" ]] && eval "$($BREW_BIN/brew shellenv)" &>/dev/null || true

elif [[ "$OS_TYPE" == "Linux" && "$(lsb_release -si)" == "Ubuntu" ]]; then
	PLATFORM_NAME="ubuntu"
	INSTALL_PACKAGE_CMD="sudo apt-get install -y"
	UPDATE_PACKAGE_CMD="sudo apt-get upgrade -y"
	UPDATE_PACKAGE_MANAGER_CMD="sudo apt-get update"
	OUTDATED_PACKAGE_LIST=$(apt list --upgradable 2>/dev/null | grep -oP '^\S+' | tail -n +2)
	INSTALLED_PACKAGE_CHECK_CMD="dpkg -l | grep -q '^ii  $package_name '"

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

is_package_installed() {
  local package_name="$1"

  if eval "$PACKAGE_INSTALL_CHECK_CMD"; then
    return 0 # true
  else
    return 1 # false
  fi
}


is_package_outdated() {
  local package_name="$1"

  if echo "$OUTDATED_PACKAGE_LIST" | grep -q "^$package_name$"; then
    return 0 # true
  else
    return 1 # false
  fi
}

github_auth_and_clone() {
  local repo_url="$1"
  local local_path="$2"

  if ! gh auth status &> /dev/null; then
    echo "GitHub is not authenticated. Logging in..."
    gh auth login
  fi

  gh repo clone "$repo_url" "$local_path"
}

clone_or_update_repo() {
  local repo="$1"
  local local_path="$2"
  local clone_cmd="git clone git@github.com:$repo.git $local_path"

  shift 2 # Shift past the first two positional arguments

  if [[ "$1" == "--clone_cmd" ]]; then
    clone_cmd="$2"
    shift 2
  fi

  if [[ -d "$local_path" ]]; then
    echo "Updating $repo..."
    cd "$local_path"
    if git diff-index --quiet HEAD --; then
      git pull --rebase
    else
      echo "Local changes detected. Skipping pull for $repo."
    fi
  else
    echo "Cloning $repo into $local_path..."
    eval "$clone_cmd"
  fi
}

update_package_manager() {
	echo "Updating package manager..."
  eval "$UPDATE_PACKAGE_MANAGER_CMD"
}

install_or_update_package() {
	local cmd="$1"

	if is_package_installed "$cmd"; then
		# echo "$cmd is already installed."
		if is_package_outdated "$cmd"; then
			echo "$cmd is outdated. Updating..."
			$UPDATE_PACKAGE_CMD "$cmd"
		fi
	else
		echo "$cmd is not installed. Installing..."
		eval $INSTALL_PACKAGE_CMD "$cmd"
	fi
}

install_or_update_packages() {
	local update_package_manager=false
	local cmds=()

	# Parse arguments
	for arg in "$@"; do
		if [[ "$arg" == --update_package_manager ]]; then
			update_update_package_managermanager=true
		else
			cmds+=("$arg")
		fi
	done

	if [[ "$update_package_manager" == true ]]; then
		echo "Updating package manager..."
		eval "$UPDATE_PACKAGE_MANAGER_CMD"
	fi

	for cmd in "${cmds[@]}"; do
		install_or_update_package "$cmd"
	done
}
