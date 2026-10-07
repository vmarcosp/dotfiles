# Document types

How junji writes working-folder markdown. Types are **fixed by the method**, not chosen per
project. Grilling settles content; this file settles shape. No outline-approval step. Junji does
not generate tutorials. The `brief` verb is not a document type: it writes no file.

Always-on table lives in `SKILL.md › Documents`. Templates carry a one-line purpose; this file is
the writing SSOT.

## Types

| File | Type | Reader | Purpose |
|---|---|---|---|
| `PLAN.md` | explanation | human | Why this approach. Argument + rejected alternatives. |
| `CONTEXT.md` | reference | fresh window | Binding facts a window obeys. No rationale. Includes Skills. |
| `BACKLOG.md` | reference | fresh window | Position: Next action, phase list, carry-forward. |
| `DESIGN.md` | reference | window shipping UI | Binding visual / experiential tokens and rules. |
| research / design notes | reference | `plan` / `grill` / `design` / `iterate` | Cited findings. Claims only. |
| `METHOD.md` | how-to | `next` window | Recipe for one phase. Byte-copied by `begin`; never rewritten per project. |
| phase plan | how-to | Build loop / `iterate` | Contract for one slice: in/out, numbered approach, gate. |
| consolidate deliverable | host outline | later human | Follow CONTEXT › Deliverable spec model verbatim. Narrative default: explanation + locked facts, not a changelog. |

## Writing rules

1. **One purpose per file.** Explanation does not tell a window how to execute. Reference does not
   argue. How-to does not narrate history.
2. **Simple and checkable.** Short paragraphs or bullets. A later reader should be able to obey or
   reject a sentence without inferring.
3. **PLAN vs CONTEXT.** Rationale lives in PLAN. CONTEXT locked decisions are **fact-only**: the
   decision, not why. CONTEXT wins for execution; PLAN wins for the why.
4. **Notes are claims.** Research and design notes: what the source says, with a citation. No
   "so we should…".
5. **Phase plan is a contract.** Goal, Explicitly out, checklists stay. Approach is a **numbered
   recipe**, not an essay, not a tutorial.
6. **Consolidate is documentation.** Map Outcomes + locked decisions into the host outline. Drop
   risks that didn't fire, scaffolding, acceptance checklists. If no model is recorded, write
   what the system is + locked facts + a short phase story.

Do not mix execution facts into PLAN. Do not mix rationale into CONTEXT.

## Editing `.koi/run/CONTEXT.md`

`begin` copies `templates/CONTEXT.template.md` onto `.koi/run/CONTEXT.md`. Later edits change that
copy.

Read `.koi/run/CONTEXT.md` immediately before each edit. The old text is a contiguous span copied
from that read, whitespace and indentation included. A `context-file` block shows that template span
for a fresh copy. A fence inside a list is indented with that list; the indent is not part of the
span, and pasting the raw fence body misses. If the read no longer contains the span, edit the text
the read shows. `skills/junji/CONTEXT.md` and `crates/yokai/CONTEXT.md` are other files; their glossary
entries are not spans in the run file.

## Examples

**PLAN (explanation)**

Bad:
```
## Chosen approach
We will implement this in phases. First we scaffold, then we code, then we test.
See CONTEXT for the file map.
```

Good:
```
## Chosen approach
Keep the old parser on the read path until P4; new parser writes a parallel tree. We rejected a
big-bang cutover because rollback would mean restoring a deleted module.
```

**CONTEXT (reference)**

Bad:
```
- **Parser:** use a parallel tree — we picked this because rollback is easier than a cutover,
  and the team has been burned by flag-flip migrations before.
```

Good:
```
- **Parser:** old parser stays on the read path until P4; new parser writes a parallel tree.
```

**BACKLOG (reference)**

Bad:
```
We had a productive session. The next thing we should probably think about is refining, unless
you'd rather grill more.
```

Good:
```
**Next action:** `/junji refine`

### [todo] P0 - Port CLI entrypoint
Mirror `src/cli.rs`. Gate: language + repo sensors.
```

**DESIGN (reference)**

Bad:
```
## Atmosphere
The UI should feel modern, clean, and delightful, evoking trust and craft.
```

Good:
```
## Atmosphere
Yoru hour. Lacquer panels on iron ground. No drop shadows; atmosphere from color, not elevation.
```

**Findings note (research or design)**

Bad:
```
## Findings
The docs suggest we should probably use the v2 API, which means our plan ought to drop v1.
```

Good:
```
## Findings
v2 is the only documented write path; v1 write endpoints return 410 (source: API reference §4.2).

## Sources
- `https://…/api#v2` — v1 writes are gone; v2 is required.
```

**METHOD (how-to)**

Bad:
```
When you do the next task, keep in mind the philosophy of disposable windows and try to be
faithful to the spirit of the plan.
```

Good: the numbered 1-7 protocol already in the template: load, research, write the phase plan,
implement, verify, compact, commit. One action per step.

**Phase plan (how-to contract)**

Bad:
```
## Approach
We'll generally follow existing patterns and keep things idiomatic while porting this slice.
```

Good:
```
## Approach
1. Read `src/auth.ts` lines 40–90 (the session cookie path)
2. Mirror the cookie name + expiry into `internal/auth/session.go`
3. Add a table-test for missing/expired cookie
```

**Consolidate (host outline / narrative default)**

Bad:
```
## Phase 0
Created the folder. Had some issues with the linter. Fixed them. Checklist all green.

## Phase 1
…
```

Good:
```
## What this is
A parallel parser behind the old read path until cutover.

## Locked decisions
- Old parser stays on reads until P4.
```
