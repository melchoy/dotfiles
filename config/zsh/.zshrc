# Auto-load colors for zsh
autoload -Uz colors && colors

# === Starship Prompt ===
if command -v starship > /dev/null; then
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

# === Functions ===
source "$DOTZSH/functions/.functions.sh"

# === Aliases ===
source "$DOTZSH/aliases/.aliases.sh"
source "$DOTZSH/aliases/gcp.sh"

# === Custom / Local Configuration ===
[ -f "${HOME}/.zshrc-local" ] && source "${HOME}/.zshrc-local"

[ -f "${HOME}/.alias" ] && source "${HOME}/.alias"
[ -f "${HOME}/.alias-local" ] && source "${HOME}/.alias-local"
