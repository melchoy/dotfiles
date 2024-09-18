#!/bin/bash

source ~/.dotfiles/common.sh

# Clone ASDF if not already installed
if [ ! -d "$HOME/.asdf" ]; then
  git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.14.1
fi

source $HOME/.asdf/asdf.sh
symlink_dotfile "$DOTMANGR_CONFIGS_DIR/asdf/.asdfrc"

# TODO: Implement Optional Selections

install_asdf_plugin ruby
install_asdf_package_version ruby

install_asdf_plugin erlang
install_asdf_package_version erlang

install_asdf_plugin elixir
install_asdf_package_version elixir

sh $DOTMANGR_DEV_PACKAGES_DIR/node.sh
sh $DOTMANGR_DEV_PACKAGES_DIR/golang.sh
