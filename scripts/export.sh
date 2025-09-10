#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$REPO_ROOT/scripts/common.sh"

OS=$(detect_os)
info "Detected OS: $OS"

mkdir -p "$REPO_ROOT/dotfiles/zsh" "$REPO_ROOT/dotfiles/vim" "$REPO_ROOT/dotfiles/git" "$REPO_ROOT/vscode" "$REPO_ROOT/raycast" "$REPO_ROOT/dotfiles/atuin"

# --- ZSH / Oh My Zsh
if [[ -f "$HOME/.zshrc" ]]; then
  cp -f "$HOME/.zshrc" "$REPO_ROOT/dotfiles/zsh/.zshrc"
  info "Copied .zshrc"
fi
if [[ -f "$HOME/.zsh/aliases.zsh" ]]; then
  cp -f "$HOME/.zsh/aliases.zsh" "$REPO_ROOT/dotfiles/zsh/aliases.zsh"
fi
if [[ -f "$HOME/.zsh/functions.zsh" ]]; then
  cp -f "$HOME/.zsh/functions.zsh" "$REPO_ROOT/dotfiles/zsh/functions.zsh"
fi

# --- Powerlevel10k
if [[ -f "$HOME/.p10k.zsh" ]]; then
  cp -f "$HOME/.p10k.zsh" "$REPO_ROOT/dotfiles/zsh/.p10k.zsh"
  info "Copied .p10k.zsh"
fi

# --- Vim
if [[ -f "$HOME/.vimrc" ]]; then
  cp -f "$HOME/.vimrc" "$REPO_ROOT/dotfiles/vim/.vimrc"
fi

# --- Git
if [[ -f "$HOME/.gitconfig" ]]; then
  cp -f "$HOME/.gitconfig" "$REPO_ROOT/dotfiles/git/.gitconfig"
fi
if [[ -f "$HOME/.gitignore_global" ]]; then
  cp -f "$HOME/.gitignore_global" "$REPO_ROOT/dotfiles/git/.gitignore_global"
fi

# --- VSCode
VSC_USER_DIR=""
if [[ "$OS" == "mac" ]]; then
  VSC_USER_DIR="$HOME/Library/Application Support/Code/User"
elif [[ "$OS" == "linux" ]]; then
  VSC_USER_DIR="$HOME/.config/Code/User"
fi
if [[ -d "$VSC_USER_DIR" ]]; then
  if [[ -f "$VSC_USER_DIR/settings.json" ]]; then
    cp -f "$VSC_USER_DIR/settings.json" "$REPO_ROOT/vscode/settings.json"
  fi
  if [[ -f "$VSC_USER_DIR/keybindings.json" ]]; then
    cp -f "$VSC_USER_DIR/keybindings.json" "$REPO_ROOT/vscode/keybindings.json"
  fi
  if [[ -d "$VSC_USER_DIR/snippets" ]]; then
    rsync -a --delete "$VSC_USER_DIR/snippets/" "$REPO_ROOT/vscode/snippets/"
  fi
  # extensions list
  if command -v code >/dev/null 2>&1; then
    code --list-extensions | sort > "$REPO_ROOT/vscode/extensions.txt"
    info "Saved VSCode extensions list"
  else
    warn "VSCode 'code' CLI not found; skipping extensions list"
  fi
fi

# --- Atuin
if command -v atuin >/dev/null 2>&1; then
  if [[ -f "$HOME/.config/atuin/config.toml" ]]; then
    cp -f "$HOME/.config/atuin/config.toml" "$REPO_ROOT/dotfiles/atuin/config.toml"
  fi
  # NOTE: history DB is sensitive / large; we do NOT copy it by default.
  info "Copied Atuin config.toml (not the database)"
fi

# --- Homebrew dump (whatever you have now)
if command -v brew >/dev/null 2>&1; then
  brew bundle dump --file="$REPO_ROOT/Brewfile" --force
  info "Dumped Brewfile"
else
  warn "Homebrew not found; skipping Brewfile dump"
fi

# --- Raycast
# Export via Raycast UI: run "Export Settings & Data", then move the .rayconfig here:
warn "Raycast must be exported manually (Raycast → 'Export Settings & Data'); put the .rayconfig into $REPO_ROOT/raycast/raycast.rayconfig"

info "Export complete."
