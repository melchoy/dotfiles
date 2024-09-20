source ~/.dotfiles/common.sh

extension_list=(
  "editorconfig.editorconfig"
  "esbenp.prettier-vscode"
  "shopify.ruby-lsp"
  "dracula-theme.theme-dracula"
)

install_vscode_extensions() {
  if ! command -v code &> /dev/null; then
    echo "Error: Visual Studio Code is not installed. Please install VSCode first."
    return 1
  fi

  installed_extensions=$(code --list-extensions)

  for extension in "${extension_list[@]}"; do
    if ! echo "$installed_extensions" | grep -q "$extension"; then
      echo "Installing VSCode extension: $extension"
      if ! code --install-extension "$extension"; then
        echo "Error: Failed to install $extension. Retrying..."
        # Retry the installation once
        if ! code --install-extension "$extension"; then
          echo "Error: Failed to install $extension after retry. Skipping..."
          continue
        fi
      fi
    else
      echo "VSCode extension $extension is already installed"
    fi
  done
}

install_vscode_extensions
