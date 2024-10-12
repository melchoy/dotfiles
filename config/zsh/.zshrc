# Auto-load colors for zsh
autoload -Uz colors && colors

# === Starship Prompt ===
# check if starship is installed
if command -v starship > /dev/null; then
	eval "$(starship init zsh)"
fi

# === Custom Functions ===
# Function to create new files and directories as needed
nf() {
	if [[ "$1" == */* ]]; then
		mkdir -p "$(dirname "$1")" && touch "$1"
	else
		touch "$1"
	fi
}

# === Conditional Settings ===
# Preferred Editor
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='vim'
else
	export EDITOR='nvim'
fi

# === Plugin Initialization ===
# fzf (if available)
if command -v fzf > /dev/null; then
	source <(fzf --zsh)
fi

# === Dev Version & Package Managers ===
source "$DOTFCONFIG/node/nvm.sh"
source "$DOTFCONFIG/ruby/rbenv.sh"

# === Custom / Local Configuration ===
# Load local only zshrc if it exists
[ -f "${HOME}/.zshrc-local" ] && source "${HOME}/.zshrc-local"

# === Custom Aliases ===
# Load custom aliases (ensure the file exists)
source "$DOTFCONFIG/zsh/.aliases"
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"
[ -f "$DOTFCONFIG/zsh/.aliases" ] && source "$DOTFCONFIG/zsh/.aliases"
[ -f "$HOME/.aliases-local" ] && source "$HOME/.aliases-local"

# === Update Dotfiles ===
update_dotfiles() {
	cd "$DOTFHOME" && git pull
	git submodule update --init --recursive
}
