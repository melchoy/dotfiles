#!/bin/bash

source ~/.dotfiles/macos/common.sh

set -e 

echo "Installing Vault"

# Vault setup
VAULT_REPO_URL="git@github.com:melchoy/vault.git"
VAULT_LOCAL_PATH="$HOME/.vault"
update_or_clone_repo "$VAULT_REPO_URL" "$VAULT_LOCAL_PATH" "" "git clone $VAULT_REPO_URL $VAULT_LOCAL_PATH"
sh $HOME/.vault/init
