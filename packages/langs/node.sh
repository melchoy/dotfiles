#!/bin/zsh

source ~/.dotfiles/common.sh

# Function to install the latest stable (LTS) version of Node.js
install_node() {
  export PROFILE=/dev/null # Disable automatically adding to .zshrc or .bashrc
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

  nvm install --lts
  nvm alias default lts/*
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
