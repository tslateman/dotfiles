---
name: qa
description: >
  Find-fix-verify-regress loop for web apps using Chrome MCP. Use when asked to
  "qa this", "test the app", "find bugs", "does this work in the browser",
  "check the UI", "smoke test". Navigates the app, finds bugs, fixes code,
  verifies fixes, writes regression tests.
argument-hint: "<URL> [--find-only] [--skip-regress] [--scope 'flow name']"
---

# QA: Find-Fix-Verify-Regress

Browser-driven QA loop for web applications. Uses Chrome MCP to interact with
the running app, finds bugs, fixes them in code, verifies fixes in the browser,
and writes regression tests.

## Arguments

| Arg              | Effect                               |
| ---------------- | ------------------------------------ |
| `<URL>`          | Target URL (auto-detect if omitted)  |
| `--find-only`    | Report bugs without fixing           |
| `--skip-regress` | Skip regression test writing         |
| `--scope "X"`    | Limit exploration to a specific flow |

## Setup

Before starting the QA loop:

1. **Parse arguments**: extract URL, flags, and scope from the user's input
2. **Detect dev server**: if no URL provided, look for running dev servers
   (check `package.json` scripts, look for common ports 3000/5173/8080)
3. **Detect test framework**: scan for `jest.config`, `vitest.config`,
   `playwright.config`, `cypress.config`, `*.test.*` files — needed for
   Phase 4
4. **Check working tree**: run `git status` — warn if dirty, recommend
   committing first so QA fixes are isolated
5. **Install console error trap**: navigate to the URL and inject the error
   listener (see `references/chrome-mcp-patterns.md`)

## Phase 1: Find

**Tools**: Chrome MCP only (read-only browser, read-only code)

**Goal**: Systematically explore the app and document every issue found.

### Process

1. **Orient**: navigate to the target URL. Use `javascript_tool` to gather
   page structure (links, forms, headings). Build a mental map of the app's
   routes and flows.

2. **Explore systematically**: visit each page/route. At each page, run
   through the per-page checklist in `references/issue-taxonomy.md`:
   - Check for JS console errors
   - Check for broken images and links
   - Test forms (submit empty, submit valid)
   - Test navigation (links, back button)
   - Check data display (empty states, loading states)
   - Test interactions (buttons, keyboard)

3. **Scope**: if `--scope` is set, limit exploration to that flow. Otherwise,
   explore breadth-first starting from the landing page, following links.

4. **Document issues**: for each bug found, record it using the issue template
   from `references/issue-taxonomy.md`. Include severity, page, repro steps,
   expected vs actual behavior, and any console errors.

5. **Summary**: after exploration, present the full issue list sorted by
   severity (P0 first).

**If `--find-only` is set**: output the report and stop here.

## Phase 2: Fix

**Tools**: Code tools only (Read, Grep, Glob, Edit, Write, Bash)

**Goal**: Fix P0 and P1 issues. Fix P2 if quick and safe.

### Process

1. **Triage**: review the issue list. Apply the triage rules from
   `references/issue-taxonomy.md`. Announce which issues you'll fix and which
   you'll skip (with reason).

2. **Fix loop** (for each issue to fix):
   a. Read the relevant source code — trace from the UI symptom to the code
   b. Identify the root cause
   c. Write the fix (minimal, targeted change)
   d. Commit the fix: one commit per issue, message references the issue
   (`fix: P1 — broken form validation on /settings`)

3. **If a fix is risky** (could break other functionality): note it in the
   report and skip. Don't introduce new bugs.

## Phase 3: Verify

**Tools**: Chrome MCP only (re-run repro steps)

**Goal**: Confirm each fix works in the browser.

### Process

1. **Reload**: if the dev server supports hot reload, wait for it. Otherwise,
   hard-refresh the page.

2. **Re-run repro steps**: for each fixed issue, follow the exact reproduction
   steps from Phase 1. Use the same Chrome MCP tools.

3. **Classify each fix**:
   - **Verified**: repro steps no longer reproduce the issue
   - **Best-effort**: fix applied but can't fully verify in browser (e.g.,
     race condition, server-side issue)
   - **Reverted**: fix didn't work or introduced new issues — revert the
     commit (`git revert HEAD`)

4. **Check for regressions**: after verifying fixes, do a quick pass through
   the pages you visited in Phase 1. Look for new issues introduced by fixes.

## Phase 4: Regress

**Tools**: Code tools only (write tests, run tests)

**Goal**: Write regression tests for each verified fix.

**If `--skip-regress` is set**: skip this phase.

### Process

1. **Detect conventions**: read existing test files to understand the project's
   testing patterns (imports, assertions, file naming, test structure).

2. **Write tests**: for each verified fix, write a regression test that:
   - Reproduces the original bug condition
   - Asserts the correct behavior
   - Uses the project's existing test patterns

3. **Run tests**: execute the test suite. Fix any test failures.

4. **Commit**: commit all regression tests in a single commit
   (`test: regression tests for QA fixes`).

## Report

After all phases, output a structured report:

```markdown
## QA Report: {App Name or URL}

**Date:** {YYYY-MM-DD}
**Scope:** {full app | specific flow}
**URL:** {target URL}

### Issues Found: {count}

| #   | Sev | Description   | Status  |
| --- | --- | ------------- | ------- |
| 1   | P0  | {description} | Fixed ✓ |
| 2   | P1  | {description} | Fixed ✓ |
| 3   | P2  | {description} | Skipped |

### Fixes

{For each fix: what was wrong, what was changed, commit hash}

### Regression Tests

{List of test files created/modified}

### Remaining Issues

{Any unfixed P2/P3 issues for the user to review}
```

## Anti-patterns

- **Fixing code during the Find phase**: keep phases separate. Find first,
  fix second. Mixing them loses track of the full issue list.
- **Fixing P3 nits**: not worth the risk. Log them and move on.
- **Skipping verification**: always re-check fixes in the browser. A code
  change that looks right might not render correctly.
- **Giant commits**: one commit per fix. If a fix needs to be reverted, it
  should be isolated.
- **Modifying test infrastructure**: write tests using existing patterns. Don't
  add new test frameworks or change test config during a QA session.

## See also

- `references/chrome-mcp-patterns.md` — Chrome MCP tool recipes
- `references/issue-taxonomy.md` — severity levels and checklists
