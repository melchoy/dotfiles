#!/bin/bash

OS_TYPE=$(uname -s)

if [[ "$OS_TYPE" == "Darwin" ]]; then
	PLATFORM_NAME="mac"
	INSTALL_PACKAGE_CMD="brew install"
	UPDATE_PACKAGE_CMD="brew upgrade"
	UPDATE_PACKAGE_MANAGER_CMD="brew update"
	OUTDATED_PACKAGE_LIST=$(brew outdated --quiet 2>/dev/null)

	BREW_BIN=$([[ "$(uname -m)" == "arm64" ]] && echo "/opt/homebrew/bin" || echo "/usr/local/bin")
	[[ -x "$BREW_BIN/brew" ]] && eval "$($BREW_BIN/brew shellenv)" &>/dev/null || true

elif [[ "$OS_TYPE" == "Linux" && "$(lsb_release -si)" == "Ubuntu" ]]; then
	PLATFORM_NAME="ubuntu"
	INSTALL_PACKAGE_CMD="sudo apt-get install -y"
	UPDATE_PACKAGE_CMD="sudo apt-get upgrade -y"
	UPDATE_PACKAGE_MANAGER_CMD="sudo apt-get update"
	OUTDATED_PACKAGE_LIST=$(apt list --upgradable 2>/dev/null | grep -oP '^\S+' | tail -n +2)

else
	echo "Unknown operating system: $OS_TYPE"
	exit 1
fi

DOTMANGR_BASE_DIR=~/.dotfiles

DOTMANGR_LOCAL_DIR=$DOTMANGR_BASE_DIR/@local
DOTMANGR_BACKUP_DIR=$DOTMANGR_LOCAL_DIR/bkup

DOTMANGR_CONFIGS_DIR=$DOTMANGR_BASE_DIR/configs
DOTMANGR_PACKAGES_DIR=$DOTMANGR_BASE_DIR/packages

DOTMANGR_PLATFORM_DIR="$DOTMANGR_BASE_DIR/platforms/$PLATFORM_NAME"

symlink_dotfile() {
	# Assign source and target variables
	local source_file=$1
	local target_file=${2:-"$HOME/$(basename "$source_file")"}
	local backup_dir=$DOT_SOURCE_BASE_DIR
	local timestamp=$(date +"%Y%m%d_%H%M%S")

	if [ ! -f "$source_file" ]; then
		echo "Error: Source file '$source_file' does not exist."
		return 1
	fi

	# Backup existing dotfile
	if [ -e "$target_file" ] && [ ! -L "$target_file" ]; then
		mkdir -p "$backup_dir"
		local backup_file="$backup_dir/$(basename "$target_file").bak_$timestamp"
		mv "$target_file" "$backup_file"
		echo "Existing target file '$target_file' backed up to '$backup_file'."
	fi

	ln -sf "$source_file" "$target_file"
	echo "Symlink created: $source_file -> $target_file"
}

is_package_installed() {
  local package_name="$1"

  if [[ "$PLATFORM_NAME" == "mac" ]]; then
    # Check both brew and brew cask for the package
    brew list --cask "$package_name" &>/dev/null || brew list "$package_name" &>/dev/null
  elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
    dpkg -l | grep -q "^ii  $package_name "
  else
    return 1
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
		echo "$cmd is already installed."
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
