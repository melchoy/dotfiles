#!/bin/bash

source ~/.dotfiles/common.sh

legacy_version_managers=(
  "nodejs:.nvmrc"
  "ruby:.ruby-version"
  #"python:.python-version"
  #"elixir:.elixir-version"
  #"erlang:.erlang-version"
  #"java:.java-version"
  #"golang:.go-version"
  #"rust:.rust-toolchain"
)

install_plugin_if_missing() {
  local plugin=$1
  local version=$2

  if ! asdf where $plugin $version &>/dev/null; then
    echo "Installing $plugin $version..."
    asdf install $plugin $version
  fi
}

handle_version_discrepancy() {
  local plugin=$1
  local current_version=$2
  local file_version=$3
  local file_name=$4

  if [[ "$current_version" != "$file_version" ]]; then
    echo "Discrepancy found for $plugin:"
    echo "  .tool-versions: $current_version"
    echo "  $file_name: $file_version"
    echo "Which version would you like to use? [1] .tool-versions / [0] $file_name (default)"
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
        sed -i.bak "/^$plugin /d" .tool-versions && echo "$plugin $file_version" >> .tool-versions
        ;;
    esac
  fi
}

check_version_file() {
  local plugin=$1
  local version_file=$2

  if [ -f "$version_file" ]; then
    local file_version=$(cat "$version_file")

    if [[ "$file_version" == "${plugin}-"* ]]; then
      file_version=$(echo "$file_version" | sed "s/${plugin}-//")
    fi

    local tool_version=$(asdf current "$plugin" | awk '{print $2}')
    handle_version_discrepancy "$plugin" "$tool_version" "$file_version" "$version_file"
  fi
}

asdf_auto_plugin_version_installer() {
  if [ -f ".tool-versions" ]; then
    echo "Checking for version discrepancies in .tool-versions..."
    asdf install
  fi

  for manager in "${legacy_version_managers[@]}"; do
    local plugin=$(echo "$manager" | cut -d':' -f1)
    local version_file=$(echo "$manager" | cut -d':' -f2)
    check_version_file "$plugin" "$version_file"
  done
}

autoload -U add-zsh-hook
add-zsh-hook chpwd asdf_auto_plugin_version_installer
