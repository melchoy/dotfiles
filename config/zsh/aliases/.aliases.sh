alias edit="vim"
alias evim="vim ~/.config/nvim"

alias copilot="gh copilot"
alias suggest="gh copilot suggest"

alias dev="./bin/dev"

alias py="python3"
alias python="python3"
alias pip="pip3"

alias reload="source ~/.zshrc"

# GitKraken alias on Mac - opens GitKraken if it exists
if [[ "$OSTYPE" == "darwin"* ]] && [[ -d "/Applications/GitKraken.app" ]]; then
    alias gitkraken="open -a GitKraken"
fi

# Cursor Agent CLI
if command -v cursor-agent >/dev/null 2>&1; then
  alias ca='cursor-agent'
fi

source $DOTZSH/aliases/dotfiles.sh
source $DOTZSH/aliases/directory.sh
source $DOTZSH/aliases/tmux.sh
source $DOTZSH/aliases/git.sh
