eval "$(/opt/homebrew/bin/brew shellenv)"

# Suppress Homebrew environment hints/warnings
export HOMEBREW_NO_ENV_HINTS=1

# === ENV VARS ===
export DOTHOME="$HOME/.dotfiles"
export DOTCONFIG="$DOTHOME/config"
export DOTZSH="$DOTCONFIG/zsh"

export VAULTHOME="$HOME/.vault"

export GOPATH="$HOME/.go"

export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH="$GOPATH:$PATH"
export PATH="$HOME/.bin:$DOTHOME/bin:$PATH"

# Load Additional Local Variables
[ -f "$HOME/.env" ] && source "$HOME/.env"

# === Dev Version & Package Managers ===
source "$DOTCONFIG/node/nvm.sh"
source "$DOTCONFIG/ruby/rbenv.sh"
