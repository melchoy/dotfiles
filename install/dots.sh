#!/bin/zsh

source ~/.dotfiles/common.sh

SOURCE_DIR="$DOTMANGR_CONFIGS_DIR/dots"

echo "Symlinking dotfiles..."
files_list=$(get_files_in_directory "$SOURCE_DIR")

for file in $files_list; do
  if [ -f "$file" ]; then
    base_file=$(basename "$file")
    symlink_dotfile "$file" "$HOME/$base_file"
  fi
done
