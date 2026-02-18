#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$DOTFILES/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# --- Colors ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
RESET='\033[0m'

ok()   { echo -e "  ${GREEN}✓${RESET} $1"; }
warn() { echo -e "  ${YELLOW}!${RESET} $1"; }
fail() { echo -e "  ${RED}✗${RESET} $1"; }

# ============================================================
# Phase 1: Prerequisites
# ============================================================
echo -e "${BOLD}Checking prerequisites${RESET}"
missing=0

for cmd in git go python3; do
  if command -v "$cmd" &>/dev/null; then
    ok "$cmd ($(command -v "$cmd"))"
  else
    fail "$cmd not found — install manually (Xcode, homebrew, pyenv)"
    missing=$((missing + 1))
  fi
done

if [[ $missing -gt 0 ]]; then
  echo ""
  fail "$missing required tool(s) missing. Install them and re-run."
  exit 1
fi

# Optional tools — warn but continue
for cmd in claude markdownlint; do
  if command -v "$cmd" &>/dev/null; then
    ok "$cmd ($(command -v "$cmd"))"
  else
    warn "$cmd not found — some features will be unavailable"
  fi
done

# Brew packages
echo ""
echo -e "${BOLD}Installing brew packages${RESET}"

BREW_PACKAGES=(vale prettier markdownlint-cli lychee mani jq yq fzf gitleaks)

if ! command -v brew &>/dev/null; then
  warn "brew not found — skipping package installs"
else
  for pkg in "${BREW_PACKAGES[@]}"; do
    if brew list "$pkg" &>/dev/null; then
      ok "$pkg (installed)"
    else
      echo -n "  Installing $pkg..."
      if brew install "$pkg" --quiet 2>/dev/null; then
        ok "$pkg"
      else
        warn "$pkg — install failed, continuing"
      fi
    fi
  done
fi

# zoxide — installed via upstream script (not in brew)
echo ""
echo -e "${BOLD}Installing zoxide${RESET}"

if command -v zoxide &>/dev/null; then
  ok "zoxide ($(command -v zoxide))"
else
  echo -n "  Installing zoxide..."
  if curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh &>/dev/null; then
    ok "zoxide"
  else
    warn "zoxide — install failed, continuing"
  fi
fi

# ============================================================
# Phase 2: Symlink dotfiles
# ============================================================
echo ""
echo -e "${BOLD}Symlinking configs${RESET}"

