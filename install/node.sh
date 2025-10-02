#!/bin/zsh

source ~/.dotfiles/common.sh

# Function to install the latest stable (LTS) version of Node.js
install_node() {
  export PROFILE=/dev/null # Disable automatically adding to .zshrc or .bashrc

  # Determine the latest nvm version tag
  echo "Fetching the latest nvm version tag..."
  LATEST_NVM_TAG=$(curl -s "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | awk -F'"' '/"tag_name":/ {print $4}')

  if [ -z "$LATEST_NVM_TAG" ]; then
    echo "Error: Could not automatically fetch the latest nvm version tag. Using a fallback version (v0.40.0)."
    LATEST_NVM_TAG="v0.40.0" # Fallback to a known stable version if API call fails
  fi
  echo "Attempting to install/update nvm to version: $LATEST_NVM_TAG"
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$LATEST_NVM_TAG/install.sh" | bash

  export NVM_DIR="$HOME/.nvm"
  # Source nvm to make it available in the current script session
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    \. "$NVM_DIR/nvm.sh" # Load nvm
    # Optionally load bash_completion if it exists and you use it
    # [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    echo "nvm loaded."
  else
    echo "Error: nvm.sh not found after installation. Please check nvm installation."
    return 1
  fi

  nvm install --lts
  nvm alias default lts/*
  # Explicitly use the default version in the current script session
  # This ensures subsequent 'node' and 'npm' commands use the correct version
  if command -v nvm &> /dev/null && nvm alias default &> /dev/null; then
    nvm use default
  fi

  node -v && npm -v

  # List installed Node.js versions
  nvm ls

  # --- PNPM Installation and Setup ---
  echo "Installing/Updating pnpm globally via npm..."
  npm install -g pnpm # This makes the 'pnpm' command available

  # Source your centralized pnpm configuration to set PNPM_HOME and update PATH for the current script session
  if [ -f "$HOME/.dotfiles/config/node/pnpm.sh" ]; then
    echo "Sourcing $HOME/.dotfiles/config/node/pnpm.sh to configure pnpm environment for current script..."
    source "$HOME/.dotfiles/config/node/pnpm.sh"
    # After sourcing, PNPM_HOME should be defined. Now ensure the directory exists.
    if [ -n "$PNPM_HOME" ]; then
      echo "Ensuring PNPM_HOME directory exists: $PNPM_HOME"
      mkdir -p "$PNPM_HOME"
    else
      echo "Warning: PNPM_HOME was not set after sourcing config/node/pnpm.sh. pnpm might not work correctly."
    fi
  else
    echo "Warning: $HOME/.dotfiles/config/node/pnpm.sh not found. Using fallback pnpm configuration."
    # Fallback logic
    if [[ "$(uname)" == "Darwin" ]]; then
      export PNPM_HOME="$HOME/Library/pnpm"
    else
      export PNPM_HOME="$HOME/.local/share/pnpm"
    fi
    echo "Ensuring PNPM_HOME directory exists (fallback): $PNPM_HOME"
    mkdir -p "$PNPM_HOME"
    if [[ ":$PATH:" != *":$PNPM_HOME:"* ]]; then # Add to PATH if not already there
      export PATH="$PNPM_HOME:$PATH"
    fi
  fi

  echo "PNPM_HOME is currently set to: $PNPM_HOME"

  # Explicitly tell pnpm its global bin directory if PNPM_HOME is set
  if [ -n "$PNPM_HOME" ] && command -v pnpm &> /dev/null; then
    echo "Setting pnpm global-bin-dir to $PNPM_HOME..."
    pnpm config set global-bin-dir "$PNPM_HOME"
  elif ! command -v pnpm &> /dev/null; then
    echo "Error: pnpm command not found before attempting to set global-bin-dir."
  fi

  # pnpm setup is intentionally omitted to prevent modifications to .zshrc
  # config/node/pnpm.sh sourced by .zprofile should handle pnpm env for interactive shells.

  echo "Ensuring pnpm is updated to its latest version..."
  if command -v pnpm &> /dev/null; then
    pnpm self-update # New recommended method to update pnpm
    echo "Current pnpm version:"
    pnpm --version
  else
    echo "Error: pnpm command not found. Cannot update pnpm."
  fi
  # --- End PNPM Installation and Setup ---
}

# Function to uninstall all installed Node.js versions
uninstall_node() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

  # Deactivate the current Node.js version
  nvm deactivate

  # Remove the entire .nvm directory
  rm -rf "$NVM_DIR"
	echo "Node.js and NVM uninstalled successfully."
}

# Parse command line arguments
if [[ "$1" == "--uninstall" ]]; then
  uninstall_node
else
  install_node
fi
