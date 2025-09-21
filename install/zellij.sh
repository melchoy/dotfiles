#!/bin/bash

source ~/.dotfiles/common.sh

echo "Installing Zellij terminal multiplexer..."

if [[ "$PLATFORM_NAME" == "mac" ]]; then
	install_or_update_packages "zellij"
elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
	echo "Installing Zellij via cargo (Ubuntu)..."
	if ! command -v cargo >/dev/null 2>&1; then
		echo "Installing Rust/cargo first..."
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
		source ~/.cargo/env
	fi
	cargo install zellij
else
	echo "Zellij installation not configured for $PLATFORM_NAME"
	echo "Please install manually from https://zellij.dev/"
	return 1
fi

# Create zellij config directory
mkdir -p ~/.config/zellij

# Create basic zellij config (optional - zellij works great with defaults)
cat > ~/.config/zellij/config.kdl << 'EOF'
keybinds {
    normal {
        // Unbind Ctrl+b (tmux default) to avoid conflicts
        unbind "Ctrl b"
        // Keep Ctrl+o for tmux compatibility
        bind "Ctrl o" { SwitchToMode "tmux"; }
    }
    tmux {
        bind "Ctrl o" { SwitchToMode "normal"; }
    }
}
EOF

echo "✅ Zellij installed successfully"
echo ""
echo "Usage:"
echo "  zellij        # Start Zellij"
echo "  zellij --help # Show all options"
echo ""
echo "Zellij vs Tmux:"
echo "  • Zellij has better defaults and modern UI"
echo "  • Both work great - use whichever you prefer!"
echo "  • No conflicts between them"
