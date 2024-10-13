alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

if command -v gls > /dev/null 2>&1; then
  alias ls='gls --color=auto'
else
  alias ls='ls --color=auto'
fi

alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'
alias lsd='ls -l | grep "^d"'

