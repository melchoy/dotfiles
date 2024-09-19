#!/bin/bash

source ~/.dotfiles/common.sh

extension_list=(
  "editorconfig.editorconfig"
  "esbenp.prettier-vscode"
  "shopify.ruby-lsp"
)

install_vscode_extensions() {
  if ! command -v code &> /dev/null; then
    echo "Error: Visual Studio Code is not installed. Please install VSCode first."
    return 1
  fi

  for extension in "${extension_list[@]}"; do
    if ! code --list-extensions | grep -q "$extension"; then
      echo "Installing VSCode extension: $extension"
      if ! code --install-extension "$extension"; then
        echo "Error: Failed to install $extension. Retrying..."
        # Retry the installation once
        if ! code --install-extension "$extension"; then
          echo "Error: Failed to install $extension after retry. Skipping..."
          continue
        fi
      fi
      echo "Successfully installed $extension"
    else
      echo "VSCode extension $extension is already installed"
    fi
  done

  # Check if VSCode is running
  if pgrep -x "Code" > /dev/null || pgrep -x "code" > /dev/null; then
    echo "Reloading VSCode to apply the changes..."
    code --force  
  fi
}


if [[ "$PLATFORM_NAME" == "mac" ]]; then
  install_or_update_package "visual-studio-code"

  # Symlink configuration files
  symlink_dotfile ~/.dotfiles/configs/vscode/macos/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
  symlink_dotfile ~/.dotfiles/configs/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
  symlink_dotfile ~/.dotfiles/configs/vscode/snippets ~/Library/Application\ Support/Code/User/snippets

elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
  if ! dpkg -l | grep -q "code"; then
    echo "VSCode not found, adding repository and installing..."

    # Add Microsoft repository and GPG key
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt update
  fi

  install_or_update_package "code"

  symlink_dotfile ~/.dotfiles/configs/vscode/ubuntu/keybindings.json ~/.config/Code/User/keybindings.json
  symlink_dotfile ~/.dotfiles/configs/vscode/settings.json ~/.config/Code/User/settings.json
  symlink_dotfile ~/.dotfiles/configs/vscode/snippets ~/.config/Code/User/snippets
fi

install_vscode_extensions
