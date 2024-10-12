autoload -U add-zsh-hook

load-nvmrc() {
  if ! command -v nvm &> /dev/null; then
    echo "NVM is not installed. Please install NVM first."
    return
  fi

  local node_version="$(nvm version)"
  if [ -f .nvmrc ]; then
    local nvmrc_node_version=$(cat .nvmrc)
    if [ "$nvmrc_node_version" != "$node_version" ]; then
      if ! nvm ls "$nvmrc_node_version" &> /dev/null; then
        echo "Node.js version $nvmrc_node_version is not installed."
        echo -n "Would you like to install it now? (y/N) "
        read response
        if [[ "$response" =~ ^[Yy]$ ]]; then
          nvm install "$nvmrc_node_version"
        else
          echo "Node.js version $nvmrc_node_version is not installed."
        fi
      else
        nvm use "$nvmrc_node_version"
      fi
    fi
  elif [ "$node_version" != "none" ]; then
    nvm use default &> /dev/null
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc
