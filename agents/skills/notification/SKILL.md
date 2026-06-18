---
name: notification
description: >-
  Fires a native macOS notification (via terminal-notifier) to grab the user's attention when an autonomous flow
  needs them - a pending clarification, a human gate, the end of a long step, a failure. Takes a title, a
  message, an optional tone (info/alert), and an optional subtitle. Clicking the notification focuses Kitty.
  Use when a command, skill, or subagent needs to reach the user outside the chat window.
  Triggers: "/notification", "notify the user", "alert via macOS".
user-invocable: true
---

# notification

Fire one macOS notification. Always use the `bin/notification` script — it handles terminal-notifier, Kitty focus, and fallbacks.

```bash
notification "<title>" "<message>" [--tone info|alert] [--subtitle "<text>"] [--group <id>]
```

Options:
- `--tone alert` → Basso sound + default subtitle "Atenção necessária" (use for failures, blockers, unexpected events)
- `--tone info` → Glass sound (default, use for progress and gates)
- `--subtitle` → line below the title
- `--group` → group ID for deduplication/removal (default: `claude-code`)

To dismiss a notification programmatically after it's been acted on:
```bash
notification --remove [--group <id>]
```

Never let a missing notification block the flow. If `bin/notification` is not on PATH, fall back to:
```bash
osascript -e 'display notification "<message>" with title "<title>" sound name "<sound>"'
```
And if not on macOS, print `🔔 <title>: <message>` to chat and move on.
