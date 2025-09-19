#!/bin/bash
set -e

echo "=== LazyGit + Neovim Remote Verification ==="
echo

echo "1) Dependencies"
for cmd in nvim nvr lazygit; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf "  - %-8s: OK (%s)\n" "$cmd" "$( $cmd --version 2>/dev/null | head -1 )"
  else
    printf "  - %-8s: MISSING\n" "$cmd"
  fi
done

echo
echo "2) Neovim server status"
if command -v nvr >/dev/null 2>&1; then
  servers=$(nvr --serverlist 2>/dev/null || true)
  if [ -n "$servers" ]; then
    echo "$servers" | sed 's/^/  - /'
  else
    echo "  No servers (start nvim to test)"
  fi
else
  echo "  nvr not installed"
fi

echo
LG_CFG="${XDG_CONFIG_HOME:-$HOME/.config}/lazygit/config.yml"
echo "3) LazyGit config: $LG_CFG"
if [ -f "$LG_CFG" ]; then
  if grep -q 'nvr --remote-wait' "$LG_CFG"; then
    echo "  nvr integration: OK"
  else
    echo "  nvr integration: NOT FOUND"
  fi
else
  echo "  Config not found"
fi

cat <<'EOF'

4) Manual tests:
  A) With Neovim running:
     :echo v:servername  (non-empty)
     lazygit → open file → opens in current nvim at target line
     lazygit → commit → commit buffer in nvim; closing completes commit

  B) With no Neovim running:
     lazygit → open/commit → launches a new nvim
EOF

echo
echo "5) Environment"
echo "  GIT_EDITOR: ${GIT_EDITOR:-<not set>}"
