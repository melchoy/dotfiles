#!/bin/bash

source ~/.dotfiles/common.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sh "$SCRIPT_DIR/helix.sh" "$@"
sh "$SCRIPT_DIR/dbmate.sh"
sh "$SCRIPT_DIR/ngrok.sh"
