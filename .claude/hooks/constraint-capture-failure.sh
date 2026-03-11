#!/usr/bin/env bash
# PostToolUseFailure hook — capture tool failures to Lore failures/
# Runs after any tool execution failure. Records structured failure entries
# for the Rule-of-3 trigger analysis (lore recall --triggers).

set -euo pipefail
trap 'exit 0' ERR

LORE=~/dev/lore/lore.sh

input=$(cat 2>/dev/null)
[ -z "$input" ] && exit 0

# Extract fields from hook payload
tool=$(echo "$input" | jq -r '.tool_name // .tool // "unknown"' 2>/dev/null)
error=$(echo "$input" | jq -r '.error // ""' 2>/dev/null)
exit_code=$(echo "$input" | jq -r '.exit_code // ""' 2>/dev/null)

[ -z "$error" ] && exit 0

# Classify error type using Lore's taxonomy
error_lower=$(echo "$error" | tr '[:upper:]' '[:lower:]')

if echo "$error_lower" | grep -qE 'denied|rejected|permission denied by user|user rejected'; then
    error_type="UserDeny"
elif echo "$error_lower" | grep -qE 'timeout|timed out|exceeded.*limit'; then
    error_type="Timeout"
elif [ -n "$exit_code" ] && [ "$exit_code" != "0" ] && [ "$exit_code" != "" ]; then
    error_type="NonZeroExit"
elif echo "$error_lower" | grep -qE 'logic|validation|invalid|assertion|expected.*got'; then
    error_type="LogicError"
else
    error_type="ToolError"
fi

# Truncate error message to 200 chars for the failure record
message=$(echo "$error" | head -c 200 | tr '\n' ' ')

"$LORE" fail "$error_type" "$message" \
    --tool "$tool" \
    --step "auto-captured by constraint-capture-failure hook" \
    --tags "auto-captured,constraint" \
    2>/dev/null || true

exit 0
