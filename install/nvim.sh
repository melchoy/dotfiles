#!/bin/bash

source ~/.dotfiles/common.sh

if [[ "$PLATFORM_NAME" == "mac" ]]; then
  # Core deps
  install_or_update_packages ripgrep
  install_or_update_packages neovim
  # nvr from brew
  install_or_update_packages neovim-remote

elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
  # Core deps
  install_or_update_packages ripgrep
  install_or_update_packages neovim
  # nvr via pipx (preferred) or pip --user
  if ! command -v nvr >/dev/null 2>&1; then
    if command -v pipx >/dev/null 2>&1; then
      pipx install --include-deps neovim-remote || true
    else
      install_or_update_packages pipx || true
      if command -v pipx >/dev/null 2>&1; then
        pipx install --include-deps neovim-remote || true
      else
        python3 -m pip install --user --upgrade neovim-remote
      fi
    fi
  fi
fi

# Clone/update your Neovim config
clone_or_update_repo "melchoy/nvim" ~/.config/nvim
