---
description: Encode a correction or constraint into Lore's persistent memory
allowed-tools:
  - Bash(~/dev/lore/lore.sh *)
  - mcp__lore__lore_search
  - mcp__lore__lore_context
  - mcp__lore__lore_learn
  - mcp__lore__lore_remember
  - mcp__lore__lore_failures
---

## Task

$ARGUMENTS

Encode the correction or constraint from this conversation into Lore.
If $ARGUMENTS is empty, infer the constraint from the most recent correction
in the conversation.

## Workflow

### Step 1 — Recognition

Identify the constraint from the conversation:

- What did the user correct or reject?
- What was I doing that was wrong?
- What is the rule going forward?

State the constraint in one sentence using positive form
("Always X" or "Use X for Y" — not "Don't X").

### Step 2 — Check for duplicates

Search Lore before encoding:

```bash
~/dev/lore/lore.sh search "<key terms from the constraint>" 2>/dev/null
```

If a matching entry exists, report its ID and stop — do not create a duplicate.

### Step 3 — Classify and articulate

Classify the constraint into one of three types:

| Type         | When to use                              | Lore destination |
| ------------ | ---------------------------------------- | ---------------- |
| **Failure**  | I made a tool error or wrong action      | failures/        |
| **Pattern**  | A reusable rule about how to work        | patterns/        |
| **Decision** | A project-specific choice with rationale | journal/         |

### Step 4 — Encode

**Failure** (I did something wrong — e.g., used wrong command, took blocked action):

```bash
~/dev/lore/lore.sh fail UserDeny "<what happened>" \
    --tool "<tool if applicable>" \
    --step "<context>" \
    --tags "constraint,<project>"
```

**Pattern** (reusable rule about how to work):

```bash
~/dev/lore/lore.sh learn "<pattern name>" \
    --context "<when this applies>" \
    --solution "<what to do instead>" \
    --problem "<what goes wrong without this rule>" \
    --category "constraint" \
    --confidence 0.9
```

**Decision** (project-specific choice with rationale):

```bash
~/dev/lore/lore.sh remember "<decision text>" \
    --rationale "<why the user wants this>" \
    --type implementation \
    --tags "constraint,<project>"
```

### Step 5 — Confirm

Report: constraint type, Lore entry ID, and the one-sentence rule.

## Examples

- `/constrain` — infer from recent correction
- `/constrain Never use git add -A without checking git status first` — explicit
- `/constrain Use lore learn for reusable rules, lore remember for project decisions`
