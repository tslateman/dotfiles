# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]

# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/tslater/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder


# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(wd zsh-autosuggestions zsh-syntax-highlighting)
bindkey '^ ' autosuggest-accept

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/shims:$PATH"
eval "$(pyenv init -)"

# nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# Defer initialization of nvm until nvm, node or a node-dependent command is
# run. Ensure this block is only run once if .bashrc gets sourced multiple times
# by checking whether __init_nvm is a function.
if [ -s "$HOME/.nvm/nvm.sh" ] && [ ! "$(whence -w __init_nvm)" = "__init_nvm: function" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
  declare -a __node_commands=('nvm' 'node' 'npm' 'yarn' 'gulp' 'grunt' 'webpack' 'pnpm' 'vite')
  function __init_nvm() {
    for i in "${__node_commands[@]}"; do unalias $i; done
    . "$NVM_DIR"/nvm.sh
    unset __node_commands
    unset -f __init_nvm
  }
  for i in "${__node_commands[@]}"; do alias $i='__init_nvm && '$i; done
fi

# syntax highlighting
# source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# markdown formatting
rmd () {
  pandoc $1 | lynx -stdin
}

# git aliases
alias gcmt="git commit"
alias gdf="git diff --stat"
alias gdff="git diff"
alias gct="git commit"
alias gst="git status"
alias gitst="git status"
alias glg="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gad="git add"
alias gwip="git commit -m 'wip'"
alias fixup="git commit -m 'fixup'"
alias glint="git commit -m 'lint'"
alias gitbr="git branch"
alias gamd="git commit --amend"
alias gref="git reflog"
alias gpl="git pull"
alias gck="git checkout"
alias gbr="git branch"

# tab auto-completion git
autoload -Uz compinit && compinit

alias zshconfig="mate ~/.zshrc"

# alias nvim='env -u VIMINIT nvim'
alias nv='env -u VIMINIT nvim'
alias python='python3'  # TODO: remove — pyenv shims handle this
alias py='python'
alias oldvi='vi'
alias vi='vim'
. "/Users/tslater/.deno/env"

# personal projects
alias mt='molt'
alias mon='lore'
alias ml='lore list'
alias ms='lore status'

# Remove duplicate history
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP

# PyCharm
alias charm="open -a PyCharm"

# syntax-highlighting loaded via oh-my-zsh plugin

# . "$HOME/.cargo/env"

# Added by Windsurf
export PATH="/Users/tslater/.codeium/windsurf/bin:$PATH"

# chruby for jekyll
if [[ -f /opt/homebrew/opt/chruby/share/chruby/chruby.sh ]]; then
  source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
  source /opt/homebrew/opt/chruby/share/chruby/auto.sh
  chruby ruby-3.4.1
fi

# pnpm
export PNPM_HOME="/Users/tslater/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# opencode
export PATH=/Users/tslater/.opencode/bin:$PATH

# libpq for postgres
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# For compilers to find libpq you may need to set:
export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib -L/opt/homebrew/opt/libpq/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include -I/opt/homebrew/opt/libpq/include"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.orbstack/bin:$PATH"

# zoxide — frecency-based directory jumping
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# wm — tmux workspace manager (uses iTerm native integration when available)
wm() {
  local name="$1"
  if [[ -z "$name" ]]; then
    if [[ -n "$TMUX" ]]; then
      tmux list-sessions
    else
      echo "usage: wm <bookmark>"
    fi
    return
  fi

  # Resolve directory from wd bookmarks
  local dir
  dir=$(awk -F: -v name="$name" '$1 == name { print $2; exit }' ~/.warprc 2>/dev/null)
  dir="${dir/#\~/$HOME}"

  if [[ -z "$dir" || ! -d "$dir" ]]; then
    echo "wm: no wd bookmark '$name' (or directory missing)"
    return 1
  fi

  if [[ -n "$TMUX" ]]; then
    # Already inside tmux — switch or create
    if tmux has-session -t "=$name" 2>/dev/null; then
      tmux switch-client -t "=$name"
    else
      tmux new-session -d -s "$name" -c "$dir"
      tmux switch-client -t "=$name"
    fi
  elif [[ "${TERM_PROGRAM:-}" == "iTerm.app" || "${LC_TERMINAL:-}" == "iTerm2" ]]; then
    # iTerm — use -CC for native tab/split integration
    if tmux has-session -t "=$name" 2>/dev/null; then
      tmux -CC attach -t "=$name"
    else
      tmux -CC new-session -s "$name" -c "$dir"
    fi
  else
    # Plain terminal — attach or create
    if tmux has-session -t "=$name" 2>/dev/null; then
      tmux attach -t "=$name"
    else
      tmux new-session -s "$name" -c "$dir"
    fi
  fi
}

# Tab completion for wm — completes from wd bookmarks
_wm() {
  local -a bookmarks
  bookmarks=(${(f)"$(awk -F: '{ print $1 }' ~/.warprc 2>/dev/null)"})
  _describe 'bookmark' bookmarks
}
compdef _wm wm

# Local secrets (not committed)
[[ -f ~/.env ]] && source ~/.env

export CANARY_DIR=/Users/tslater/dev/canary
