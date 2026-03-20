# Issue Taxonomy

Severity levels and per-page exploration checklist for the QA find phase.

## Severity levels

| Level    | Code | Criteria                                                        | Action              |
| -------- | ---- | --------------------------------------------------------------- | ------------------- |
| Critical | P0   | App crashes, data loss, security vulnerability                  | Fix immediately     |
| Major    | P1   | Core flow broken, wrong data displayed, JS errors in happy path | Fix in this session |
| Minor    | P2   | UI glitch, broken link, cosmetic issue, edge case failure       | Fix if time allows  |
| Nit      | P3   | Typo, alignment off by pixels, style inconsistency              | Log, don't fix      |

## Per-page exploration checklist

Run through this checklist on each page or view visited during the find phase.

### Structure

- [ ] Page loads without JS errors (check console error trap)
- [ ] All images load (no broken images)
- [ ] All links resolve (no 404s from visible links)
- [ ] Page title and headings are correct

### Forms

- [ ] Required fields are validated before submission
- [ ] Submitting with valid data succeeds
- [ ] Submitting with empty required fields shows errors
- [ ] Error messages are specific (not generic "an error occurred")

### Navigation

- [ ] All nav links work and go to the right place
- [ ] Browser back button works correctly after navigation
- [ ] Deep links (direct URL) load the correct content

### Data

- [ ] Lists display correct data (not empty when should have items)
- [ ] Create/update/delete operations persist
- [ ] Empty states are handled (no blank screens)
- [ ] Loading states exist for async operations

### Interaction

- [ ] Buttons are clickable and respond
- [ ] Hover states exist where expected
- [ ] Keyboard navigation works for critical flows
- [ ] No duplicate submissions on double-click

### Responsive (if applicable)

- [ ] Content doesn't overflow on narrow viewports
- [ ] Touch targets are large enough on mobile
- [ ] No horizontal scrollbar on mobile

## Issue template

When documenting a found issue:

```markdown
### [P{level}] {Short description}

**Page:** {URL or route}
**Steps to reproduce:**

1. {step}
2. {step}
3. {step}

**Expected:** {what should happen}
**Actual:** {what happens instead}
**Console errors:** {if any}
```

## Triage rules

- Fix P0 and P1 issues. These affect the core user experience.
- Fix P2 issues if the fix is quick (< 5 minutes) and low-risk.
- Log P3 issues in the report but don't fix them.
- When two issues have the same severity, fix the one in the more critical
  user flow first.
- If a fix risks breaking something else, note it and skip — don't introduce
  new bugs.
