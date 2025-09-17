## Lazygit aliases and helpers

# Fast launch
alias lg='lazygit'

# Launch only when inside a git repo
lgg() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    lazygit
  else
    echo "Not in a git repository"
    return 1
  fi
}

# Launch lazygit for a given directory (defaults to current directory)
lgp() {
  if [ -z "$1" ]; then
    lazygit
  else
    lazygit --path "$1"
  fi
}

# Launch with explicit config file
alias lgr='lazygit --use-config-file=$HOME/.config/lazygit/config.yml'

# Open focused on a file (uses --filter if supported by current lazygit)
lgfile() {
  if [ -z "$1" ]; then
    echo "Usage: lgfile <filename>"
    return 1
  fi

  if lazygit --help 2>&1 | grep -q "--filter"; then
    lazygit --filter "$1"
  else
    echo "Your lazygit version does not support --filter. Opening normally."
    lazygit
  fi
}


