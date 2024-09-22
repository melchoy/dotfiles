#!/bin/bash

source ~/.dotfiles/common.sh

KEEP_SOURCE=false
HELIX_SOURCE_DIR="$HOME/Work/helix"
HELIX_BINARY_INSTALL_DIR="$HOME/.bin"


for arg in "$@"; do
  case $arg in
    --keep-source)
      KEEP_SOURCE=true
      ;;
    *)
      ;;
  esac
done

if [ "$KEEP_SOURCE" = false ]; then
  HELIX_SOURCE_DIR="/tmp/helix"
fi

HELIX_BINARY_INSTALL_DIR="$HOME/.bin"

clone_or_update_repo "melchoy/helix" "$HELIX_SOURCE_DIR"

# Build go binary
echo "Building helix binary..."
cd "$HELIX_SOURCE_DIR"
go build -o "$HELIX_BINARY_INSTALL_DIR/helix"

if [ "$KEEP_SOURCE" = false ]; then
  echo "Cleaning up $HELIX_SOURCE_DIR..."
	rm -rf "$HELIX_SOURCE_DIR"
fi
