#!/bin/bash
# Notify cmux and reset sidebar state when Claude Code stops
[ -z "$CMUX_WORKSPACE_ID" ] && exit 0

CMUX=/Applications/cmux.app/Contents/Resources/bin/cmux
[ ! -x "$CMUX" ] && exit 0

INPUT=$(cat 2>/dev/null)

# Parse stop reason for sidebar state update
STOP_REASON="end_turn"
if [ -n "$INPUT" ]; then
    STOP_REASON=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('stop_reason', 'end_turn'))
except:
    print('end_turn')
" 2>/dev/null)
fi

# Clear tool status
"$CMUX" clear-status tool 2>/dev/null || true

if [ "$STOP_REASON" = "end_turn" ]; then
    "$CMUX" set-status state "Done" --color "#50c878" 2>/dev/null || true
    "$CMUX" set-progress 1.0 2>/dev/null || true
    rm -f "/tmp/cmux-progress-${CMUX_SURFACE_ID:-default}"
fi

# Fire the native claude-hook stop (triggers notification ring in cmux sidebar)
echo "$INPUT" | "$CMUX" claude-hook stop 2>/dev/null || true
