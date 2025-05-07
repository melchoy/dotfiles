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
    # It might be prudent to exit here if nvm isn't loaded, as subsequent nvm commands will fail
    # return 1
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
