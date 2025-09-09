#!/usr/bin/env bash
set -euo pipefail

# Simple log helpers
info()  { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
warn()  { printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }
error() { printf "\033[1;31m[ERR ]\033[0m %s\n" "$*" >&2; }

# symlink with backup
link_file() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ "$(readlink "$dest" 2>/dev/null)" == "$src" ]]; then
      info "Already linked: $dest"
      return
    fi
    local backup="${dest}.bak.$(date +%s)"
    mv "$dest" "$backup"
    info "Backed up existing to $backup"
  fi
  ln -s "$src" "$dest"
  info "Linked $dest -> $src"
}

# detect OS
detect_os() {
  case "$(uname -s)" in
    Darwin) echo "mac";;
    Linux)  echo "linux";;
    *)      echo "unknown";;
  esac
}
