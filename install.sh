#!/bin/bash
# Bootstrap dotfiles: symlink configs and install dependencies

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# --- Symlinks ---

echo "Symlinking configs..."

symlink() {
    local src="$DOTFILES/$1"
    local dest="$HOME/$1"
    mkdir -p "$(dirname "$dest")"

    # Already points to the right place — skip
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        echo "  $1 (ok)"
        return
    fi

    # Existing file or symlink that differs — back up and prompt
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "  $1 already exists at $dest"
        read -rp "  Overwrite? Existing file will be backed up. [y/N] " answer
        if [[ ! "$answer" =~ ^[Yy]$ ]]; then
            echo "  Skipped $1"
            return
        fi
        mkdir -p "$BACKUP_DIR/$(dirname "$1")"
        mv "$dest" "$BACKUP_DIR/$1"
        echo "  Backed up to $BACKUP_DIR/$1"
    fi

    ln -sf "$src" "$dest"
    echo "  $1"
}

symlink .zshrc
symlink .zshenv
symlink .zprofile
symlink .bashrc
symlink .p10k.zsh
symlink .gitconfig
symlink .gitleaks.toml
symlink .warprc
symlink .vuerc
symlink .serverlessrc
symlink .boto
symlink .vim
symlink .claude
symlink .config/nvim
symlink .config/ghostty
symlink .config/zed
symlink .config/gh
symlink .config/git
symlink .config/karabiner
symlink .oh-my-zsh/custom/aliases.zsh

# --- oh-my-zsh plugins & theme ---

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_if_missing() {
    local repo="$1"
    local dest="$2"
    if [ ! -d "$dest" ]; then
        echo "  Cloning $repo..."
        git clone --depth 1 "$repo" "$dest"
    else
        echo "  Already installed: $(basename "$dest")"
    fi
}

echo "Installing oh-my-zsh plugins..."
clone_if_missing https://github.com/romkatv/powerlevel10k "$ZSH_CUSTOM/themes/powerlevel10k"
clone_if_missing https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# --- Git hooks ---

echo "Installing git hooks..."
"$DOTFILES/hooks/install.sh"

echo "Done!"
