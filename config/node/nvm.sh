
if [ -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"

  # Lazy load NVM - only load when nvm command is used (speeds up shell startup)
  nvm() {
    unset -f nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm "$@"
  }

  # Load nvmrc and pnpm configs (these are fast)
  source "$DOTCONFIG/node/nvmrc.sh"
  source "$DOTCONFIG/node/pnpm.sh"
fi
