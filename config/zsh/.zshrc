## Cursor Agent: avoid replacing shell with recorder in nested terminals
if [ -n "$TMUX" ] || [ -n "$NVIM" ]; then
  export CURSOR_RECORD_SESSION=1
fi

# Detect interactive and IDE shells early
IS_INTERACTIVE=0
case $- in *i*) IS_INTERACTIVE=1 ;; esac

IS_IDE_SHELL=0
[[ "$TERM_PROGRAM" == "vscode" || -n "$VSCODE_PID" || -n "$VSCODE_IPC_HOOK" ]] && IS_IDE_SHELL=1

# Auto-load colors only for interactive shells (saves resolver time)
if [[ $IS_INTERACTIVE -eq 1 ]]; then
  autoload -Uz colors && colors
fi
# Optional one-shot profiler: run `ZSH_PROFILE=1 zsh -i -c exit` and view /tmp/zsh_profile.$$.txt
if [[ -n "$ZSH_PROFILE" ]]; then
  zmodload zsh/zprof
  TRAPEXIT() {
    zprof > /tmp/zsh_profile.$$.txt
  }
fi

# Provide add-zsh-hook once here to avoid repeated autoloads in scripts
autoload -U add-zsh-hook

#Globally bypass Starship (set to 0 or unset to re-enable)
export STARSHIP_BYPASS=0

# Only load cursor-agent in interactive shells
if [[ $IS_INTERACTIVE -eq 1 ]] && [[ "$TERM" != "dumb" ]] && [[ -x ~/.local/bin/cursor-agent ]]; then
  eval "$(~/.local/bin/cursor-agent shell-integration zsh)"
fi

# === Starship Prompt ===
# Only initialize starship in interactive shells with proper terminal support
# Allow bypass via STARSHIP_BYPASS=1 for performance testing (0 or unset enables)
if command -v starship > /dev/null && [[ "$STARSHIP_BYPASS" != "1" ]] && [[ $IS_INTERACTIVE -eq 1 ]] && [[ "$TERM" != "dumb" ]]; then
	# Choose config based on tmux presence (improved detection)
	if [ -n "$TMUX" ] && [ "$TERM_PROGRAM" != "vscode" ] && [ -z "$INTELLIJ_ENVIRONMENT_READER" ]; then
		# Inside tmux - use minimal config
		export STARSHIP_CONFIG="$HOME/.config/starship-tmux.toml"
	else
		# Outside tmux or in IDE - use full config
		export STARSHIP_CONFIG="$HOME/.config/starship.toml"
	fi
	export STARSHIP_LOG=error
	export STARSHIP_TIMEOUT=600
	eval "$(starship init zsh)"
fi

# === ENV VARS ===
export EDITOR=nvim
# Do not force TERM inside tmux/IDE terminals; let parent set capabilities
if [ -z "$TMUX" ] && [ -z "$NVIM" ]; then
  export TERM=xterm-256color
fi

# Interactive shell keybindings (vi mode)
# Only set up ZLE keybindings in interactive terminals with proper terminal support
if [[ -o interactive ]] && [[ "$TERM" != "dumb" ]] && [[ -n "$ZLE_LOADED" || -o zle ]]; then
  # Insert literal newline (for Shift+Enter mapping)
  agent-insert-newline() { LBUFFER+=$'\n'; zle redisplay }
  zle -N agent-insert-newline
  # Bind CSI-u sequence for Shift+Enter if terminal sends it; provide Ctrl+O fallback
  bindkey -M viins '\e[13;2u' agent-insert-newline
  bindkey -M viins '^O' agent-insert-newline
  # Ensure Ctrl+L clears screen in vi insert and command modes
  bindkey -M viins '^L' clear-screen
  bindkey -M vicmd '^L' clear-screen
fi

# Use current Neovim via nvr when available; otherwise launch new nvim
if command -v nvr >/dev/null 2>&1; then
  export GIT_EDITOR="bash -lc 'nvr --remote-wait \"$@\" || nvim \"$@\"'"
else
  export GIT_EDITOR='nvim'
fi

# === Plugin Initialization (interactive only) ===
if command -v fzf > /dev/null && [[ $IS_INTERACTIVE -eq 1 ]]; then
  # Prefer static sourcing (faster than process substitution)
  [[ -r /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  [[ -r /opt/homebrew/opt/fzf/shell/completion.zsh   ]] && source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

# === Colorize Directory Listings (interactive only) ===
if [[ $IS_INTERACTIVE -eq 1 ]]; then
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

# Local env shell scripts only in interactive shells
if [[ $IS_INTERACTIVE -eq 1 ]]; then
  [ -f "$HOME/.env.sh" ] && source "$HOME/.env.sh"
  [ -f "$HOME/.env.local.sh" ] && source "$HOME/.env.local.sh"
fi

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

