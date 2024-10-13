# Auto-load colors for zsh
autoload -Uz colors && colors

# === Starship Prompt ===
# check if starship is installed
if command -v starship > /dev/null; then
	eval "$(starship init zsh)"
fi

# === ENV VARS ===
# Preferred Editor
export EDITOR="nvim"

# === Plugin Initialization ===
# fzf (if available)
if command -v fzf > /dev/null; then
	source <(fzf --zsh)
fi

# === Colorize Directory Listings ===
# Load dircolors if available
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

# === Custom / Local Configuration ===
[ -f "${HOME}/.zshrc-local" ] && source "${HOME}/.zshrc-local"

[ -f "${HOME}/.alias" ] && source "${HOME}/.alias"
[ -f "${HOME}/.alias-local" ] && source "${HOME}/.alias-local"

# === Dev Version & Package Managers ===
source "$DOTCONFIG/node/nvm.sh"
source "$DOTCONFIG/ruby/rbenv.sh"
