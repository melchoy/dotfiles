#!/bin/zsh
source ~/.dotfiles/common.sh

install_rbenv() {
  if ! command -v rbenv &> /dev/null; then
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    cd ~/.rbenv && src/configure && make -C src
    echo "rbenv installed. Please add the following lines to your shell configuration file (e.g., ~/.zshrc):"
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"'
    echo 'eval "$(rbenv init -)"'
    # Source rbenv initialization for the current shell session
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
  fi

  if [ ! -d "$(rbenv root)/plugins/ruby-build" ]; then
    git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)/plugins/ruby-build"
  fi

  latest_ruby=$(rbenv install -l | grep -v - | tail -1)
  if rbenv versions | grep -q "$latest_ruby"; then
		echo "Ruby $latest_ruby is already installed."
		return
	else
		echo "Installing Ruby $latest_ruby..."
		rbenv install "$latest_ruby"
		rbenv global "$latest_ruby"
	fi

  ruby -v
  gem -v
}

uninstall_rbenv() {
  rm -rf ~/.rbenv
  echo "rbenv uninstalled. Please remove the following lines from your shell configuration file (e.g., ~/.zshrc):"
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"'
  echo 'eval "$(rbenv init -)"'
}

if [[ "$1" == "--uninstall" ]]; then
  uninstall_rbenv
else
  install_rbenv
fi
