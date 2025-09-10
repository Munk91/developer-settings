# Developer Settings

A comprehensive development environment setup repository that automates the installation and configuration of development tools, applications, and dotfiles for macOS and Ubuntu systems.

## 🚀 What This Repository Provides

This repository contains everything needed to quickly set up a complete development environment, including:

- **Development Tools**: Programming languages (Go, Python, Node.js, Rust, Java), version managers (nvm, pyenv, mise), and build tools
- **Command Line Tools**: Modern CLI utilities (atuin for shell history, kubectl, docker, gh CLI)
- **Applications**: Docker, Raycast, VirtualBox, and essential fonts
- **IDE Setup**: Complete VS Code configuration with 70+ extensions for various programming languages
- **Shell Configuration**: Zsh with oh-my-zsh, powerlevel10k theme, and useful plugins
- **Git Configuration**: Pre-configured git settings and aliases
- **Container & Cloud Tools**: Docker, Kubernetes, Terraform, and cloud CLI tools

## 📋 Prerequisites

### macOS
- macOS 10.15 (Catalina) or later
- Command Line Tools for Xcode (will be installed automatically if missing)
- Administrator access for installing applications

### Ubuntu/Linux
- Ubuntu 18.04 LTS or later (or compatible Debian-based distribution)
- sudo access
- Internet connection for downloading packages

## ⚡ Quick Start

### macOS Installation

1. **Clone this repository:**
   ```bash
   git clone https://github.com/Munk91/developer-settings.git
   cd developer-settings
   ```

2. **Run the bootstrap script:**
   ```bash
   ./scripts/bootstrap-mac.sh
   ```

3. **Follow the prompts** and let the script install everything automatically

### Ubuntu Installation

1. **Clone this repository:**
   ```bash
   git clone https://github.com/Munk91/developer-settings.git
   cd developer-settings
   ```

2. **Run the bootstrap script:**
   ```bash
   ./scripts/bootstrap-ubuntu.sh
   ```

3. **Follow the prompts** and let the script install everything automatically

## 📂 Repository Structure

```
developer-settings/
├── Brewfile                 # Homebrew packages and applications
├── SECURITY.md             # Security guidelines and best practices
├── VSCode-README.md        # VSCode configuration documentation
├── scripts/
│   ├── bootstrap-mac.sh     # macOS setup script
│   ├── bootstrap-ubuntu.sh  # Ubuntu setup script
│   ├── common.sh           # Shared utilities
│   └── export.sh           # Configuration export utilities
├── dotfiles/
│   ├── git/                # Git configuration
│   │   ├── .gitconfig      # Git settings and aliases
│   │   └── .gitconfig.template # Template for personal git config
│   ├── zsh/                # Zsh shell configuration
│   ├── vim/                # Vim configuration
│   └── atuin/              # Shell history configuration
├── vscode/
│   ├── settings.json       # VS Code settings
│   ├── keybindings.json    # Custom keybindings
│   └── extensions.txt      # List of extensions
└── raycast/                # Raycast configuration (macOS)
```

## 🔧 What Gets Installed

### Core Development Tools
- **Languages**: Go, Python 3.11, Node.js, TypeScript, Rust, Java (OpenJDK)
- **Version Managers**: nvm (Node), pyenv (Python), mise (universal version manager)
- **Package Managers**: npm, yarn, pnpm, pip
- **Build Tools**: CMake, Gradle, Vite

### Command Line Utilities
- **Shell**: Zsh with oh-my-zsh and powerlevel10k theme
- **Git**: GitHub CLI (gh), GitLens
- **History**: Atuin (encrypted shell history sync)
- **Containers**: Docker, kubectl, helm, k9s
- **Cloud/Infrastructure**: Terraform, MongoDB tools, PlanetScale CLI
- **Utilities**: curl, wget, parallel, jq

### Applications (macOS via Homebrew Cask)
- **Productivity**: Raycast (launcher and productivity tool)
- **Development**: Visual Studio Code (with 70+ extensions)
- **Virtualization**: VirtualBox, Lima, Colima
- **Fonts**: Meslo LG Nerd Font (for terminal icons)

