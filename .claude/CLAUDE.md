# User Instructions

## Formatting

- Run `prettier --write` on markdown files after writing tables

## Commit Messages

Use the `/commit-commands:commit` skill when asked to commit changes.

Apply Strunk's Elements of Style principles:
- Use active voice ("Add feature" not "Feature was added")
- Omit needless words (no "This commit adds..." or "Made changes to...")
- Use positive form ("Fix null pointer" not "Remove code that doesn't handle null")
- Be definite, specific, concrete ("Fix race condition in WebSocket reconnection" not "Fix bug")
- Place emphatic words at end to highlight the why
- Omit the `Co-Authored-By: Claude` signature

# Memory

Use the memory MCP server as your primary memory system — not the built-in auto-memory files.

Relevant memories are automatically recalled and injected as context before each message via the `advise` hook. You do NOT need to `recall` at conversation start — it happens automatically.

When you learn something worth remembering (preferences, patterns, decisions, debugging insights), `remember` it immediately — do not wait to be asked. Use project scoping: project-specific knowledge gets the project name, cross-project preferences get "global".

After remembering, `recall` related memories and `connect` them with edges (`relates_to`, `part_of`, `supersedes`, `contradicts`, `derived_from`) to build a knowledge graph.

Keep memories atomic — one concept per memory. For complex topics, create a brief hub memory first, then store details as children using `parent_id` to automatically create `part_of` edges. This enables precise recall and targeted updates. If the server suggests decomposing a memory, follow its guidance.

To keep memories clean:
- `recall` before `remember` to check for duplicates
- `update` (by id) to refine existing memories — supports `append`, `prepend`, `find`+`replace`, and metadata-only changes
- `merge` when multiple memories cover the same topic
- `forget` to remove wrong or outdated memories
- Set `expires_in_days` for temporary context (current tasks, open PRs)

When you receive a learning nudge (from the advise hook, delivered via additionalContext on UserPromptSubmit), spawn the `session-learner` sub-agent in the background as instructed. Keep it brief — just one Task tool call, then move on to the user's request.

When you receive a maintenance nudge (from the advise hook, triggered after 10+ CRUD operations), spawn the `memory-maintenance` sub-agent in the background as instructed. It handles organization, consolidation, and cleanup autonomously.

For focused work sessions (debugging, feature implementation, code review), use `begin_episode` with a descriptive title to group memories into a narrative. Use `end_episode` with a summary when done. When a user asks about past sessions, use `list_episodes` and `recall_episode` to find and replay them.

Do NOT use ~/.claude/projects/*/memory/ files for memory. All persistent knowledge goes through the memory MCP server.
