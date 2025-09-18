eval "$(~/.local/bin/cursor-agent shell-integration zsh)"
# Auto-load colors for zsh
autoload -Uz colors && colors

# === Starship Prompt ===
if command -v starship > /dev/null; then
	# Choose config based on tmux presence (improved detection)
	if [ -n "$TMUX" ] && [ "$TERM_PROGRAM" != "vscode" ] && [ -z "$INTELLIJ_ENVIRONMENT_READER" ]; then
		# Inside tmux - use minimal config
		export STARSHIP_CONFIG="$HOME/.config/starship-tmux.toml"
	else
		# Outside tmux or in IDE - use full config
		export STARSHIP_CONFIG="$HOME/.config/starship.toml"
	fi
	eval "$(starship init zsh)"
fi

# === ENV VARS ===
export EDITOR=nvim
export TERM=xterm-256color

# === Plugin Initialization ===
if command -v fzf > /dev/null; then
	source <(fzf --zsh)
fi

# === Colorize Directory Listings ===
if [[ "$OSTYPE" == "darwin"* ]] && command -v gdircolors > /dev/null 2>&1; then
  alias dircolors='gdircolors'
fi

if command -v dircolors > /dev/null 2>&1; then
  if [ -f ~/.dircolors ]; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
fi

# === GO STUFFS ===
export GOBIN=$HOME/.go/bin
export PATH=$PATH:$GOBIN
export AIR_CONFIG=air.toml

# === Functions ===
source "$DOTZSH/functions/.functions.sh"

# === Aliases ===
source "$DOTZSH/aliases/.aliases.sh"
source "$DOTZSH/aliases/gcp.sh"

# === Custom / Local Configuration ===
[ -f "${HOME}/.zshrc-local" ] && source "${HOME}/.zshrc-local"

[ -f "${HOME}/.alias" ] && source "${HOME}/.alias"
[ -f "${HOME}/.alias-local" ] && source "${HOME}/.alias-local"

[ -f "$HOME/.env.sh" ] && source "$HOME/.env.sh"
[ -f "$HOME/.env.local.sh" ] && source "$HOME/.env.local.sh"

# pnpm
export PNPM_HOME="/Users/mel/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
 esac
# pnpm end

# === Auto-start tmux ===
# DISABLED FOR NOW
# Behavior:
# - Default: start tmux in all terminals except VSCode/Cursor (TERM_PROGRAM=vscode)
# - Global disable: set TMUX_EVERYWHERE=0 in ~/.zshrc-local
# - Per-shell disable: export DISABLE_TMUX_AUTOSTART=1
# TMUX_EVERYWHERE=${TMUX_EVERYWHERE:-1}

# if command -v tmux &> /dev/null && \
#    [ -n "$PS1" ] && \
#    [ -z "$TMUX" ] && \
#    [ -z "$DISABLE_TMUX_AUTOSTART" ] && \
#    [ -z "$INTELLIJ_ENVIRONMENT_READER" ] && \
#    [ "$TMUX_EVERYWHERE" = "1" ]; then
#   if [ "$TERM_PROGRAM" != "vscode" ]; then
#     exec tmux new-session -A -s work
#   fi
# fi
