export ZSH="$HOME/.oh-my-zsh"

# Oh My Zsh Settings
DEFAULT_USER="$USER"
ZSH_THEME="melzz"
ZSH_CUSTOM="$DOTFILES/zsh/ohmyzsh"
plugins=(git)
zstyle ':omz:update' mode reminder
source $ZSH/oh-my-zsh.sh

# Auto-load colors for zsh
autoload -Uz colors && colors

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='vim'
else
	export EDITOR='nvim'
fi

[ -f "$DOTFILES/zsh/aliases.sh" ] && source "$DOTFILES/zsh/aliases.sh"

# zsh
if command -v fzf > /dev/null; then
	source <(fzf --zsh)
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# place this after nvm initialization!
# TODO: Look at the standard oh-my-zsh plugin for this
#autoload -U add-zsh-hook
#load-nvmrc() {
#	# Check if nvm is installed
#	if ! command -v nvm > /dev/null 2>&1; then
#		return
#	fi
#
#	local node_version="$(nvm version)"
#	local nvmrc_path="$(nvm_find_nvmrc)"
#
#	if [ -n "$nvmrc_path" ]; then
#		local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
#
#		if [ "$nvmrc_node_version" = "N/A" ]; then
#			nvm install
#		elif [ "$nvmrc_node_version" != "$node_version" ]; then
#			nvm use
#		fi
#	elif [ "$node_version" != "$(nvm version default)" ]; then
#		nvm use default > /dev/null 2>&1
#	fi
#}
#add-zsh-hook chpwd load-nvmrc
#load-nvmrc

# iTerm2 / TODO: Check if still used
if [ -f "${HOME}/.iterm2_shell_integration.zsh" ]; then
	source "${HOME}/.iterm2_shell_integration.zsh"
fi

nf() {
	if [[ "$1" == */* ]]; then
		mkdir -p "$(dirname "$1")" && touch "$1"
	else
		touch "$1"
	fi
}

# pnpm
export PNPM_HOME="/Users/mel/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
