#!/bin/bash

source ~/.dotfiles/common.sh

# Clone ASDF if not already installed
if [ ! -d "$HOME/.asdf" ]; then
  git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.14.1
fi

# Source ASDF scripts
source $HOME/.asdf/asdf.sh

# Ensure ASDF is available
if command -v asdf &> /dev/null; then

  # Define plugin installation check
  is_plugin_installed() {
    local plugin_name="$1"
    asdf plugin list | grep -q "^$plugin_name" &> /dev/null
  }

  # Install plugin if not already installed
  install_plugin() {
    local plugin_name="$1"
    local plugin_repo="$2"
    if ! is_plugin_installed "$plugin_name"; then
      echo "Installing $plugin_name plugin..."
      asdf plugin add "$plugin_name" "$plugin_repo"
    else
      echo "$plugin_name plugin already installed."
    fi
  }

  # Install required plugins
  install_plugin nodejs
  install_plugin ruby
  install_plugin elixir

  # Install a default version if no version is installed
  ensure_default_version() {
    local lang="$1"
    local latest_version
    if [[ -z "$(asdf list "$lang")" ]]; then
      echo "No versions of $lang installed. Installing latest..."
      latest_version=$(asdf latest "$lang")
      asdf install "$lang" "$latest_version"
      asdf global "$lang" "$latest_version"
    else
      echo "$lang already has versions installed."
    fi
  }

  # Ensure default versions are installed
  ensure_default_version nodejs
  ensure_default_version ruby
  ensure_default_version elixir
fi
