#!/bin/zsh

# Tmux aliases for easy session management
alias tl='tmux list-sessions'
alias ta='tmux attach-session -t'
alias tn='tmux new-session -s'
alias tk='tmux kill-session -t'
alias tka='tmux kill-session -a'  # Kill all sessions except current
alias tr='tmux source-file ~/.dotfiles/config/tmux/tmux.conf \; display "Config reloaded 🚀"'  # Reload tmux config

# Quick session switcher
t() {
    if [ -z "$1" ]; then
        # No argument: attach to 'work' or create it with multiple windows
        if ! tmux has-session -t work 2>/dev/null; then
            # Create new session with multiple windows
            tmux new-session -d -s work -n code
            tmux new-window -t work -n server
            tmux new-window -t work -n docs
            tmux new-window -t work -n term
            tmux select-window -t work:code
        fi
        tmux attach-session -t work
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
