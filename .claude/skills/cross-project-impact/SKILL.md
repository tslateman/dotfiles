---
name: cross-project-impact
description: Trace how a change in one orchestration stack project (Ralph, Flow, Bach) affects the others. Invoke when editing contract-adjacent code — signal handling, state.json writes, task envelopes, worker dispatch, or iteration logic.
user-invocable: false
---

# Cross-Project Impact Analysis

## When to Activate

Trigger this analysis when a code change touches any of:

- `state.json` reads or writes
- `signal.*` field access or mutation
- `/flow:*` command handlers
- Task envelope construction or parsing
- Result envelope construction or parsing
- Worker dispatch logic
- Ralph iteration loop logic
- Bach template injection points

## Project Map

| Project | Role | Reads | Writes |
|---------|------|-------|--------|
| **Ralph** | Loop runner | `state.json` (signal fields) | Nothing — invokes `/flow:*` commands |
| **Flow** | Orchestrator | Task results from Bach | `state.json`, task envelopes |
| **Bach** | Worker pool | Task envelopes | Result envelopes |

Contracts:
- `flow/SIGNAL_CONTRACT.md` governs Ralph ↔ Flow
- `bach/TASK_CONTRACT.md` governs Flow → Bach

## Analysis Steps

### 1. Identify the change boundary

What project is being modified and which contract surface does it touch?

- **Signal surface**: `status`, `signal.action`, `signal.target`, `signal.ready`, `signal.blocked`
- **Task surface**: `id`, `worker`, `task`, `context.*`
- **Result surface**: `id`, `status`, `summary`, `artifacts`, `notes`, `reason`, `suggestion`

### 2. Trace downstream consumers

For each changed field or behavior, find the code in adjacent projects that depends on it:

| If you change... | Check... |
|------------------|----------|
| Flow's signal writes | Ralph's iteration logic (`ralph.sh`, `GSD_PROMPT.md`) |
| Flow's task envelope shape | Bach worker templates (`skills/`) |
| Bach's result envelope shape | Flow's result parsing in `/flow:execute` |
| Ralph's command invocation | Flow's command handlers (`commands/`) |
| Action vocabulary (new/removed action) | Both Ralph's dispatch and Flow's handlers |
| Worker vocabulary (new/removed worker) | Both Flow's dispatch and Bach's templates |
| Status vocabulary (new/removed status) | Both Bach's result logic and Flow's status handling |

### 3. Classify impact

For each downstream dependency found:

- **Breaking** — Consumer uses a field/value being removed or renamed
- **Silent failure** — Consumer ignores a new field it should handle (e.g., new status value falls through to default)
- **Compatible** — Change is additive and consumers handle unknowns gracefully

### 4. Report

```
## Impact: [project] → [project]

### [field or behavior changed]
- **Consumers**: [files that read this]
- **Impact**: Breaking | Silent failure | Compatible
- **Action needed**: [what the consumer must change, or "none"]
```

If no cross-project impact, say so explicitly — that's a useful signal too.
