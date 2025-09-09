#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$REPO_ROOT/scripts/common.sh"

[[ "$(uname -s)" != "Darwin" ]] && { error "This script is for macOS only"; exit 1; }

# Check dependencies
info "Checking system dependencies..."
if ! command -v curl >/dev/null 2>&1; then
  error "curl is required but not installed. Please install curl first."
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  error "git is required but not installed. Please install git first."
  exit 1
fi

# 1) Homebrew
if ! command -v brew >/dev/null 2>&1; then
  info "Installing Homebrew…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv)" || true
fi

# 2) Packages (apps + CLI)
if [[ -f "$REPO_ROOT/Brewfile" ]]; then
  info "Installing from Brewfile…"
  brew update
  brew tap homebrew/cask-fonts || true
  brew bundle --file="$REPO_ROOT/Brewfile"
else
  info "No Brewfile found; installing basics…"
  brew install git curl wget zsh pyenv nvm atuin
  brew install --cask iterm2 visual-studio-code docker postman slack firefox google-chrome spotify
fi

# Ensure Meslo Nerd Font installed
if ! ls ~/Library/Fonts/*MesloLGS* 2>/dev/null >/dev/null; then
  info "Installing Meslo Nerd Fonts..."
  if brew tap homebrew/cask-fonts && brew install --cask font-meslo-lg-nerd-font; then
    info "Meslo Nerd Font installed successfully"
  else
    warn "Failed to install Meslo Nerd Font via Homebrew. You may need to install it manually."
  fi
fi

# 3) Shell: Oh My Zsh + Atuin hook
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "Installing Oh My Zsh…"
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
if command -v atuin >/dev/null 2>&1; then
  if ! grep -q 'atuin init zsh' "$HOME/.zshrc" 2>/dev/null; then
    echo 'eval "$(atuin init zsh)"' >> "$HOME/.zshrc"
  fi
fi

# Powerlevel10k
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
  info "Installing Powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# Make sure ZSH_THEME is set
if ! grep -q 'ZSH_THEME="powerlevel10k/powerlevel10k"' "$HOME/.zshrc"; then
  sed -i.bak 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc" || true
fi

# 4) Symlink dotfiles
link_file "$REPO_ROOT/dotfiles/zsh/.zshrc"          "$HOME/.zshrc"
[[ -f "$REPO_ROOT/dotfiles/zsh/.p10k.zsh" ]] && link_file "$REPO_ROOT/dotfiles/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
[[ -f "$REPO_ROOT/dotfiles/zsh/aliases.zsh" ]]   && link_file "$REPO_ROOT/dotfiles/zsh/aliases.zsh"   "$HOME/.zsh/aliases.zsh"
[[ -f "$REPO_ROOT/dotfiles/zsh/functions.zsh" ]] && link_file "$REPO_ROOT/dotfiles/zsh/functions.zsh" "$HOME/.zsh/functions.zsh"
[[ -f "$REPO_ROOT/dotfiles/vim/.vimrc" ]]        && link_file "$REPO_ROOT/dotfiles/vim/.vimrc"        "$HOME/.vimrc"

# Git configuration - check if template exists and warn user
if [[ -f "$REPO_ROOT/dotfiles/git/.gitconfig" ]]; then
  if grep -q "your-email@example.com" "$REPO_ROOT/dotfiles/git/.gitconfig"; then
    warn "Git config contains template values. After bootstrap, run:"
    warn "  git config --global user.name 'Your Full Name'"
    warn "  git config --global user.email 'your-email@example.com'"
  fi
  link_file "$REPO_ROOT/dotfiles/git/.gitconfig" "$HOME/.gitconfig"
fi
[[ -f "$REPO_ROOT/dotfiles/git/.gitignore_global" ]] && link_file "$REPO_ROOT/dotfiles/git/.gitignore_global" "$HOME/.gitignore_global"

# 5) VSCode settings + extensions
VSC_USER_DIR="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSC_USER_DIR"
[[ -f "$REPO_ROOT/vscode/settings.json"    ]] && cp -f "$REPO_ROOT/vscode/settings.json"    "$VSC_USER_DIR/settings.json"
[[ -f "$REPO_ROOT/vscode/keybindings.json" ]] && cp -f "$REPO_ROOT/vscode/keybindings.json" "$VSC_USER_DIR/keybindings.json"
[[ -d "$REPO_ROOT/vscode/snippets" ]] && rsync -a "$REPO_ROOT/vscode/snippets/" "$VSC_USER_DIR/snippets/"
if command -v code >/dev/null 2>&1 && [[ -f "$REPO_ROOT/vscode/extensions.txt" ]]; then
  info "Installing VSCode extensions…"
  < "$REPO_ROOT/vscode/extensions.txt" xargs -n1 code --install-extension --force || true
fi

# 6) nvm / Node (latest LTS) & pyenv (latest 3.x)
export NVM_DIR="$HOME/.nvm"
[[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && . "/opt/homebrew/opt/nvm/nvm.sh" || true
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh" || true
command -v nvm >/dev/null 2>&1 || { brew install nvm && mkdir -p "$NVM_DIR" && echo 'export NVM_DIR="$HOME/.nvm"; [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"' >> "$HOME/.zshrc"; . "/opt/homebrew/opt/nvm/nvm.sh"; }
nvm install --lts || true

if command -v pyenv >/dev/null 2>&1; then
  LATEST=$(pyenv install -l | awk '{$1=$1};1' | grep -E '^3\.[0-9]+\.[0-9]+$' | tail -1 || true)
  [[ -n "${LATEST:-}" ]] && pyenv install -s "$LATEST" && pyenv global "$LATEST"
fi

# 7) Caps Lock -> Escape (mac)
bash "$REPO_ROOT/scripts/macos/keyboard.sh"

info "macOS bootstrap complete. For Raycast: open Raycast and run "Import Settings & Data", choose $REPO_ROOT/raycast/raycast.rayconfig"
