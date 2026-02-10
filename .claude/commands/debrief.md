---
description: Review what agents accomplished, surface loose ends across sessions
allowed-tools: [Bash, Read, Glob, Grep]
---

Consolidate work done by agents or across sessions. Review what landed and what's still open.

## 1. Recent Commits

Check what actually shipped:
```bash
git log --oneline -15 --all --decorate
```

Note any commits from agents or parallel work streams.

## 2. Work In Progress

Check for uncommitted changes or stashed work:
```bash
git status --short
git stash list
```

## 3. Synthesis

Produce a brief debrief:

### What Landed
- Summarize completed work (be specific—name files, features, fixes)

### Loose Ends
- Uncommitted work that needs attention
- Agent work that wasn't fully integrated
- TODOs or FIXMEs introduced

### Connections
- Note any overlap or conflicts between parallel work streams
- Flag if multiple changes touched the same files

### Next Actions
- Concrete steps to consolidate or continue the work

Keep it actionable. Skip anything that's already clean and integrated.