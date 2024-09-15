#!/bin/bash

source ~/.dotfiles/common.sh

# Clone ASDF if not already installed
if [ ! -d "$HOME/.asdf" ]; then
  git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.14.1
fi

source $HOME/.asdf/asdf.sh
if command -v asdf &> /dev/null; then

  # Define plugin installation check
  is_asdf_plugin_installed() {
    local plugin_name="$1"
    asdf plugin list | grep -q "^$plugin_name" &> /dev/null
  }

  # Install plugin if not already installed
  install_asdf_plugin() {
    local plugin_name="$1"
    local plugin_repo="$2"
    if ! is_asdf_plugin_installed "$plugin_name"; then
      echo "Installing $plugin_name plugin..."
      asdf plugin add "$plugin_name" "$plugin_repo"
    fi
  }

  # Install required plugins
  install_asdf_plugin nodejs
  install_asdf_plugin ruby
	install_asdf_plugin erlang
  install_asdf_plugin elixir

  # Install a default version if no version is installed
  install_asdf_package_version() {
    local lang="$1"
    local latest_version
    if [[ -z "$(asdf list "$lang")" ]]; then
      echo "No versions of $lang installed. Installing latest..."
      latest_version=$(asdf latest "$lang")
      asdf install "$lang" "$latest_version"
      asdf global "$lang" "$latest_version"
    fi
  }

  # Ensure default versions are installed
  install_asdf_package_version nodejs
  install_asdf_package_version ruby
	install_asdf_package_version erlang
  install_asdf_package_version elixir

	symlink_dotfile "$DOTMANGR_CONFIGS_DIR/.asdfrc"
fi
