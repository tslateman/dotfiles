# Chrome MCP Tool Patterns

Reference for browser automation during QA phases.

## Tool mapping

| Action                 | Tool                                      | Notes                                         |
| ---------------------- | ----------------------------------------- | --------------------------------------------- |
| Navigate to URL        | `mcp__claude-in-chrome__navigate`         | Takes `url` parameter                         |
| List open tabs         | `mcp__claude-in-chrome__tabs_context_mcp` | Returns tab IDs, URLs, titles                 |
| Open new tab           | `mcp__claude-in-chrome__tabs_create_mcp`  | Takes `url` parameter                         |
| Execute JS / DOM query | `mcp__claude-in-chrome__javascript_tool`  | Runs arbitrary JS in page context             |
| Click / type / keys    | `mcp__claude-in-chrome__computer`         | Physical interactions via coordinates or keys |

## Key patterns

### Batch DOM queries

Use `javascript_tool` to gather multiple signals in one call:

```javascript
({
  links: [...document.querySelectorAll("a")].map((a) => ({
    text: a.textContent.trim(),
    href: a.href,
    visible: a.offsetParent !== null,
  })),
  forms: [...document.querySelectorAll("form")].map((f) => ({
    action: f.action,
    method: f.method,
    inputs: [...f.querySelectorAll("input,select,textarea")].map((i) => ({
      name: i.name,
      type: i.type,
      value: i.value,
      required: i.required,
    })),
  })),
  consoleErrors: window.__qaErrors || [],
  title: document.title,
  url: location.href,
});
```

### Install console error trap

Run this early to capture JS errors during the session:

```javascript
window.__qaErrors = window.__qaErrors || [];
window.addEventListener("error", (e) =>
  window.__qaErrors.push({
    message: e.message,
    source: e.filename,
    line: e.lineno,
    col: e.colno,
  }),
);
window.addEventListener("unhandledrejection", (e) =>
  window.__qaErrors.push({
    message: String(e.reason),
    type: "unhandledrejection",
  }),
);
```

### Check for broken images

```javascript
[...document.querySelectorAll("img")]
  .filter((img) => !img.complete || img.naturalWidth === 0)
  .map((img) => ({ src: img.src, alt: img.alt }));
```

### Get computed styles for visibility checks

```javascript
function isVisible(el) {
  const style = getComputedStyle(el);
  return (
    style.display !== "none" &&
    style.visibility !== "hidden" &&
    style.opacity !== "0" &&
    el.offsetParent !== null
  );
}
```

### Form interaction pattern

1. Use `javascript_tool` to find the form and its fields
2. Use `computer` to click into each field and type values
3. Use `computer` to submit (click button or press Enter)
4. Use `javascript_tool` to check the result (URL change, DOM change, errors)

### Navigation + wait pattern

1. `navigate` to the URL
2. `javascript_tool` to check `document.readyState === 'complete'`
3. Optionally wait for a specific selector:
   ```javascript
   document.querySelector(".main-content") !== null;
   ```

### Screenshot via computer tool

Use `computer` with action `screenshot` to capture the current viewport state.
Useful for documenting visual bugs before and after fixes.

## Anti-patterns

- **Don't chain rapid navigations** — wait for page load between each
- **Don't use javascript_tool for clicks** — use `computer` for physical
  interactions (clicks, typing) so the app's event handlers fire correctly
- **Don't assume element positions** — query coordinates via `javascript_tool`
  (getBoundingClientRect), then click via `computer`
- **Don't forget to check console errors** — install the error trap early and
  check it at each page
