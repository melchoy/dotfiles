#!/bin/bash

source ~/.dotfiles/common.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sh "$SCRIPT_DIR/node.sh"
sh "$SCRIPT_DIR/ruby.sh"
sh "$SCRIPT_DIR/golang.sh"
