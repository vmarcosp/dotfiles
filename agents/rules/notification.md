---
alwaysApply: true
---

Notify the user with `/notification` when you need them outside the chat window. Do not wait silently for a reply if the flow is blocked.

## When to notify

- **Permission needed** — a destructive action, credential, or approval gate blocks progress
- **Decision needed** — ambiguous requirements, multiple valid approaches, or missing context
- **Unblock needed** — CI failure, auth error, or external dependency only the user can fix
- **Long step done** — a multi-minute autonomous run finished and needs review
- **Failure or surprise** — an unexpected error, regression, or result that changes the plan

## Tone

- `--tone info` (default) — progress updates, gates, and "ready for review"
- `--tone alert` — failures, blockers, and urgent decisions

## Examples

```bash
notification "Permission needed" "Delete branch feature/old-api?" --tone alert
notification "Decision needed" "Use Redis or in-memory cache for rate limiting?" --tone info
notification "CI blocked" "Lint failed on main — need your call before retrying push" --tone alert
notification "Done" "Refactor complete — 12 files changed, tests green" --tone info
```

Never let a missing notification script block the flow. Fall back to `osascript` on macOS, or print `🔔 <title>: <message>` elsewhere.
