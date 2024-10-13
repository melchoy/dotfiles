update_dotfiles() {
	cd "$DOTFHOME" && git pull
	git submodule update --init --recursive
}
