eval "$(/opt/homebrew/bin/brew shellenv)"

export DOTHOME="$HOME/.dotfiles"
export DOTFILES="$DOTHOME/configs"

export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.bin:$DOTFILES/bin:$PATH"

# Load Environment Variables
[ -f "$HOME/.env_vars" ] && source "$HOME/.env_vars"

# Load OrbStack command-line tools and integration
[ -f "$HOME/.orbstack/shell/init.zsh" ] && source "$HOME/.orbstack/shell/init.zsh"

# Load ASDF Integration
[ -f "$HOME/.asdf/asdf.sh" ] && . "$HOME/.asdf/asdf.sh"

# Load PNPM Integration
[ -f "$HOME/$DOTFILES/zsh/pnpm.sh" ] && . "$HOME/$DOTFILES/zsh/pnpm.sh"
