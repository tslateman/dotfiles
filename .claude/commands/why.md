---
description: Annotate a commit with rationale using git notes
allowed-tools: [Read, Bash(git log:*), Bash(git show:*), Bash(git notes:*), Bash(git diff:*)]
---

# Commit Rationale Annotation

## Context

- Current commit: !`git log --oneline -1`
- Changed files: !`git diff-tree --no-commit-id --name-only -r HEAD`

## Your Task

Annotate a commit with rationale using `git notes`. This captures the *why* behind
a commit without changing its SHA.

### Arguments

`${ARGUMENTS:-}` — Three usage patterns:

1. **No arguments** — Annotate HEAD interactively
2. **Commit hash** (e.g., `13fe234`) — Annotate specific commit
3. **Quick rationale** (quoted text) — Attach directly to HEAD

### Workflow

1. **Identify the target commit**
   - Use argument if provided and looks like a commit hash
   - Otherwise default to HEAD

2. **Show commit context**

   ```bash
   git show --stat <commit>
   ```

3. **Capture rationale**
   - If argument is quoted text, use it directly
   - Otherwise, ask the user for the rationale

4. **Create structured note**

   Format the note as:

   ```markdown
   ## Why

   [The rationale provided]

   ## Context

   - Date annotated: YYYY-MM-DD
   - Files changed: [list from commit]

   ## Alternatives

   [If user mentioned alternatives considered]

   ## Assumptions

   [If user mentioned assumptions made]
   ```

   Omit empty sections (Alternatives, Assumptions) if not provided.

5. **Store the note**

   ```bash
   git notes add -m "..." <commit>
   ```

   If a note already exists, ask whether to append (`git notes append`) or replace.

6. **Confirm and remind**
   - Show the stored note: `git notes show <commit>`
   - Remind: "Push notes with `git push origin refs/notes/commits` if sharing"

### Example Output

After running `/why "Chose polling over WebSockets for simplicity"`:

```text
Annotated 13fe234 with rationale.

## Why

Chose polling over WebSockets for simplicity

## Context

- Date annotated: 2025-01-15
- Files changed: src/api/sync.ts, src/config.ts

View with: git log --notes -1 13fe234
Push with: git push origin refs/notes/commits
```
