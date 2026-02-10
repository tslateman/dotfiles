---
description: Generate an Architecture Decision Record from current context
allowed-tools: [Read, Glob, Grep, Write, Bash(git log:*), Bash(git diff:*)]
---

# Architecture Decision Record Generator

## Context

- Current directory: !`pwd`
- Recent commits: !`git log --oneline -5`
- Changed files: !`git diff --name-only HEAD~3 2>/dev/null || echo "No recent changes"`

## Your Task

Generate an Architecture Decision Record (ADR) based on the conversation context and any architectural decisions discussed.

### ADR Format

Create a markdown file with this structure:

```markdown
# ADR-[NUMBER]: [TITLE]

**Date:** [YYYY-MM-DD]
**Status:** [Proposed | Accepted | Deprecated | Superseded]
**Deciders:** [Who was involved]

## Context

What is the issue that we're seeing that is motivating this decision or change?

## Decision

What is the change that we're proposing and/or doing?

## Consequences

What becomes easier or more difficult to do because of this change?

### Positive
- [Benefit 1]
- [Benefit 2]

### Negative
- [Trade-off 1]
- [Trade-off 2]

### Risks
- [Risk and mitigation]

## Alternatives Considered

### [Alternative 1]
- **Description:** What was this option?
- **Rejected because:** Why didn't we choose it?

### [Alternative 2]
- **Description:** What was this option?
- **Rejected because:** Why didn't we choose it?

## References

- [Related PR, issue, or document]
- [Relevant discussion or prior art]
```

### Instructions

1. **Extract from context** — Use the conversation to identify:
   - The problem or decision being made
   - Options that were discussed
   - The chosen approach and rationale
   - Trade-offs acknowledged

2. **Find the ADR location** — Look for existing ADRs:
   - `docs/adr/` or `docs/decisions/`
   - `adr/` at project root
   - If none exist, suggest creating `docs/adr/`

3. **Number appropriately** — Check existing ADRs and use the next number

4. **Write concisely** — ADRs should be scannable:
   - Context: 2-4 sentences
   - Decision: 1-2 sentences
   - Consequences: Bullet points
   - Alternatives: Brief, focused on why rejected

5. **Capture the why** — The decision itself ages; the reasoning stays valuable

### Arguments

`${ARGUMENTS:-}` — Optional: specific decision to document, or path for the ADR

If no arguments provided, infer the decision from recent conversation context.
