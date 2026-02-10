---
description: Reflect on recent work—capture learnings and surface what to think about next
allowed-tools: [AskUserQuestion, Read, Edit, Write]
---

Reflect on the work just completed in this conversation.

## What I Learned

Identify 2-4 concrete technical insights from this session:
- Patterns discovered or reinforced
- Gotchas or surprises encountered
- Techniques that worked well (or didn't)
- Connections to other parts of the codebase

Focus on *insights*, not a summary of actions taken.

## What to Think About Next

Surface 2-4 open threads worth considering:
- Unfinished work or TODOs
- Edge cases or risks not yet addressed
- Potential improvements or refactors
- Questions that came up but weren't resolved

Be specific—name files, functions, or concepts rather than speaking abstractly.

---

After generating the retro, ask the user if any insights are worth persisting to auto memory. Use AskUserQuestion with options like "Yes, update MEMORY.md" and "No, just this session".

If yes, read the current MEMORY.md from the project's auto memory directory and intelligently merge the new insights—don't duplicate existing points, add new ones under the appropriate sections.
