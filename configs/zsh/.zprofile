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

# Load OrbStack command-line tools and integration
[ -f "$HOME/.orbstack/shell/init.zsh" ] && source "$HOME/.orbstack/shell/init.zsh"

# Load ASDF Integration
[ -f "$HOME/.asdf/asdf.sh" ] && . "$HOME/.asdf/asdf.sh"

# Load PNPM Integration
[ -f "$HOME/$DOTFILES/zsh/pnpm.sh" ] && . "$HOME/$DOTFILES/zsh/pnpm.sh"

# Added by OrbStack: command-line tools and integration
# Comment this line if you don't want it to be added again.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
