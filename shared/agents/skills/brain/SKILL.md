---
name: brain
description: How coding agents use Marcos's private notes vault (the "Brain") — where it lives, what may be read, the one folder agents write (Agent/), how agent notes are laid out and kept, and how to look up people, projects and terms. Use when reading or writing anything in the Brain, resolving a person, project or term, or deciding where an agent note goes.
---

The vault's location, what must never be read and how to look things up are machine-local: read
`~/.agents/AGENTS.local.md` first. The vault documents itself: its root `AGENTS.md` (folders,
boundaries, frontmatter) and `Agent/README.md` (the agent folder). Read both before writing.

## Rules

- Read what the vault's `AGENTS.md` allows; never read what `AGENTS.local.md` forbids.
- Write **only in `Agent/`**. A change anywhere else, even the vault's `AGENTS.md`, needs Marcos's
  explicit ok for that change, with the diff shown first.
- Actionables do not go in the vault: personal reminders go to Todoist, work tasks to the issue tracker.
- Resolve a person, project, channel or term with the lookup `AGENTS.local.md` names before any MCP
  search; with none or many matches, ask Marcos.

## Agent/

```
Agent/
├─ README.md                   how the folder works
├─ Method/                     how Marcos works with agents (every project)
├─ <Org>/                      rules for every repo of an organization (e.g. its PR policy)
└─ <Project>/
    ├─ Context.md              stable: repos, docs, issue tracker, traps
    └─ <EPIC> <name>/          one folder per epic or large task in progress
        ├─ State.md            live, short: phases, open items, decisions in force
        ├─ handoff.md          "where I am now" (skill handoff)
        └─ Runs/<STORY> <run> — decisions.md   orchestrator log (skill orchestrate)
```

- Write in en-US, file and folder names included (chat with Marcos stays pt-BR). Every note gets the
  frontmatter the vault's `AGENTS.md` defines.
- Start a session on an epic by reading its `handoff.md` and `State.md` (skill `handoff`).
- A new project or epic folder is created only after Marcos confirms its name.
- When a task, phase or epic ends, delete its folder (`/handoff close`); move what stays true to the
  repo, the issue tracker or the project's `Context.md`. Nothing about finished work stays.
- The issue tracker is the source of truth for execution; a lasting technical decision goes to the repo
  (RFC, ADR, reference), not here. Delete a note that lost its purpose; git keeps the history.
