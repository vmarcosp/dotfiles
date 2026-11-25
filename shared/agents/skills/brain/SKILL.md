---
name: brain
description: Map of Marcos's Obsidian vault (~/projects/brain) for coding agents — what each folder holds, the one folder agents may write (Agent/), what never to read, frontmatter, and how to look up people, projects and channels. Use when reading or writing anything in the Brain, resolving a person, project, channel or VTEX term, or deciding where an agent note goes.
---

The vault is `~/projects/brain` (private, git-synced). It is Marcos's work vault, kept mostly by his
Hermes agent **Atena**. Coding agents (Claude Code, Cursor) read the whole vault and write **only in
`Agent/`**. The vault's own rules are in `~/projects/brain/AGENTS.md`; read it before writing.

## Never

- Read `Terapia*`, `Interview*`, `Debrief*` files or any `.env`.
- Write outside `Agent/`. A change elsewhere (even the vault `AGENTS.md`) needs Marcos's explicit ok
  for that change, with the diff shown first.
- Create folders the vault says not to: `References/`, `Proposals/`, `Inbox/`, `Garden/`, `Agents/`.
- Put actionables in the vault: they go to Todoist (`td`, skill `todoist-cli`). Work tasks go to Jira.

## Looking things up

- Person, Slack channel, project, repo or VTEX term: run `~/.hermes/scripts/brain` first, e.g.
  `~/.hermes/scripts/brain person Davis`. Use Slack/Jira/Confluence MCPs only when it has no match or
  live data is needed. With none or many matches, ask Marcos.
- Ambiguous names or acronyms: `CONTEXT.md`. People and projects: `Atena/Context/People.md`,
  `Atena/Context/Projects.md`.

## Folders

| Folder | Holds | Agents |
|---|---|---|
| `Agent/` | Coding agents' working notes: method, project context, epic state, handoffs, run logs | read + write |
| `Atena/Context/` | People and Projects directory | read |
| `Atena/Memory/` | Atena's sessions and reviews | read |
| `Library/Notes/` | Ideas, references, proposals, long docs | read |
| `Library/Researches/` | Agent research outputs | read |
| `Library/Mentorias/`, `Library/Drawings/` | Mentoring, Excalidraw | read |
| `Career/` | Goals, brag doc, cycles | read |
| `Journal/Meetings/`, `Journal/Daily/` | Meetings and dailies | read |
| `Templates/`, `Excalidraw/` | Templates and drawings | read |

## Agent/

```
Agent/
├─ README.md                   how the folder works
├─ Method/                     how Marcos works with agents (all projects)
└─ <Project>/                  e.g. VTEX Studio/
    ├─ Context.md             stable: repos, docs, Jira, traps
    └─ <EPIC> <name>/         e.g. FSPG-1234 Epic name/
        ├─ State.md           live, short: phases, open items, decisions in force
        ├─ handoff.md          "where I am now" (skill handoff)
        └─ Runs/<STORY> <run> — decisions.md   orchestrator log (skill orchestrate)
```

- Write in en-US (chat with Marcos stays pt-BR). Every note gets frontmatter `date: YYYY-MM-DD` and
  `type: notes`. When a task, phase or epic ends, delete its folder; move what stays true to the repo,
  Jira or the project's `Context.md`.
- Start a session on an epic by reading its `handoff.md` and `State.md` (skill `handoff`).
- A new project or epic folder is created only after Marcos confirms its name.
- Jira is the source of truth for execution; a lasting technical decision goes to the repo (RFC, ADR,
  reference), not here. Delete a note that lost its purpose; git keeps the history.
