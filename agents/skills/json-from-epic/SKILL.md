---
name: json-from-epic
description: >-
  Generates or reconciles a .loop.json control file from an /epic markdown, so /fs-loop can drive the
  epic's tasks autonomously. Parses the stream task lines (id + depends_on), emits the queue, and on a
  re-run preserves existing status/pr/runtime. Use when setting up or refreshing an epic for the loop.
  Triggers: "/json-from-epic", "gerar loop.json do epic", "control file from epic".
user-invocable: true
---

# json-from-epic

Turn an `/epic` markdown into the `.loop.json` control file the `/fs-loop` conductor watches. The epic is the source of truth for which tasks exist and how they depend on each other; this file is the machine-readable queue with each task's live status.

## What it produces

`specs/epics/<epic>.loop.json`, beside the epic:

```jsonc
{
  "epic": "generate-store",
  "base": "main",
  "tasks": [
    { "id": "FSPG-764", "deps": [], "status": "pending", "pr": null },
    { "id": "FSPG-765", "deps": ["FSPG-764"], "status": "pending", "pr": null }
  ]
}
```

State model: `pending → in_progress → ready → merged`. A live task may carry a `runtime` block (per-comment anti-loop state); `/fs-loop` prunes it at merge.

## How to run

The work is deterministic — run the bundled script (you, the skill, drive it; the operator just invokes `/json-from-epic <epic>`). Resolve the epic path from the argument: an epic name resolves to `specs/epics/<name>.md`; a full path is used as-is.

```bash
bash ~/.claude/skills/json-from-epic/sync-loop-json.sh <path-to-epic.md>
```

This:
- **Generates** the file if it doesn't exist (every task `pending`).
- **Reconciles** if it does: adds new tasks, refreshes `deps`, and **preserves** each existing task's `status`/`pr`/`runtime`. It never downgrades a `merged`/`ready`/`in_progress` task back to `pending`.

It prints a one-line summary (task count + status breakdown + path). Report that to the user.

## After running

The script prints warnings to stderr — **relay them to the user**, don't swallow them:
- **`tasks removed from the epic (state lost): …`** — the reconcile dropped a task that was in the file (it may have carried `status`/`pr`/`runtime`). The epic is the source of truth, so it's gone; flag it so the user notices.
- **`deps referencing non-existent tasks …`** — a `depends_on` points at an ID no task has. That task would block the queue forever. The epic is malformed; tell the user to fix the `depends_on`.

Also: if zero tasks parsed (a sign the stream section format didn't match), show the user the parsed result and stop — don't write a broken queue.

## Notes

- The parser (`parse-epic.sh`) reads lines shaped like `- [ ] FSPG-764 — <title> → <spec>  ·  depends_on: [FSPG-..., ...]` in the epic's stream section. Checked (`[x]`) and unchecked (`[ ]`) lines both count.
- `base` is always `main` — no aggregating feature branch.
- Idempotent: safe to re-run after the epic changes (new tasks, edited deps).
