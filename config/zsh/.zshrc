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

# === Functions ===
source "$DOTZSH/functions/dotfiles.zsh"
source "$DOTZSH/functions/utils.zsh"

# === Aliases ===
source "$DOTZSH/aliases/.aliases"

# === Custom / Local Configuration ===
[ -f "${HOME}/.zshrc-local" ] && source "${HOME}/.zshrc-local"

[ -f "${HOME}/.alias" ] && source "${HOME}/.alias"
[ -f "${HOME}/.alias-local" ] && source "${HOME}/.alias-local"

# === Dev Version & Package Managers ===
source "$DOTCONFIG/node/nvm.sh"
source "$DOTCONFIG/ruby/rbenv.sh"
