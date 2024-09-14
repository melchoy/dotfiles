#!/bin/zsh

source ~/.dotfiles/common.sh

install_dotfiles() {
	find "$DOT_SOURCE_BASE_DIR" -mindepth 1 | while read source_file; do
		local filename=$(basename "$source_file")
		local target_file="$HOME/$filename"
		create_dotfile_symlink $source_file $target_file
	done
}

create_dotfile_symlink() {
	local source_file="$1"
	local target_file="${2:-$HOME/$(basename $source_file)}"

	if [ ! -e "$target_file" ]; then
  	ln -s "$source_file" "$target_file"
	fi

}

uninstall_dotfiles() {
	echo "Unlinking all symlinks pointing to $DOT_SOURCE_BASE_DIR..."
	find "$HOME" -maxdepth 1 -type l | while read symlink; do
		local linked_source=$(readlink "$symlink")
		if [[ "$linked_source" == "$DOT_SOURCE_BASE_DIR/"* ]]; then
			echo "Removing symlink: $symlink -> $linked_source"
			rm $symlink
		fi
	done
}

if [ "$1" == "--uninstall" ]; then
	uninstall_dotfiles
else
	install_dotfiles
fi

