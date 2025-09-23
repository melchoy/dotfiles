# Add rbenv to PATH for access to the rbenv command-line utility
export PATH="$HOME/.rbenv/bin:$PATH"

# Load rbenv automatically if it is installed
if command -v rbenv &> /dev/null; then
  # Only initialize rbenv in interactive shells to avoid VS Code startup delays
  if [[ $- == *i* ]] && [[ -t 0 ]]; then
    eval "$(rbenv init -)"
  else
    # Lazy load for non-interactive environments (like VS Code shell resolution)
    rbenv() {
      unset -f rbenv
      eval "$(command rbenv init -)"
      rbenv "$@"
    }
  fi

  source "$DOTCONFIG/ruby/ruby-version.sh"
fi
