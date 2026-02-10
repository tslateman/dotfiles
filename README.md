# Dotfiles

Personal configuration files for macOS.

## Contents

| Config                           | Description                                   |
| -------------------------------- | --------------------------------------------- |
| `.zshrc`, `.zshenv`, `.zprofile` | Zsh shell configuration                       |
| `.gitconfig`                     | Git configuration                             |
| `.config/nvim`                   | Neovim (LazyVim-based)                        |
| `.config/ghostty`                | Ghostty terminal (Tokyo Night theme)          |
| `.config/zed`                    | Zed editor settings                           |
| `.config/gh`                     | GitHub CLI configuration                      |
| `.config/git/ignore`             | Global gitignore                              |
| `.config/karabiner`              | Karabiner-Elements key remapping              |
| `.claude`                        | Claude Code (commands, skills, hooks, agents) |
| `.vim`                           | Vim configuration                             |
| `.oh-my-zsh/custom/aliases.zsh`  | Custom shell aliases                          |

## Installation

```bash
git clone https://github.com/tslateman/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles
./install.sh
```

This symlinks all configs, installs oh-my-zsh plugins (Powerlevel10k, zsh-autosuggestions, zsh-syntax-highlighting), and sets up the gitleaks pre-commit hook.

## CLI Tools

### Language Runtimes & Version Managers

| Tool                                           | Purpose                                  |
| ---------------------------------------------- | ---------------------------------------- |
| [pyenv](https://github.com/pyenv/pyenv)        | Python version management (lazy-loaded)  |
| [nvm](https://github.com/nvm-sh/nvm)           | Node.js version management (lazy-loaded) |
| [chruby](https://github.com/postmodern/chruby) | Ruby version management                  |
| [cargo/rustup](https://rustup.rs)              | Rust toolchain                           |
| [Go](https://go.dev)                           | Go workspace                             |
| [Deno](https://deno.land)                      | Deno runtime                             |
| [pnpm](https://pnpm.io)                        | Node package manager                     |

### Editors

| Tool                        | Purpose                                              |
| --------------------------- | ---------------------------------------------------- |
| [Neovim](https://neovim.io) | Primary editor (LazyVim, LSP, Telescope, Treesitter) |
| [Vim](https://www.vim.org)  | Backup editor (Vundle + vim-plug)                    |

### Terminal & Shell

| Tool                                                                            | Purpose                                         |
| ------------------------------------------------------------------------------- | ----------------------------------------------- |
| [Ghostty](https://ghostty.org)                                                  | Terminal emulator (Tokyo Night, Powerline font) |
| [oh-my-zsh](https://ohmyz.sh)                                                   | Zsh framework                                   |
| [Powerlevel10k](https://github.com/romkatv/powerlevel10k)                       | Zsh prompt theme                                |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)         | Shell autocompletion                            |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | Shell syntax highlighting                       |

### Git & Security

| Tool                                             | Purpose                    |
| ------------------------------------------------ | -------------------------- |
| [gh](https://cli.github.com)                     | GitHub CLI                 |
| [gitleaks](https://github.com/gitleaks/gitleaks) | Pre-commit secret scanning |

### Infrastructure

| Tool                                               | Purpose                      |
| -------------------------------------------------- | ---------------------------- |
| AWS / GCP                                          | Cloud credentials configured |
| [Serverless Framework](https://www.serverless.com) | Serverless deployments       |
| [PostgreSQL](https://www.postgresql.org) (libpq)   | Database client tools        |

### Utilities

| Tool                                                                     | Purpose                          |
| ------------------------------------------------------------------------ | -------------------------------- |
| [Karabiner-Elements](https://karabiner-elements.pqrs.org)                | Keyboard remapping               |
| [fd](https://github.com/sharkdp/fd)                                      | Fast file finder                 |
| [pandoc](https://pandoc.org) + [lynx](https://lynx.invisible-island.net) | Markdown rendering (`rmd` alias) |
| [Claude Code](https://claude.ai/claude-code)                             | AI coding assistant              |
| [Vue CLI](https://cli.vuejs.org)                                         | Vue.js project scaffolding       |

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
