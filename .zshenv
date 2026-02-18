# Environment variables (not PATH - those go in .zprofile)
# .zshenv runs for ALL zsh invocations including scripts

export NVM_DIR="$HOME/.nvm"

export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.gcloud/g1cfg.json"

# Set golang env
export GOBIN=/Users/tslater/go/bin
export GOPATH=$HOME/go
export GOPRIVATE=github.com/sparket-app/*

# Vim
export VIMINIT="source ~/.vim/vimrc"

export BUILDTOOLS_DIR=/Users/tslater/dev/infra/multi-repo-release

# Secrets (not in git)
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local

# zsh highlights (using oh-my-zsh plugin, no need to set highlighters dir)
. "$HOME/.cargo/env"