### VS Code Extensions
Over 70 carefully selected extensions including:
- **AI Assistants**: GitHub Copilot, Claude, ChatGPT
- **Languages**: Go, Python, Rust, Java, TypeScript, GraphQL
- **Themes**: Multiple color themes (Night Owl, Tokyo Night, Gruvbox, etc.)
- **Productivity**: GitLens, Error Lens, Prettier, ESLint
- **Containers**: Docker, Kubernetes support

**Note**: See `VSCode-README.md` for detailed information about the VS Code configuration setup and dual workspace approach.

## 📖 Detailed Usage

### Running Individual Components

If you want to install specific components rather than running the full bootstrap:

**Install just the Homebrew packages:**
```bash
brew bundle --file=Brewfile
```

**Install VS Code extensions only:**
```bash
cat vscode/extensions.txt | xargs -I {} code --install-extension {}
```

**Apply dotfiles:**
```bash
# The bootstrap scripts will do this, but you can also manually link:
ln -sf $(pwd)/dotfiles/git/.gitconfig ~/.gitconfig
ln -sf $(pwd)/dotfiles/zsh/.zshrc ~/.zshrc
```

### Customizing the Setup

1. **Modify the Brewfile** to add/remove packages:
   ```bash
   # Add a new package
   echo 'brew "package-name"' >> Brewfile
   
   # Install the new package
   brew bundle --file=Brewfile
   ```

2. **Update VS Code extensions**:
   - Edit `vscode/extensions.txt`
   - Run: `cat vscode/extensions.txt | xargs -I {} code --install-extension {}`

3. **Customize shell configuration**:
   - Edit `dotfiles/zsh/.zshrc`
   - Restart your terminal or run: `source ~/.zshrc`

### Exporting Your Current Configuration

To export your current setup and update this repository:

```bash
./scripts/export.sh
```

This will update the configuration files with your current settings.

## 🔍 Platform-Specific Notes

### macOS
- Installs Homebrew if not present
- Uses Homebrew Cask for GUI applications
- Configures Raycast for productivity
- Installs Nerd Fonts for terminal themes

### Ubuntu/Linux
- Installs Linuxbrew for CLI tools
- Uses apt for system packages
- Installs VS Code via Microsoft's apt repository
- Sets up Docker via official installation script

## 🔒 Security Considerations

This repository includes comprehensive security documentation and best practices:

- **Security Documentation**: See `SECURITY.md` for detailed security guidelines and best practices
- **Template Configurations**: Personal information has been removed from tracked files - use `.gitconfig.template` to set up your personal git configuration
- **Dependency Validation**: Bootstrap scripts validate required tools before making system changes
- **No Secrets in Git**: Personal secrets, API keys, and sensitive data are excluded via `.gitignore`
- **Script Safety**: All scripts include error handling and dependency checks before execution

**Important**: After running the bootstrap script, configure your personal git settings using the template:
```bash
cp dotfiles/git/.gitconfig.template ~/.gitconfig
# Then edit ~/.gitconfig with your personal information
```

Store sensitive environment variables in `~/.zsh_secrets` (automatically excluded from git tracking).

## 🐛 Troubleshooting

### Common Issues

**Permission denied errors:**
```bash
# Make scripts executable
chmod +x scripts/*.sh
```

**Homebrew installation fails:**
```bash
# Install Command Line Tools manually
xcode-select --install
```

**VS Code extensions fail to install:**
```bash
# Install VS Code first, then run:
cat vscode/extensions.txt | xargs -I {} code --install-extension {}
```

**Shell theme not loading:**
```bash
# Restart terminal or source the configuration
source ~/.zshrc
```

### Getting Help

1. Check the script output for specific error messages
2. Ensure you have the required prerequisites
3. Try running individual components to isolate issues
4. Check that you have sufficient disk space and internet connectivity

## 🤝 Contributing

Feel free to customize this setup for your own needs:

1. Fork this repository
2. Modify the configurations to match your preferences
3. Test the setup on a clean system
4. Update the documentation if you add new features

## 📝 License

This repository contains personal development configurations and is provided as-is for educational and personal use.
