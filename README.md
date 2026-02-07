# Dotfiles

Personal configuration files for macOS.

## Contents

| Config | Description |
|--------|-------------|
| `.zshrc`, `.zshenv`, `.zprofile` | Zsh shell configuration |
| `.gitconfig` | Git configuration |
| `.config/nvim` | Neovim (LazyVim-based) |
| `.config/ghostty` | Ghostty terminal (Tokyo Night theme) |
| `.config/zed` | Zed editor settings |
| `.config/gh` | GitHub CLI configuration |
| `.config/git/ignore` | Global gitignore |
| `.config/karabiner` | Karabiner-Elements key remapping |
| `.claude` | Claude Code configuration |
| `.vim` | Vim configuration |

## Installation

```bash
# Clone the repo
git clone https://github.com/tslateman/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles

# Install git hooks (secret scanning)
./hooks/install.sh

# Symlink configs (example)
ln -sf ~/dev/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dev/dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/dev/dotfiles/.config/ghostty ~/.config/ghostty
# ... etc
```

## Dependencies

- [Homebrew](https://brew.sh)
- [gitleaks](https://github.com/gitleaks/gitleaks) - Secret scanning (`brew install gitleaks`)
- [fd](https://github.com/sharkdp/fd) - Fast file finder (`brew install fd`)

### Neovim

Requires Neovim 0.9+ with these extras enabled via LazyVim:
- Python (pyright, black, ruff, debugpy, neotest-python)
- TypeScript

## Security

This repo uses gitleaks to prevent accidentally committing secrets. The pre-commit hook scans all staged files before each commit.

To bypass for false positives (not recommended):
```bash
git commit --no-verify
```

To allowlist a false positive, edit `.gitleaks.toml`.
