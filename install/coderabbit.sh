#!/bin/bash

source ~/.dotfiles/common.sh

echo "Installing & Configuring CodeRabbit CLI"

# Install CodeRabbit CLI using their official installer
# We need to prevent it from modifying shell configs (adds ~/.local/bin to PATH)
echo "Installing CodeRabbit CLI..."

# Save current shell configs to restore them after installation
SHELL_CONFIGS=()
if [ -f "$HOME/.zshrc" ]; then
    ZSHRC_BACKUP=$(mktemp)
    cp "$HOME/.zshrc" "$ZSHRC_BACKUP"
    SHELL_CONFIGS+=("$HOME/.zshrc:$ZSHRC_BACKUP")
fi

if [ -f "$HOME/.bashrc" ]; then
    BASHRC_BACKUP=$(mktemp)
    cp "$HOME/.bashrc" "$BASHRC_BACKUP"
    SHELL_CONFIGS+=("$HOME/.bashrc:$BASHRC_BACKUP")
fi

if [ -f "$HOME/.bash_profile" ]; then
    BASH_PROFILE_BACKUP=$(mktemp)
    cp "$HOME/.bash_profile" "$BASH_PROFILE_BACKUP"
    SHELL_CONFIGS+=("$HOME/.bash_profile:$BASH_PROFILE_BACKUP")
fi

if [ -f "$HOME/.profile" ]; then
    PROFILE_BACKUP=$(mktemp)
    cp "$HOME/.profile" "$PROFILE_BACKUP"
    SHELL_CONFIGS+=("$HOME/.profile:$PROFILE_BACKUP")
fi

# Run CodeRabbit installer (installs to ~/.local/bin/coderabbit)
if curl -fsSL https://cli.coderabbit.ai/install.sh | sh; then
    echo "CodeRabbit CLI installed successfully to ~/.local/bin/coderabbit"
else
    echo "Error: CodeRabbit CLI installation failed"
    exit 1
fi

# Restore shell configs (remove CodeRabbit's PATH modifications)
echo "Restoring shell configurations (removing CodeRabbit's PATH modifications)..."
for config_pair in "${SHELL_CONFIGS[@]}"; do
    original_file="${config_pair%:*}"
    backup_file="${config_pair#*:}"

    if [ -f "$backup_file" ]; then
        if ! diff -q "$original_file" "$backup_file" >/dev/null 2>&1; then
            echo "Restoring $(basename "$original_file") (CodeRabbit installer modified it)"
            cp "$backup_file" "$original_file"
        fi
        rm -f "$backup_file"
    fi
done

# Clean up any existing CodeRabbit config from main git files
git config --global --unset-all coderabbit.machineId 2>/dev/null || true

# Configure git filter to strip CodeRabbit config from commits (must run from dotfiles directory)
cd ~/.dotfiles
git config filter.clean-coderabbit.clean 'sed "/^\[coderabbit\]/,/^$/d"'
git config filter.clean-coderabbit.smudge cat
echo "✅ Git filter configured to prevent CodeRabbit config in commits"

echo "✅ CodeRabbit installation complete"
echo ""
echo "Configuration:"
echo "  - CodeRabbit binary: ~/.local/bin/coderabbit"
echo "  - Uses standard git configuration"
echo ""
echo "Usage:"
echo "  coderabbit --help    # Show help"
echo "  coderabbit review    # Run code review"
echo ""
echo "Note: Your shell configs were restored to prevent PATH modifications."
echo "CodeRabbit config will be managed by git filters to prevent commits."
