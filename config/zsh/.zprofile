eval "$(/opt/homebrew/bin/brew shellenv)"

# Suppress Homebrew environment hints/warnings
export HOMEBREW_NO_ENV_HINTS=1

# === ENV VARS ===
export DOTHOME="$HOME/.dotfiles"
export DOTCONFIG="$DOTHOME/config"
export DOTZSH="$DOTCONFIG/zsh"

export XDG_CONFIG_HOME="$HOME/.config"
export VAULTHOME="$HOME/.vault"
export GOPATH="$HOME/.go"

# Add system and package paths first
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"

export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Personal bins take highest precedence (added last = found first)
export PATH="$HOME/.bin:$DOTHOME/bin:$PATH"


# Load Additional Local Variables
[ -f "$HOME/.env" ] && source "$HOME/.env"
[ -f "$HOME/.env.local" ] && source "$HOME/.env.local"

[ -f "$HOME/.env.sh" ] && source "$HOME/.env.sh"
[ -f "$HOME/.env.local.sh" ] && source "$HOME/.env.local.sh"

# === Dev Version & Package Managers ===
source "$DOTCONFIG/node/nvm.sh"
source "$DOTCONFIG/ruby/rbenv.sh"
