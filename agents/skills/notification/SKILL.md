---
name: notification
description: >-
  Fires a native macOS notification (via osascript) to grab the user's attention when an autonomous flow
  needs them - a pending clarification, a human gate, the end of a long step, a failure. Takes a title, a
  message, and an optional tone (info/alert). Use when a command, skill, or subagent needs to reach the user
  outside the chat window. Triggers: "/notification", "notify the user", "alert via macOS".
user-invocable: true
---

# notification

Fire one macOS notification. Escape double quotes in the title and message.

```bash
osascript -e 'display notification "<message>" with title "<title>" sound name "<sound>"'
```

Sound by tone: `info` (default) → `Glass`, `alert` → `Basso`.

Not on macOS? Print `🔔 <title>: <message>` to chat and move on - never let a missing notification block the flow.
