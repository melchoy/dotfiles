#!/bin/bash

source ~/.dotfiles/common.sh

function asdf_install_if_missing() {
  local plugin=$1
  local version=$2

  if ! asdf where $plugin $version &>/dev/null; then
    echo "Installing $plugin $version..."
    asdf install $plugin $version
    asdf reshim
  fi
}

function asdf_auto_install() {
  if [ -f ".tool-versions" ]; then
    asdf install
    asdf reshim
  else
    if [ -f ".ruby-version" ]; then
      local ruby_version=$(cat .ruby-version)
      asdf_install_if_missing ruby "$ruby_version"
      asdf local ruby "$ruby_version"
    fi

    if [ -f ".nvmrc" ]; then
      local node_version=$(cat .nvmrc)
      asdf_install_if_missing nodejs "$node_version"
      asdf local nodejs "$node_version"
    fi
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd asdf_auto_install