symlink() {
    local src="$DOTFILES/$1"
    local dest="$HOME/$1"
    mkdir -p "$(dirname "$dest")"

    # Already points to the right place — skip
    if [[ -L "$dest" ]] && [[ "$(readlink "$dest")" == "$src" ]]; then
        ok "$1"
        return
    fi

    # Existing file or symlink that differs — back up and prompt
    if [[ -e "$dest" ]] || [[ -L "$dest" ]]; then
        echo "  $1 already exists at $dest"
        read -rp "  Overwrite? Existing file will be backed up. [y/N] " answer
        if [[ ! "$answer" =~ ^[Yy]$ ]]; then
            warn "$1 (skipped)"
            return
        fi
        mkdir -p "$BACKUP_DIR/$(dirname "$1")"
        mv "$dest" "$BACKUP_DIR/$1"
        ok "$1 (backed up to $BACKUP_DIR/$1)"
    fi

    ln -sf "$src" "$dest"
    ok "$1"
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
echo ""
echo -e "${BOLD}Installing oh-my-zsh plugins${RESET}"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_if_missing() {
    local repo="$1"
    local dest="$2"
    mkdir -p "$(dirname "$dest")"
    if [[ ! -d "$dest" ]]; then
        echo -n "  Cloning $(basename "$dest")..."
        if git clone --depth 1 "$repo" "$dest" --quiet 2>/dev/null; then
            ok "$(basename "$dest")"
        else
            warn "$(basename "$dest") — clone failed"
        fi
    else
        ok "$(basename "$dest") (already present)"
    fi
}

clone_if_missing https://github.com/romkatv/powerlevel10k "$ZSH_CUSTOM/themes/powerlevel10k"
clone_if_missing https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# --- Git hooks ---
echo ""
echo -e "${BOLD}Installing dotfiles git hooks${RESET}"

if [[ -x "$DOTFILES/hooks/install.sh" ]]; then
    "$DOTFILES/hooks/install.sh"
    ok "dotfiles hooks installed"
else
    warn "dotfiles/hooks/install.sh not found — skipping"
fi

# ============================================================
# Phase 3: Clone ecosystem repos
# ============================================================
echo ""
echo -e "${BOLD}Cloning ecosystem repos${RESET}"

GH_ORG="${GH_ORG:-tslateman}"
GITHUB="git@github.com:$GH_ORG"
CORE_REPOS=(lore neo mirror praxis tutor)

clone_ok=0
clone_fail=0

for repo in "${CORE_REPOS[@]}"; do
  if [[ -d "$ROOT/$repo" ]]; then
    ok "$repo (already present)"
    clone_ok=$((clone_ok + 1))
  else
    echo -n "  Cloning $repo..."
    if git clone "$GITHUB/$repo.git" "$ROOT/$repo" --quiet 2>/dev/null; then
      ok "$repo"
      clone_ok=$((clone_ok + 1))
    else
      fail "$repo — clone failed"
      clone_fail=$((clone_fail + 1))
    fi
  fi
done

if [[ $clone_fail -gt 0 ]]; then
  warn "$clone_fail repo(s) failed to clone — continuing with what's available"
fi

# ============================================================
# Phase 4: Configure ecosystem
# ============================================================
echo ""
echo -e "${BOLD}Configuring ecosystem${RESET}"

# --- Delegate to cli/bootstrap.sh ---
if [[ -x "$ROOT/cli/bootstrap.sh" ]]; then
  echo ""
  echo -e "${BOLD}Running cli/bootstrap.sh${RESET}"
  DOTFILES_BOOTSTRAP=1 "$ROOT/cli/bootstrap.sh"
else
  warn "cli/bootstrap.sh not found — skipping"
fi

# --- Git hooks ---
echo ""
echo -e "${BOLD}Installing ecosystem git hooks${RESET}"

for project in tutor; do
  if [[ -f "$ROOT/$project/Makefile" ]]; then
    if make -C "$ROOT/$project" setup &>/dev/null; then
      ok "$project hooks installed"
    else
      warn "$project — make setup failed"
    fi
  else
    warn "$project/ — no Makefile found, skipping hooks"
  fi
done

# --- ~/.mirror/ structure ---
echo ""
echo -e "${BOLD}Initializing ~/.mirror${RESET}"

if [[ -d "$HOME/.mirror" ]]; then
  ok "~/.mirror (already present)"
else
  mkdir -p "$HOME/.mirror/principles"
  touch "$HOME/.mirror/judgments.yaml" "$HOME/.mirror/patterns.yaml"
  ok "~/.mirror created"
fi

# --- Vale sync ---
echo ""
echo -e "${BOLD}Syncing vale${RESET}"

if command -v vale &>/dev/null; then
  for project in tutor; do
    if [[ -f "$ROOT/$project/.vale.ini" ]]; then
      if vale --config "$ROOT/$project/.vale.ini" sync &>/dev/null; then
        ok "$project vale synced"
      else
        warn "$project — vale sync failed"
      fi
    fi
  done
else
  warn "vale not found — skipping sync"
fi

# --- Validate cloned repos ---
echo ""
echo -e "${BOLD}Validating cloned repos${RESET}"

for repo in "${CORE_REPOS[@]}"; do
  if [[ -d "$ROOT/$repo" ]]; then
    ok "$repo"
  else
    warn "$repo — not found"
  fi
done

# ============================================================
# Summary
# ============================================================
echo ""
echo -e "${BOLD}Summary${RESET}"
ok "$clone_ok repo(s) present"
[[ $clone_fail -gt 0 ]] && fail "$clone_fail repo(s) failed to clone"
echo ""
echo "Run 'make test' in tutor/ to verify hooks."
echo "Done!"
