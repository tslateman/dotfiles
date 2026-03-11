#!/usr/bin/env bash
# UserPromptSubmit hook — detect corrections and inject constraint context.
#
# Two responsibilities:
# 1. Detect correction keywords → observe to Lore inbox + inject encoding prompt
# 2. Always inject relevant constraints from Lore (tagged "constraint")
#
# Returns JSON with hookSpecificOutput.additionalContext when action needed.

set -euo pipefail
trap 'exit 0' ERR

LORE=~/dev/lore/lore.sh

input=$(cat 2>/dev/null)
[ -z "$input" ] && exit 0

prompt=$(echo "$input" | jq -r '.prompt // ""' 2>/dev/null)
[ -z "$prompt" ] && exit 0

# --- Correction Detection ---
# Match at word boundaries: opening words that signal a correction
correction_detected=false
prompt_lower=$(echo "$prompt" | tr '[:upper:]' '[:lower:]')

if echo "$prompt_lower" | grep -qE \
    '^(no[,.]|wrong[,.]|wait[,.]|stop[,.]|actually[,.]|instead[,.]|hold on|that('\''s |is )(not |wrong|incorrect)|don'\''t do that|incorrect[,.]|never do that|not like that)'; then
    correction_detected=true
fi

# --- Observe correction to Lore inbox ---
if $correction_detected; then
    short_prompt=$(echo "$prompt" | head -c 120 | tr '\n' ' ')
    "$LORE" observe "Correction: $short_prompt" \
        --tags "pending-constraint,constraint" \
        2>/dev/null || true
fi

# --- Build additionalContext ---
context=""

if $correction_detected; then
    context="[Constraint Library] User correction detected. After responding, "
    context+="encode this as a constraint: use /constrain to classify and record it, "
    context+="or invoke the constraint-keeper agent for the full Recognition→Articulation→Encoding workflow."
    context+=$'\n\n'
fi

# Retrieve constraints tagged "constraint" for pre-output awareness
constraint_recall=$("$LORE" recall --patterns "constraint" --compact 2>/dev/null | head -20) || true

if [ -n "$constraint_recall" ]; then
    context+="[Constraint Library — active constraints]"$'\n'
    context+="$constraint_recall"$'\n'
fi

[ -z "$context" ] && exit 0

jq -n --arg ctx "$context" '{
    hookSpecificOutput: {
        additionalContext: $ctx
    }
}'

exit 0
