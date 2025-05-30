update_dotfiles() {
  local current_dir=$(pwd)

  cd "$DOTHOME" && git pull
  git submodule update --init --recursive

  if [[ " $* " == *" --update-packages "* ]]; then
    echo "Updating packages..."
    $DOTHOME/install.sh
  fi

  cd "$current_dir"
}

update_vault() {
	local current_dir=$(pwd)
	cd "$VAULTHOME" && git pull
	cd "$current_dir"
}
