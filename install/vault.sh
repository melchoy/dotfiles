#!/bin/bash

source ~/.dotfiles/common.sh

install_or_update_packages ansible gh

VAULT_REPO_URL="melchoy/vault.git"
VAULT_LOCAL_PATH="$HOME/.vault"

clone_or_update_repo "$VAULT_REPO_URL" "$VAULT_LOCAL_PATH" \
  --clone_cmd "github_auth_and_clone $VAULT_REPO_URL $VAULT_LOCAL_PATH"

sh "$HOME/.vault/init"
