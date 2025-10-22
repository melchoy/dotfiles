#!/bin/zsh
# SDKMAN! initialization for Java

export SDKMAN_DIR="$HOME/.sdkman"

# Load SDKMAN! if it exists
if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
  source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

