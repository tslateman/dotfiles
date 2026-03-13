#!/bin/bash
# Session summary hook — displays stats on quit, inspired by Gemini CLI
# Runs on SessionEnd, writes directly to /dev/tty since Claude Code's UI
# is already torn down when this fires.

export HOOK_INPUT=$(cat 2>/dev/null)
[ -z "$HOOK_INPUT" ] && exit 0

python3 - << 'PYEOF'
import json, sys, os
from datetime import datetime

raw = os.environ.get("HOOK_INPUT", "")
try:
    hook_input = json.loads(raw)
except:
    sys.exit(0)

transcript = hook_input.get("transcript_path", "")
session_id = hook_input.get("session_id", "")[:8]

if not transcript or not os.path.isfile(transcript):
    sys.exit(0)

tool_uses = 0
tool_ok = 0
tool_err = 0
models = {}
first_ts = None
last_ts = None
files_touched = set()

with open(transcript) as f:
    for line in f:
        try:
            obj = json.loads(line)
        except:
            continue

        ts = obj.get("timestamp")
        if ts and isinstance(ts, str):
            if first_ts is None:
                first_ts = ts
            last_ts = ts

        msg = obj.get("message", {})
        if not isinstance(msg, dict):
            continue

        if msg.get("role") == "assistant":
            model = msg.get("model", "")
            if model:
                models[model] = models.get(model, 0) + 1
            for c in msg.get("content", []):
                if isinstance(c, dict) and c.get("type") == "tool_use":
                    tool_uses += 1
                    name = c.get("name", "")
                    inp = c.get("input", {})
                    if name in ("Write", "Edit") and isinstance(inp, dict):
                        fp = inp.get("file_path", "")
                        if fp:
                            files_touched.add(fp)

        if obj.get("type") == "user" or msg.get("role") == "user":
            content = msg.get("content", [])
            if isinstance(content, list):
                for c in content:
                    if isinstance(c, dict) and c.get("type") == "tool_result":
                        if c.get("is_error"):
                            tool_err += 1
                        else:
                            tool_ok += 1

if tool_uses == 0:
    sys.exit(0)

# Duration
duration = "\u2014"
if first_ts and last_ts:
    try:
        t1 = datetime.fromisoformat(first_ts.replace("Z", "+00:00"))
        t2 = datetime.fromisoformat(last_ts.replace("Z", "+00:00"))
        secs = int((t2 - t1).total_seconds())
        if secs >= 3600:
            duration = f"{secs // 3600}h {(secs % 3600) // 60}m {secs % 60}s"
        elif secs >= 60:
            duration = f"{secs // 60}m {secs % 60}s"
        else:
            duration = f"{secs}s"
    except:
        pass

# Success rate
rate = f"{(tool_ok / tool_uses) * 100:.0f}%" if tool_uses > 0 else "\u2014"

# Model display
model_str = ", ".join(
    f"{m} ({n})" for m, n in sorted(models.items(), key=lambda x: -x[1])
)

# Colors
DIM = "\033[2m"
BOLD = "\033[1m"
CYAN = "\033[36m"
GREEN = "\033[32m"
RED = "\033[31m"
YELLOW = "\033[33m"
R = "\033[0m"

W = 60
line = f"{DIM}{'─' * W}{R}"

rows = []
rows.append(f"  {CYAN}{'Session:':<20}{R} {session_id}")
rows.append(f"  {CYAN}{'Duration:':<20}{R} {duration}")
rows.append(f"  {CYAN}{'Tool calls:':<20}{R} {tool_uses}  ( {GREEN}\u2713 {tool_ok}{R}  {RED}\u2717 {tool_err}{R} )")
rows.append(f"  {CYAN}{'Success rate:':<20}{R} {rate}")
if files_touched:
    rows.append(f"  {CYAN}{'Files touched:':<20}{R} {len(files_touched)}")
rows.append(f"  {CYAN}{'Model:':<20}{R} {DIM}{model_str}{R}")

# Write directly to /dev/tty — Claude Code's UI is gone by SessionEnd
try:
    tty = open("/dev/tty", "w")
except:
    sys.exit(0)

tty.write("\n")
tty.write(f"{DIM}{BOLD}Session complete.{R}\n")
tty.write(line + "\n")
tty.write("\n")
for row in rows:
    tty.write(row + "\n")
tty.write("\n")
tty.write(f"  {DIM}Tip: Resume with {R}{YELLOW}claude --continue{R}{DIM} or {R}{YELLOW}/resume{R}\n")
tty.write(line + "\n")
tty.write("\n")
tty.close()
PYEOF

exit 0
