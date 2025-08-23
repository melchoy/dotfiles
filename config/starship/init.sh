#!/bin/bash
# Starship initialization with tmux detection

# Choose config based on tmux presence
if [ -n "$TMUX" ]; then
    # Inside tmux - use minimal config
    export STARSHIP_CONFIG="$HOME/.dotfiles/config/starship/starship-tmux.toml"
else
    # Outside tmux - use full config
    export STARSHIP_CONFIG="$HOME/.dotfiles/config/starship/starship.toml"
fi

# Initialize starship
eval "$(starship init zsh)"
