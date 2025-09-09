#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$REPO_ROOT/scripts/common.sh"

[[ "$(uname -s)" != "Linux" ]] && { error "This script is for Linux only"; exit 1; }

# 1) Basics
sudo apt-get update -y
sudo apt-get install -y build-essential curl wget git ca-certificates gnupg lsb-release unzip

# 2) Homebrew (Linuxbrew) for CLI tools you like
if ! command -v brew >/dev/null 2>&1; then
  info "Installing Homebrew (Linuxbrew)…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
  test -d /home/linuxbrew/.linuxbrew && eval "($(/home/linuxbrew/.linuxbrew/bin/brew shellenv))"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.profile"
fi

# 3) Common apps (GUI) via apt/snap where convenient
# VS Code
if ! command -v code >/dev/null 2>&1; then
  info "Installing VSCode (apt repo)…"
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/packages.microsoft.gpg >/dev/null
  sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  sudo apt-get update -y && sudo apt-get install -y code
fi

# Docker (official script)
if ! command -v docker >/dev/null 2>&1; then
  info "Installing Docker (official)…"
  curl -fsSL https://get.docker.com | sh
  sudo usermod -aG docker "$USER" || true
fi

# Slack / Postman / Spotify / Firefox / Chrome
# Use snaps for simplicity (you can replace with apt repos if you prefer)
sudo snap install slack --classic || true
sudo snap install postman || true
sudo snap install spotify || true
# Firefox is typically preinstalled on Ubuntu. If not:
if ! command -v firefox >/dev/null 2>&1; then sudo snap install firefox || true; fi
# Chrome: download .deb (Google repo also works)
if ! command -v google-chrome >/dev/null 2>&1; then
  info "Installing Google Chrome…"
  tmpdeb="$(mktemp).deb"
  wget -O "$tmpdeb" https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt-get install -y "$tmpdeb" || sudo dpkg -i "$tmpdeb" || true
  rm -f "$tmpdeb"
fi

# 4) Brew for CLI goodies (zsh, pyenv, nvm, atuin, ripgrep, fzf, jq, etc.)
brew update
if [[ -f "$REPO_ROOT/Brewfile" ]]; then
  brew bundle --file="$REPO_ROOT/Brewfile" || true
else
  brew install zsh pyenv nvm atuin git curl wget jq fzf ripgrep
fi

# Meslo Nerd Fonts
if ! fc-list | grep -qi "MesloLGS NF"; then
  info "Installing Meslo Nerd Fonts..."
  brew tap homebrew/cask-fonts || true
  brew install --cask font-meslo-lg-nerd-font

  mkdir -p "$HOME/.local/share/fonts"
  cp -f $(brew --prefix)/Caskroom/font-meslo-lg-nerd-font/*/*/*.ttf "$HOME/.local/share/fonts/" || true
  fc-cache -fv
fi

# 5) Oh My Zsh + Atuin hook
if [[ "$SHELL" != *"zsh"* ]]; then chsh -s "$(command -v zsh)" || true; fi
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

# 6) Symlink dotfiles
link_file "$REPO_ROOT/dotfiles/zsh/.zshrc"          "$HOME/.zshrc"
[[ -f "$REPO_ROOT/dotfiles/zsh/.p10k.zsh" ]] && link_file "$REPO_ROOT/dotfiles/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
[[ -f "$REPO_ROOT/dotfiles/zsh/aliases.zsh" ]]   && link_file "$REPO_ROOT/dotfiles/zsh/aliases.zsh"   "$HOME/.zsh/aliases.zsh"
[[ -f "$REPO_ROOT/dotfiles/zsh/functions.zsh" ]] && link_file "$REPO_ROOT/dotfiles/zsh/functions.zsh" "$HOME/.zsh/functions.zsh"
[[ -f "$REPO_ROOT/dotfiles/vim/.vimrc" ]]        && link_file "$REPO_ROOT/dotfiles/vim/.vimrc"        "$HOME/.vimrc"
[[ -f "$REPO_ROOT/dotfiles/git/.gitconfig" ]]    && link_file "$REPO_ROOT/dotfiles/git/.gitconfig"    "$HOME/.gitconfig"
[[ -f "$REPO_ROOT/dotfiles/git/.gitignore_global" ]] && link_file "$REPO_ROOT/dotfiles/git/.gitignore_global" "$HOME/.gitignore_global"

# 7) VSCode settings + extensions
VSC_USER_DIR="$HOME/.config/Code/User"
mkdir -p "$VSC_USER_DIR"
[[ -f "$REPO_ROOT/vscode/settings.json"    ]] && cp -f "$REPO_ROOT/vscode/settings.json"    "$VSC_USER_DIR/settings.json"
[[ -f "$REPO_ROOT/vscode/keybindings.json" ]] && cp -f "$REPO_ROOT/vscode/keybindings.json" "$VSC_USER_DIR/keybindings.json"
[[ -d "$REPO_ROOT/vscode/snippets" ]] && rsync -a "$REPO_ROOT/vscode/snippets/" "$VSC_USER_DIR/snippets/"
if command -v code >/dev/null 2>&1 && [[ -f "$REPO_ROOT/vscode/extensions.txt" ]]; then
  info "Installing VSCode extensions…"
  < "$REPO_ROOT/vscode/extensions.txt" xargs -n1 code --install-extension --force || true
fi

# 8) nvm / Node LTS & pyenv Python latest 3.x
export NVM_DIR="$HOME/.nvm"
[[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ]] && . "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" || true
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh" || true
command -v nvm >/dev/null 2>&1 || { brew install nvm && mkdir -p "$NVM_DIR" && echo 'export NVM_DIR="$HOME/.nvm"; [ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ] && . "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh"' >> "$HOME/.zshrc"; . "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh"; }
nvm install --lts || true

if command -v pyenv >/dev/null 2>&1; then
  LATEST=$(pyenv install -l | awk '{$1=$1};1' | grep -E '^3\.[0-9]+\.[0-9]+$' | tail -1 || true)
  [[ -n "${LATEST:-}" ]] && pyenv install -s "$LATEST" && pyenv global "$LATEST"
fi

# 9) Caps Lock -> Escape (GNOME)
bash "$REPO_ROOT/scripts/ubuntu/keyboard.sh"

info "Ubuntu bootstrap complete. (Log out/in if Docker group was just added.)"
