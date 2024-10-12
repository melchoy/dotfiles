load-ruby-version() {
  if ! command -v rbenv &> /dev/null; then
    echo "rbenv is not installed. Please install rbenv first."
    return
  fi

  if [ -f .ruby-version ]; then
    local ruby_version=$(cat .ruby-version)
    if ! rbenv versions --bare | grep -q "^${ruby_version}$"; then
      echo "Ruby version $ruby_version is not installed."
      echo -n "Would you like to install it now? (y/N) "
      read response
      if [[ "$response" =~ ^[Yy]$ ]]; then
        rbenv install "$ruby_version"
        rbenv global "$ruby_version"
        echo "Ruby version $ruby_version has been installed and set as global."
      else
        echo "Ruby version $ruby_version is not installed."
        echo "If you would like to run this project"
				echo "please install it using the following command:"
        echo "rbenv install $ruby_version"
      fi
    else
      rbenv global "$ruby_version"
      echo "Ruby version $ruby_version is already installed and set as global."
    fi
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd load-ruby-version
load-ruby-version
