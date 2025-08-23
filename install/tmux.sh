#!/bin/bash

source ~/.dotfiles/common.sh

echo "Installing tmux configuration..."

# Ensure tmux is installed (handled by core.sh)
install_or_update_packages "tmux"

# Create tmux config directory
mkdir -p ~/.config/tmux

# Symlink the main tmux config
symlink_dotfile "$DOTMANGR_CONFIGS_DIR/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

# Create symlink for backward compatibility (many systems expect ~/.tmux.conf)
symlink_dotfile "$DOTMANGR_CONFIGS_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

# Make scripts executable
chmod +x ~/.dotfiles/config/tmux/scripts/*.sh 2>/dev/null || true

echo "✅ Tmux configuration installed"
