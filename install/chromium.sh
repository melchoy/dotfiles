#!/bin/bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  echo "Usage: $0 [--force] [--uninstall]"
  echo "  --force      Force reinstall even if up to date"
  echo "  --uninstall  Remove Chromium and all related files"
  exit 1
}

detect_and_route() {
  if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    usage
  fi

  # Export environment variables for Python scripts
  export CHROMIUM_CONFIG_DIR="${CHROMIUM_CONFIG_DIR:-$HOME/.dotfiles/config/chromium}"
  export FFMPEG_AUTO_VER="${FFMPEG_AUTO_VER:-0.87.0}"

  local os_type
  os_type=$(uname -s | tr '[:upper:]' '[:lower:]')

  case "$os_type" in
    darwin)
      echo "Detected macOS"
      exec python3 "$SCRIPT_DIR/mac/chromium.py" "$@"
      ;;
    linux)
      if [[ ! -f /etc/os-release ]]; then
        echo "Error: /etc/os-release not found" >&2
        exit 1
      fi

      source /etc/os-release
      if [[ "$ID" == "ubuntu" ]] || [[ "${ID_LIKE:-}" == *"debian"* ]]; then
        echo "Detected Ubuntu/Debian"
        exec python3 "$SCRIPT_DIR/ubuntu/chromium.py" "$@"
      else
        echo "Error: Unsupported Linux distribution: $ID" >&2
        echo "Only Ubuntu and Debian-based distributions are supported" >&2
        exit 1
      fi
      ;;
    *)
      echo "Error: Unsupported operating system: $os_type" >&2
      echo "Supported: macOS (darwin), Ubuntu/Debian (linux)" >&2
      exit 1
      ;;
  esac
}

detect_and_route "$@"
