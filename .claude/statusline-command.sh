#!/usr/bin/env bash
# StatusLine script for Claude Code
# Based on Powerlevel10k lean prompt: os_icon | dir | git | prompt_char
# Layout:  directory  branch [●] | Model X.Y | ctx:N%

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir')
context_remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
agent_name=$(echo "$input" | jq -r '.agent.name // empty')
model_id=$(echo "$input" | jq -r '.model.id // empty')

# OS icon (macOS)
os_icon=""

# Directory name (shortened)
dir_name=$(basename "$cwd")

# Git status (skip optional locks to avoid blocking)
git_info=""
if git -C "$cwd" --no-optional-locks rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null || echo "detached")

  # Check for uncommitted changes
  if ! git -C "$cwd" --no-optional-locks diff --quiet 2>/dev/null || \
     ! git -C "$cwd" --no-optional-locks diff --cached --quiet 2>/dev/null; then
    git_info=" ${branch} ●"
  else
    git_info=" ${branch}"
  fi
fi

# Model display: claude-opus-4-6 → Opus 4.6, claude-sonnet-4-5-20250929 → Sonnet 4.5
model_display=""
if [ -n "$model_id" ]; then
  model_display=$(echo "$model_id" | sed 's/^claude-//;s/-[0-9]\{8\}$//' | awk -F- '{printf "%s %s.%s", toupper(substr($1,1,1)) substr($1,2), $2, $3}')
fi

# Build status line
left="${os_icon} ${dir_name}${git_info}"

# Right side: model | ctx | agent, joined with " | "
right=""
add_segment() {
  [ -n "$right" ] && right="${right} | $1" || right="$1"
}

[ -n "$model_display" ] && add_segment "$model_display"

if [ -f ~/.claude/.ctx-stale ]; then
  marker_age=$(( $(date +%s) - $(stat -f %m ~/.claude/.ctx-stale) ))
  if [ "$marker_age" -lt 10 ]; then
    add_segment "ctx:..."
  else
    rm -f ~/.claude/.ctx-stale
    if [ -n "$context_remaining" ]; then
      context_used=$((100 - context_remaining))
      add_segment "ctx:${context_used}%"
    fi
  fi
elif [ -n "$context_remaining" ]; then
  context_used=$((100 - context_remaining))
  add_segment "ctx:${context_used}%"
fi

[ -n "$agent_name" ] && add_segment "agent:${agent_name}"

# Combine with separator if right side exists
if [ -n "$right" ]; then
  printf "\033[2m%s | %s\033[0m" "$left" "$right"
else
  printf "\033[2m%s\033[0m" "$left"
fi
