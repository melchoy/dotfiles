#!/bin/zsh

# Tmux aliases for easy session management
alias tl='tmux list-sessions'
alias ta='tmux attach-session -t'
alias tn='tmux new-session -s'
alias tk='tmux kill-session -t'
alias tka='tmux kill-session -a'  # Kill all sessions except current

# Quick session switcher
t() {
    if [ -z "$1" ]; then
        # No argument: attach to 'main' or create it
        tmux new-session -A -s main
    else
        # With argument: attach to named session or create it
        tmux new-session -A -s "$1"
    fi
}

# Interactive session switcher (requires fzf)
ts() {
    if [ -z "$TMUX" ]; then
        # Not in tmux - show sessions to attach to
        local session
        session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --prompt="Attach to session> ")
        [ -n "$session" ] && tmux attach-session -t "$session"
    else
        # Inside tmux - switch to another session
        local session
        session=$(tmux list-sessions -F "#{session_name}" | grep -v "^$(tmux display-message -p '#S')$" | fzf --prompt="Switch to session> ")
        [ -n "$session" ] && tmux switch-client -t "$session"
    fi
}
