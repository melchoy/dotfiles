# Add rbenv to PATH for access to the rbenv command-line utility
export PATH="$HOME/.rbenv/bin:$PATH"

# Load rbenv automatically if it is installed
if command -v rbenv &> /dev/null; then
  eval "$(rbenv init -)"

	source "$DOTCONFIG/ruby/ruby-version.sh"
fi
