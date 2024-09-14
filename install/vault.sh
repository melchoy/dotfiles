#!/bin/bash

source ~/.dotfiles/common.sh

set -e

echo "Installing Vault..."

if ! is_command_installed "ansible"; then
	echo "Vault Requires Ansible!"
	install_or_update_package "ansible"
fi

VAULT_REPO_URL="git@github.com:melchoy/vault.git"
VAULT_LOCAL_PATH="$HOME/.vault"
clone_or_update_repo "$VAULT_REPO_URL" "$VAULT_LOCAL_PATH" "" "git clone $VAULT_REPO_URL $VAULT_LOCAL_PATH"
sh "$HOME/.vault/init"
