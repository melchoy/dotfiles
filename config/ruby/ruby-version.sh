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
  if ! command -v rbenv &> /dev/null; then
    echo "rbenv is not installed. Please install rbenv first."
    return
  fi

  local ruby_version_file=$(find-ruby-version-file)
  if [ -n "$ruby_version_file" ]; then
    local ruby_version=$(cat "$ruby_version_file")
    if ! rbenv versions --bare | grep -q "^${ruby_version}$"; then
      echo "Ruby version $ruby_version is not installed."
      echo -n "Would you like to install it now? (y/N) "
      read response
      if [[ "$response" =~ ^[Yy]$ ]]; then
        rbenv install "$ruby_version"
        rbenv shell "$ruby_version"
        echo "Now using ruby version to $ruby_version."
      else
        echo "Ruby version $ruby_version is not installed."
      fi
    else
      rbenv shell "$ruby_version"
      echo "Now using ruby version to $ruby_version."
    fi
  else
    rbenv shell --unset
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd load-ruby-version
load-ruby-version
