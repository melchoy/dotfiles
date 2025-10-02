# Cache brew shellenv to avoid spawning brew on every shell init
BREW_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
BREW_ENV_CACHE="$BREW_CACHE_DIR/brew_shellenv"
mkdir -p "$BREW_CACHE_DIR"

# Refresh cache once a day (or if missing)
if [[ ! -f "$BREW_ENV_CACHE" || $(/bin/date -r "$BREW_ENV_CACHE" +%s) -lt $(( $(date +%s) - 86400 )) ]]; then
  /opt/homebrew/bin/brew shellenv > "$BREW_ENV_CACHE" 2>/dev/null || true
fi
[[ -r "$BREW_ENV_CACHE" ]] && source "$BREW_ENV_CACHE"

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

# macOS-specific bins (only on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="$DOTHOME/bin/mac:$PATH"
fi


# Detect interactive and IDE shells (resolver runs non-interactive)
IS_INTERACTIVE=0
case $- in *i*) IS_INTERACTIVE=1 ;; esac
IS_IDE_SHELL=0
[[ "$TERM_PROGRAM" == "vscode" || -n "$VSCODE_PID" || -n "$VSCODE_IPC_HOOK" ]] && IS_IDE_SHELL=1

# Load minimal env files always (key=value)
[ -f "$HOME/.env" ] && source "$HOME/.env"
[ -f "$HOME/.env.local" ] && source "$HOME/.env.local"

# Load shell scripts and tool managers only for interactive shells
if [[ $IS_INTERACTIVE -eq 1 ]]; then
  [ -f "$HOME/.env.sh" ] && source "$HOME/.env.sh"
  [ -f "$HOME/.env.local.sh" ] && source "$HOME/.env.local.sh"

  # === Dev Version & Package Managers ===
  source "$DOTCONFIG/node/nvm.sh"
  source "$DOTCONFIG/ruby/rbenv.sh"
fi
