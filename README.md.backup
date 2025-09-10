# Developer Settings

Personal developer environment setup repository to make it easier to bootstrap a new development machine.

## What's Included

- **Package Management**: Comprehensive Brewfile with development tools, languages, and applications
- **Shell Configuration**: Zsh with Oh My Zsh, Powerlevel10k theme, and Atuin history sync
- **Dotfiles**: Git, Vim, Zsh configurations
- **VSCode**: Settings, keybindings, and curated extension list
- **Platform Support**: Bootstrap scripts for both macOS and Ubuntu
- **Raycast**: Configuration export/import

## Quick Start

### macOS
```bash
git clone https://github.com/Munk91/developer-settings.git
cd developer-settings
./scripts/bootstrap-mac.sh
```

### Ubuntu/Linux
```bash
git clone https://github.com/Munk91/developer-settings.git
cd developer-settings
./scripts/bootstrap-ubuntu.sh
```

## What Gets Installed

### Core Tools
- **Homebrew** (package manager)
- **Git**, **curl**, **wget** (essentials)
- **Zsh** with Oh My Zsh and Powerlevel10k theme
- **Atuin** (shell history sync)
- **VSCode** with extensions and settings

### Development Languages & Runtimes
- **Node.js** (via nvm - latest LTS)
- **Python** (via pyenv - latest 3.x)
- **Go**, **Rust** (via rustup)
- **Java** (OpenJDK)

### Development Tools
- **Docker** (with Colima on macOS)
- **Kubernetes** tools (kubectl, helm, k9s)
- **Terraform**
- **GitHub CLI** (gh)

### Applications (GUI)
- **Visual Studio Code**
- **Raycast** (macOS productivity tool)
- **Browsers**: Firefox, Google Chrome
- **Communication**: Slack
- **Development**: Postman

## Configuration

### Personal Git Setup
After running the bootstrap script, update your git configuration:

```bash
git config --global user.name "Your Full Name"
git config --global user.email "your-email@example.com"
```

### Secret Files
Create these files for personal/sensitive configurations:

- `~/.zsh_secrets` - Personal environment variables and API keys
- Atuin configuration is handled automatically during bootstrap

### Raycast Import
For Raycast settings:
1. Open Raycast
2. Run "Import Settings & Data"
3. Choose `raycast/raycast.rayconfig` from this repository

## Customization

### Export Current Settings
To update this repository with your current configurations:

```bash
./scripts/export.sh
```

This will copy your current dotfiles, VSCode settings, and generate a new Brewfile.

### Adding New Packages
Edit `Brewfile` to add new tools:

```ruby
# CLI tools
brew "new-tool"

# GUI applications  
cask "new-app"

# VSCode extensions
vscode "publisher.extension-name"
```

## Security Notes

- Personal secrets are excluded via `.gitignore`
- Store sensitive environment variables in `~/.zsh_secrets` (not tracked by git)
- Atuin history database and session files are excluded from git
- Review the Brewfile before running to understand what will be installed

## Troubleshooting

### Script Permissions
If you get permission errors, ensure scripts are executable:
```bash
chmod +x scripts/*.sh scripts/*/*.sh
```

### Font Issues
If terminal fonts look incorrect, install Meslo Nerd Font manually:
```bash
brew install --cask font-meslo-lg-nerd-font
```

### VSCode Extensions
If VSCode extensions fail to install, try:
```bash
code --install-extension-list vscode/extensions.txt
```

## File Structure

```
├── Brewfile                 # Homebrew packages and VSCode extensions
├── dotfiles/               # Shell and tool configurations
│   ├── git/               # Git configuration and global gitignore
│   ├── vim/               # Vim configuration  
│   ├── zsh/               # Zsh and shell configurations
│   └── atuin/             # Atuin shell history sync config
├── scripts/               # Setup and utility scripts
│   ├── bootstrap-mac.sh   # macOS setup script
│   ├── bootstrap-ubuntu.sh # Ubuntu setup script
│   ├── export.sh          # Export current configs to this repo
│   └── common.sh          # Shared functions
├── vscode/                # VSCode settings and extensions
│   ├── settings.json      # Editor settings
│   ├── keybindings.json   # Custom keybindings
│   └── extensions.txt     # Extension list
└── raycast/               # Raycast configuration
    └── raycast.rayconfig  # Raycast settings export
```
