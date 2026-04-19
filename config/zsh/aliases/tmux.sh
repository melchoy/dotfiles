#!/bin/zsh

# Tmux aliases for easy session management
alias tl='tmux list-sessions'
alias ta='tmux attach-session -t'
unalias tn 2>/dev/null
alias tk='tmux kill-session -t'
alias tka='tmux kill-session -a'  # Kill all sessions except current
alias tmuxreload='tmux source-file ~/.dotfiles/config/tmux/tmux.conf \; display "Config reloaded 🚀"'  # Reload tmux config

tn() {
    local session_name=""
    local start_path=""

    while [ $# -gt 0 ]; do
        case "$1" in
            -s)
                shift
                session_name="$1"
                ;;
            -c)
                shift
                start_path="$1"
                ;;
            *)
                if [ -z "$start_path" ]; then
                    start_path="$1"
                fi
                ;;
        esac
        shift
    done

    if [ -z "$session_name" ]; then
        echo "usage: tn -s <session-name> [path]"
        return 1
    fi

    if [ -n "$start_path" ]; then
        start_path="${~start_path}"
    fi

    if tmux has-session -t "$session_name" 2>/dev/null; then
        echo "Session '$session_name' already exists"
        return
    fi

    if [ -n "$start_path" ]; then
        tmux new-session -d -s "$session_name" -c "$start_path"
    else
        tmux new-session -d -s "$session_name"
    fi
}

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
        # With argument: attach to named session or create it, optionally at a path
        local session_name="$1"
        local start_path="$2"

        if [ -n "$start_path" ]; then
            start_path="${~start_path}"
        fi

        if ! tmux has-session -t "$session_name" 2>/dev/null; then
            if [ -n "$start_path" ]; then
                tn -s "$session_name" "$start_path"
            else
                tn -s "$session_name"
            fi
        fi

        if [ -n "$TMUX" ]; then
            tmux switch-client -t "$session_name"
        else
            tmux attach-session -t "$session_name"
        fi
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
