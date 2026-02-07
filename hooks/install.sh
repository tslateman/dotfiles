#!/bin/bash
# Install git hooks for this repository

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS_DIR="$(dirname "$SCRIPT_DIR")/.git/hooks"

echo "Installing git hooks..."

for hook in "$SCRIPT_DIR"/*; do
    hook_name=$(basename "$hook")

    # Skip this install script
    if [ "$hook_name" = "install.sh" ]; then
        continue
    fi

    # Create symlink
    ln -sf "$hook" "$HOOKS_DIR/$hook_name"
    echo "  Installed: $hook_name"
done

echo "Done!"
