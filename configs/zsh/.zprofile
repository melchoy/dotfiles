eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Enable ASDF
[ -f "$HOME/.asdf/asdf.sh" ] && . "$HOME/.asdf/asdf.sh"

# Enable PNPM
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS installation path
  PNPM_HOME="/Users/mel/Library/pnpm"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Ubuntu (or other Linux distros) installation path
  PNPM_HOME="$HOME/.local/share/pnpm"
fi

# Add PNPM_HOME to PATH if pnpm is installed
if [ -d "$PNPM_HOME" ] && [ -f "$PNPM_HOME/pnpm" ]; then
  case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
  esac
fi
