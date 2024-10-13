eval "$(/opt/homebrew/bin/brew shellenv)"

export DOTHOME="$HOME/.dotfiles"
export DOTCONFIG="$DOTHOME/config"
export DOTZSH="$DOTCONFIG/zsh"
export VAULTHOME="$HOME/.vault"

export GOPATH="$HOME/.go"

export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH="$GOPATH:$PATH"
export PATH="$HOME/.bin:$DOTHOME/bin:$PATH"

# Suppress Homebrew environment hints/warnings
export HOMEBREW_NO_ENV_HINTS=1

# Load Environment Variables
[ -f "$HOME/.env_vars" ] && source "$HOME/.env_vars"

# Load PNPM Integration
[ -f "$HOME/$DOTCONFIG/zsh/pnpm.sh" ] && . "$HOME/$DOTCONFIG/zsh/pnpm.sh"

# === Custom / Local Configuration ===
# Load local only zprofile if it exists
[ -f "$HOME/.zprofile-local" ] && source "$HOME/.zprofile-local"
