autoload -U add-zsh-hook

load-nvmrc() {
  # Ensure NVM is loaded before using it
  if ! command -v nvm &> /dev/null; then
    # Try to load NVM if it exists but isn't loaded yet (lazy loading case)
    if [ -s "$NVM_DIR/nvm.sh" ]; then
      \. "$NVM_DIR/nvm.sh"
    else
      echo "NVM is not installed. Please install NVM first."
      return
    fi
  fi

  local node_version="$(nvm version)"
  if [ -f .nvmrc ]; then
    local nvmrc_node_version=$(cat .nvmrc)
    if [ "$nvmrc_node_version" != "$node_version" ]; then
      # NOTE: Auto-install was originally enabled here. Kept below as comments for easy re-enable.
      # if ! nvm ls "$nvmrc_node_version" &> /dev/null; then
      #   echo "🔧 Auto-installing Node.js $nvmrc_node_version..."
      #   nvm install "$nvmrc_node_version"
      #   echo "✅ Installed Node.js $nvmrc_node_version"
      # else
      #   nvm use "$nvmrc_node_version" &> /dev/null
      # fi

      # Current behavior: only switch if the requested version is already installed
      if nvm ls "$nvmrc_node_version" &> /dev/null; then
        nvm use "$nvmrc_node_version" &> /dev/null
      fi
    fi
  fi
}

add-zsh-hook chpwd load-nvmrc
