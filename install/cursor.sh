#!/bin/bash

source ~/.dotfiles/common.sh

extension_list=(
  "vscodevim.vim"
  "editorconfig.editorconfig"
  "esbenp.prettier-vscode"

  "Gruntfuggly.todo-tree"

  "golang.Go"
  "shopify.ruby-lsp"

  "tamasfe.even-better-toml"

  "dracula-theme.theme-dracula"
  "catppuccin.catppuccin-vsc"
)

install_cursor_extensions() {
  if ! command -v cursor &> /dev/null; then
    echo "Error: Cursor is not installed. Please install Cursor first."
    return 1
  fi

  installed_extensions=$(cursor --list-extensions)

  for extension in "${extension_list[@]}"; do
    if ! echo "$installed_extensions" | grep -q "$extension"; then
      echo "Installing Cursor extension: $extension"
      if ! cursor --install-extension "$extension" --force; then
        echo "Error: Failed to install $extension. Retrying..."
        # Retry the installation once
        if ! cursor --install-extension "$extension" --force; then
          echo "Error: Failed to install $extension after retry. Skipping..."
          continue
        fi
      fi
    else
      echo "Cursor extension $extension is already installed"
    fi
  done
}

if [[ "$PLATFORM_NAME" == "mac" ]]; then
  if ! command -v cursor &> /dev/null || [[ ! -d "/Applications/Cursor.app" ]]; then
    echo "Installing Cursor from official site..."

    # Download Cursor DMG for macOS
    cursor_dmg="/tmp/cursor-$(date +%s).dmg"
    if ! curl -fL "https://download.cursor.sh/mac" -o "$cursor_dmg"; then
      echo "Error: Failed to download Cursor"
      return 1
    fi

    # Mount the DMG
    mount_point="/tmp/cursor-mount-$(date +%s)"
    if ! hdiutil attach "$cursor_dmg" -mountpoint "$mount_point" -nobrowse -quiet; then
      echo "Error: Failed to mount Cursor DMG"
      rm -f "$cursor_dmg"
      return 1
    fi

    # Install Cursor to Applications
    echo "Installing Cursor.app to /Applications..."
    if ! cp -R "$mount_point/Cursor.app" "/Applications/"; then
      echo "Error: Failed to install Cursor"
      hdiutil detach "$mount_point" -quiet
      rm -f "$cursor_dmg"
      return 1
    fi

    # Clean up
    hdiutil detach "$mount_point" -quiet
    rm -f "$cursor_dmg"

    # Remove quarantine attribute
    xattr -dr com.apple.quarantine "/Applications/Cursor.app" 2>/dev/null || true

    echo "Cursor installed successfully"
  fi

  # Backup existing Cursor settings if they exist and aren't already symlinked
  cursor_settings="$HOME/Library/Application Support/Cursor/User/settings.json"
  if [[ -f "$cursor_settings" && ! -L "$cursor_settings" ]]; then
    echo "Backing up existing Cursor settings..."
    mv "$cursor_settings" "${cursor_settings}.backup.$(date +%Y%m%d-%H%M%S)"
  fi

  # Symlink configuration files
  #symlink_dotfile ~/.dotfiles/config/vscode/macos/keybindings.json ~/Library/Application\ Support/Cursor/User/keybindings.json
  symlink_dotfile ~/.dotfiles/config/vscode/settings.json ~/Library/Application\ Support/Cursor/User/settings.json
  symlink_dotfile ~/.dotfiles/config/vscode/snippets ~/Library/Application\ Support/Cursor/User/snippets

elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
  if ! command -v cursor &> /dev/null; then
    echo "Installing Cursor from official site..."

    # Download Cursor AppImage for Linux
    cursor_appimage="/tmp/cursor-$(date +%s).AppImage"
    if ! curl -fL "https://download.cursor.sh/linux/appImage/x64" -o "$cursor_appimage"; then
      echo "Error: Failed to download Cursor"
      return 1
    fi

    # Make it executable and install to /usr/local/bin
    chmod +x "$cursor_appimage"
    echo "Installing Cursor to /usr/local/bin..."
    sudo mv "$cursor_appimage" "/usr/local/bin/cursor"

    # Create desktop entry
    sudo tee /usr/share/applications/cursor.desktop > /dev/null << 'EOF'
[Desktop Entry]
Name=Cursor
Exec=/usr/local/bin/cursor %F
Terminal=false
Type=Application
Icon=cursor
StartupWMClass=Cursor
Comment=The AI-first code editor
MimeType=text/plain;inode/directory;
Categories=TextEditor;Development;IDE;
EOF

    echo "Cursor installed successfully"
  fi

  # Backup existing Cursor settings if they exist and aren't already symlinked
  cursor_settings="$HOME/.config/Cursor/User/settings.json"
  if [[ -f "$cursor_settings" && ! -L "$cursor_settings" ]]; then
    echo "Backing up existing Cursor settings..."
    mv "$cursor_settings" "${cursor_settings}.backup.$(date +%Y%m%d-%H%M%S)"
  fi

  # symlink_dotfile ~/.dotfiles/config/vscode/linux/keybindings.json ~/.config/Cursor/User/keybindings.json
  symlink_dotfile ~/.dotfiles/config/vscode/settings.json ~/.config/Cursor/User/settings.json
  symlink_dotfile ~/.dotfiles/config/vscode/snippets ~/.config/Cursor/User/snippets
fi

install_cursor_extensions
