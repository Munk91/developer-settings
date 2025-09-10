# Security Guidelines

## Files Excluded from Git

The following sensitive files are automatically excluded via `.gitignore`:

### Shell Secrets
- `**/.zsh_secrets` - Personal environment variables, API keys, tokens
- `*.key` - Private keys
- `*.session` - Session files

### Atuin History
- `**/atuin/history.db` - Shell command history database
- `**/.local/share/atuin/**` - Atuin data directory

### Temporary Files
- `*.rayconfig.backup` - Temporary Raycast backups
- `.DS_Store` - macOS metadata files

## Required Secret Files

After running the bootstrap script, you'll need to create these files manually:

### ~/.zsh_secrets
Create this file for personal/sensitive environment variables:

```bash
# Example content for ~/.zsh_secrets
export GITHUB_TOKEN="your_github_token_here"
export OPENAI_API_KEY="your_openai_key_here"
export AWS_ACCESS_KEY_ID="your_aws_key_here"
export AWS_SECRET_ACCESS_KEY="your_aws_secret_here"

# Custom aliases that might contain sensitive info
alias connect-prod="ssh user@sensitive-server.com"
```

### Git Configuration
The bootstrap script uses template values. Update them with your information:

```bash
git config --global user.name "Your Full Name"
git config --global user.email "your-email@example.com"
```

## Security Best Practices

1. **Never commit secrets**: Always use environment variables or secret files
2. **Review before pushing**: Check `git diff` before committing changes
3. **Use .gitignore**: Add any new sensitive file patterns to `.gitignore`
4. **Audit dependencies**: Review the Brewfile before running to understand what gets installed
5. **Regular updates**: Keep your tools and dependencies updated

## What Gets Installed

The bootstrap scripts install various tools and applications. Review the `Brewfile` to see exactly what will be installed on your system.

### Network Access
The scripts will:
- Download and install Homebrew
- Install packages from Homebrew repositories
- Clone Git repositories (Oh My Zsh, Powerlevel10k)
- Download VSCode from Microsoft
- Install Docker and other tools

### System Modifications
The scripts will:
- Modify shell configuration files
- Install fonts system-wide
- Add applications to your system
- Modify keyboard settings (Caps Lock → Escape)

## Validation

Always review scripts before running them:

```bash
# Review what will be installed
cat Brewfile

# Check script contents
cat scripts/bootstrap-mac.sh    # or bootstrap-ubuntu.sh
```