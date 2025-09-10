# VSCode Configuration

This directory contains two sets of VSCode configurations:

## .vscode/ 
Workspace-specific settings for this repository (currently minimal/empty).
Used when working on this developer-settings repository itself.

## vscode/
User-level VSCode settings that get copied to your VSCode User directory during bootstrap.
These are the settings you'll use for your daily development work.

The bootstrap scripts copy files from `vscode/` to your VSCode User directory:
- macOS: `~/Library/Application Support/Code/User/`
- Linux: `~/.config/Code/User/`