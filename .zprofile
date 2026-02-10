# PATH additions for login shells
# .zprofile runs once per login shell (iTerm tabs)

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# User bins
export PATH="$HOME/bin:$PATH"

# Serverless
export PATH="$HOME/.serverless/bin:$PATH"

# Go
export PATH="$GOPATH/bin:$PATH"

# uv / pip user installs
export PATH="$HOME/.local/bin:$PATH"

# Cargo/Rust
. "$HOME/.cargo/env"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
