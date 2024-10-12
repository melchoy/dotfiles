# Automatically use the Node.js version specified in .nvmrc
autoload -U add-zsh-hook

load-nvmrc() {
  if ! command -v nvm &> /dev/null; then
    echo "NVM is not installed. Please install NVM first."
    return
  fi

  local node_version="$(nvm version)"
  if [ -f .nvmrc ]; then
    local nvmrc_node_version=$(cat .nvmrc)
    if [ "$nvmrc_node_version" = "lts/*" ]; then
      nvm use --lts
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "none" ]; then
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc
