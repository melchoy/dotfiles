eval "$(/opt/homebrew/bin/brew shellenv)"

export DOTHOME="$HOME/.dotfiles"
export DOTFILES="$DOTHOME/configs"

export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.bin:$DOTFILES/bin:$PATH"

# Suppress Homebrew environment hints/warnings
export HOMEBREW_NO_ENV_HINTS=1

# Load Environment Variables
[ -f "$HOME/.env_vars" ] && source "$HOME/.env_vars"

# Load PNPM Integration
[ -f "$HOME/$DOTFILES/zsh/pnpm.sh" ] && . "$HOME/$DOTFILES/zsh/pnpm.sh"

# === Custom / Local Configuration ===
# Load local only zprofile if it exists
[ -f "$HOME/.zprofile-local" ] && source "$HOME/.zprofile-local"
