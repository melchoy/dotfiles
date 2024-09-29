#!/bin/bash

source ~/.dotfiles/common.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function install_or_update_asdf() {
  if [ ! -d "$HOME/.asdf" ]; then
    echo "Cloning asdf..."
    git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf"
    cd "$HOME/.asdf" || exit
    echo "Fetching the latest stable version..."
    git fetch --tags
    latest_tag=$(git describe --tags "$(git rev-list --tags --max-count=1)")
    git checkout "$latest_tag"
    echo "asdf installed at version $latest_tag."
  else
    echo "asdf is already installed, updating to the latest stable version..."
    cd "$HOME/.asdf" || exit
    git fetch --tags
    latest_tag=$(git describe --tags "$(git rev-list --tags --max-count=1)")
    git checkout "$latest_tag"
    echo "asdf updated to $latest_tag."
  fi
}

install_or_update_asdf
source $HOME/.asdf/asdf.sh
symlink_dotfile "$DOTMANGR_CONFIGS_DIR/asdf/.asdfrc"

# TODO: Implement Optional Selections

install_asdf_plugin ruby
install_asdf_package_version ruby

install_asdf_plugin erlang
install_asdf_package_version erlang

install_asdf_plugin elixir
install_asdf_package_version elixir

sh "$SCRIPT_DIR/node.sh"
sh "$SCRIPT_DIR/golang.sh"


