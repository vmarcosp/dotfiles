# Begin copies METHOD and BACKLOG; the agent authors CONTEXT only

Status: accepted — amends [0006](0006-skill-scout-and-context-skills.md) (scout stays the
reconnaissance step; it does not author METHOD or BACKLOG). Depends on framework
[ADR-0006](https://github.com/getkoi/koi/blob/main/docs/adr/0006-method-and-backlog-filenames.md) (verbatim copy) and yokai
[ADR-0007](https://github.com/getkoi/koi/blob/main/crates/yokai/docs/adr/0007-init-config-wizard-and-begin-reconnaissance.md)
(`koi init` does not lay the markdown skeleton).

`METHOD.md` and `BACKLOG.md` are the same files for every project. `begin` copies them from this
skill's `templates/` with a filesystem copy, write-if-absent, and never reads or rewrites them.
`BACKLOG.template.md` is begin-ready: `Next action: /junji plan`, empty Tasks, no `###` headings
yokai would parse as phases. The agent only authors `CONTEXT.md` (reconnaissance + Skill scout).

## Why

Having the agent rewrite METHOD and BACKLOG wasted tokens on files that do not vary. Filling a
project name, stripping template examples, or baking `Next action` in the verb were all excuses to
regenerate ~150 lines. The templates *are* the files; CONTEXT is the only begin output that needs a
repo survey.

## Rejected

- **`koi init` lays METHOD/BACKLOG** — already rejected in yokai ADR-0007: driver writing
  skill-owned markdown, template drift in the binary, and `BACKLOG.md` present is both the
  live-project heuristic and the "run begin" dispatch signal.
- **Agent rewrites with a project name** — METHOD and BACKLOG are protocol and position chrome, not
  project identity. Orientation lives in CONTEXT › What this is.
- **Example phase headings in BACKLOG.template.md** — yokai parses every `### [status] P<n>` line as
  a real phase, including lines inside fences. Teaching examples belong in `verbs/refine.md`.
