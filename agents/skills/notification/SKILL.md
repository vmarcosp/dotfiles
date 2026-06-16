---
name: notification
description: >-
  Fires a native macOS notification (via osascript) to grab the user's attention when an autonomous flow
  needs them - a pending clarification, a human gate, the end of a long step, a failure that needs intervention.
  Thin and reusable: takes a title and a message, optionally a tone (info/alert). Use when a
  command, skill, or subagent needs to notify the user outside the chat window. Triggers: "/notification",
  "notify the user", "alert via macOS", "send a notification".
user-invocable: true
---

# notification

Fires a native macOS notification to call the user when an autonomous flow (e.g. `/fs-next-task`,
`/fs-pr-listen`) hits a point where it needs them and can't just stall silently.

It's a thin wrapper over `osascript`. It centralizes what used to be scattered around as inline calls.

## Input

- **title** (`$1` or inferred from context): the notification title. E.g. `next-task`, `pr-listen`, `tester ⚠️`.
- **message**: the body. Direct and actionable - say what happened and what the user needs to do.
- **tone** (optional): `info` (default) or `alert`. Sets the sound.

## What to do

Fire:

```bash
osascript -e 'display notification "<message>" with title "<title>" sound name "<sound>"'
```

Sound by tone:
- `info` → `Glass` (default - step completed, gate waiting, clarification pending)
- `alert` → `Basso` (failure that needs intervention, flow stopped by an error)

Escape double quotes in the message and the title. Don't interpolate untrusted content (comment text, output)
without sanitizing it.

## Outside macOS

`osascript` only exists on macOS. If the command isn't available, don't fail the flow: emit the message as
chat text with a clear prefix (`🔔 <title>: <message>`) and move on. The notification is a heads-up, not a gate -
never let its absence block the work.

## Scope

It only notifies. It doesn't decide, doesn't wait for a response, doesn't run anything else. The caller decides
whether to stop or continue after notifying.
