---
name: notification
description: >-
  Fires a desktop notification to grab the user's attention when an autonomous flow
  needs them — a pending clarification, a human gate, the end of a long step, a failure.
  On macOS uses terminal-notifier (Ghostty focus). On Omarchy uses omarchy-notification-send.
  Triggers: "/notification", "notify the user", "alert via macOS", "alert via omarchy".
user-invocable: true
---

# notification

Always call `notification` on PATH (`macos/bin` or `omarchy/bin`, linked to `~/bin`).

```bash
notification "<title>" "<message>" [--tone info|alert] [--subtitle "<text>"] [--group <id>]
```

- `--tone alert` — urgent (Mac: Basso; Omarchy: critical)
- `--tone info` — default
- `--remove` — dismiss (Mac only)

If the script is missing: `osascript` on macOS; on Omarchy `omarchy-notification-send`; otherwise print `🔔 title: message` and continue.
