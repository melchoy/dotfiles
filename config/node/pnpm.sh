# CHECK OS FOR PNPM PATH
if [[ "$OSTYPE" == "darwin"* ]]; then
  PNPM_HOME="/Users/mel/Library/pnpm"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  PNPM_HOME="$HOME/.local/share/pnpm"
fi

# Add PNPM_HOME to PATH if pnpm is installed
if [ -d "$PNPM_HOME" ] && [ -f "$PNPM_HOME/pnpm" ]; then
  case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
  esac
fi
