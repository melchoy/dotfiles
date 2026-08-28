#!/bin/bash

source ~/.dotfiles/common.sh

AGENTS_REPO_URL="melchoy/agents.git"
AGENTS_LOCAL_PATH="$HOME/.agents"

clone_or_update_repo "$AGENTS_REPO_URL" "$AGENTS_LOCAL_PATH" \
  --clone_cmd "github_auth_and_clone $AGENTS_REPO_URL $AGENTS_LOCAL_PATH"

if [ -x "$AGENTS_LOCAL_PATH/install.sh" ]; then
  "$AGENTS_LOCAL_PATH/install.sh"
fi
