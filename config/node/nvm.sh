
if [ -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  
  # Load NVM immediately so node binaries are available in PATH
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  
  # Load bash completion only in interactive shells (optional, for performance)
  if [[ -o interactive ]]; then
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  fi

  # Load nvmrc and pnpm configs
  source "$DOTCONFIG/node/nvmrc.sh"
  source "$DOTCONFIG/node/pnpm.sh"
fi
