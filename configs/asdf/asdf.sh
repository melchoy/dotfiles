#!/bin/bash

source ~/.dotfiles/common.sh

# Function to install a plugin if it's missing
function asdf_install_if_missing() {
  local plugin=$1
  local version=$2

  echo "Checking if $plugin $version is installed..."

  # Check if the plugin and version are installed
  if ! asdf where $plugin $version &>/dev/null; then
    echo "Attempting to run: asdf install $plugin $version"
    echo "Installing $plugin $version..."
    asdf install $plugin $version
    asdf reshim
  else
    echo "$plugin $version is already installed."
  fi
}

# Function to handle discrepancies between version files and prompt the user
function handle_version_discrepancy() {
  local plugin=$1
  local current_version=$2
  local file_version=$3
  local file_name=$4

  if [[ "$current_version" != "$file_version" ]]; then  # Updated to use [[ ]]
    echo "Discrepancy found for $plugin:"
    echo "  .tool-versions: $current_version"
    echo "  $file_name: $file_version"

    # Set dynamic prompt based on plugin type
    echo "Which version would you like to use? [1] .tool-versions / [0] $file_name (default)"

    # Use echo and read for Zsh compatibility
    echo -n "Choice (1, 0, or leave blank to use $file_name): "
    read choice

    case $choice in
      1)
        echo "Using version from .tool-versions: $current_version"
        echo "Updating $file_name to use version $current_version"
        if [[ "$plugin" == "ruby" ]]; then
          echo "ruby-$current_version" > "$file_name"
        else
          echo "$current_version" > "$file_name"
        fi
        ;;
      0|*)
        echo "Using version from $file_name: $file_version"
        echo "Updating .tool-versions to use version $file_version"
        # Update the specific plugin in .tool-versions
        sed -i.bak "/^$plugin /d" .tool-versions && echo "$plugin $file_version" >> .tool-versions
        asdf reshim
        ;;
    esac
  else
    echo "$plugin versions match."
  fi
}

# Function to automatically install and resolve version discrepancies
function asdf_auto_install() {
  if [ -f ".tool-versions" ]; then
    asdf install
    asdf reshim
  fi

  # Handle Ruby version
  if [ -f ".ruby-version" ]; then
    local ruby_version=$(cat .ruby-version | sed 's/ruby-//')
    local tool_version=$(asdf current ruby | awk '{print $2}')
    handle_version_discrepancy "ruby" "$tool_version" "$ruby_version" ".ruby-version"
  fi

  # Handle Node.js version
  if [ -f ".nvmrc" ]; then
    local node_version=$(cat .nvmrc)
    local tool_version=$(asdf current nodejs | awk '{print $2}')
    handle_version_discrepancy "nodejs" "$tool_version" "$node_version" ".nvmrc"
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd asdf_auto_install
