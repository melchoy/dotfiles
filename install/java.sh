#!/bin/zsh

source ~/.dotfiles/common.sh

# Function to install the latest stable version of Java using SDKMAN!
install_java() {
  export SDKMAN_DIR="$HOME/.sdkman"

  # Install SDKMAN! if not already installed
  if [ ! -d "$SDKMAN_DIR" ]; then
    echo "Installing SDKMAN!..."
    curl -s "https://get.sdkman.io" | bash

    if [ ! -d "$SDKMAN_DIR" ]; then
      echo "Error: SDKMAN! installation failed."
      return 1
    fi
    echo "SDKMAN! installed successfully."
  else
    echo "SDKMAN! is already installed."
  fi

  # Source SDKMAN! to make it available in the current script session
  if [ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
    echo "SDKMAN! loaded."
  else
    echo "Error: sdkman-init.sh not found. Please check SDKMAN! installation."
    return 1
  fi

  # Update SDKMAN! to get the latest version list
  echo "Updating SDKMAN!..."
  sdk selfupdate force

  # Install the latest LTS version of Java (Temurin is the open-source JDK from Adoptium)
  echo "Installing latest LTS Java version (Temurin)..."
  sdk install java

  # Set the installed version as default
  echo "Setting default Java version..."
  sdk default java $(sdk current java | awk '{print $4}')

  # Verify installation
  echo "Java installation complete. Versions:"
  java -version
  javac -version

  # List installed Java versions
  echo "Installed Java versions:"
  sdk list java | grep installed
}

# Function to uninstall Java and SDKMAN!
uninstall_java() {
  export SDKMAN_DIR="$HOME/.sdkman"

  if [ -d "$SDKMAN_DIR" ]; then
    echo "Removing SDKMAN! and all installed Java versions..."
    rm -rf "$SDKMAN_DIR"
    echo "Java and SDKMAN! uninstalled successfully."
    echo "Note: You may want to remove the following lines from your shell configuration file if present:"
    echo 'export SDKMAN_DIR="$HOME/.sdkman"'
    echo '[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"'
  else
    echo "SDKMAN! is not installed."
  fi
}

# Parse command line arguments
if [[ "$1" == "--uninstall" ]]; then
  uninstall_java
else
  install_java
fi

