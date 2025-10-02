find-ruby-version-file() {
  local dir="$PWD"
  while [ "$dir" != "/" ]; do
    if [ -f "$dir/.ruby-version" ]; then
      echo "$dir/.ruby-version"
      return
    fi
    dir=$(dirname "$dir")
  done
}

load-ruby-version() {
  # Ensure rbenv is loaded before using it
  if ! command -v rbenv &> /dev/null; then
    echo "rbenv is not installed. Please install rbenv first."
    return
  fi

  local ruby_version_file=$(find-ruby-version-file)
  if [ -n "$ruby_version_file" ]; then
    local ruby_version=$(cat "$ruby_version_file")
    # Avoid auto-install during shell ops; only switch if installed
    if rbenv versions --bare | grep -q "^${ruby_version}$"; then
      rbenv shell "$ruby_version"
    fi
  else
    rbenv shell --unset
  fi
}

autoload -U add-zsh-hook
# Only hook for interactive shells; skip initial run
if [[ $- == *i* ]]; then
  add-zsh-hook chpwd load-ruby-version
fi
