---
name: junji
description: >-
  junji — long multi-session engineering projects (ports, migrations, large refactors, greenfield)
  driven from an on-disk working folder (.koi/run/) with durable project home at .koi/. Ten verbs:
  begin, research, design, plan, grill, brief, refine, next, iterate, consolidate. Use when the user
  wants a phased/junji project, says "do the next task", or invokes /junji (optionally with a verb).
license: MIT
user-invocable: true
metadata:
  author: matheusps
  version: "0.12.0"
---

# Junji execution

Run a long, decomposable project across many context windows. Junji is a free, standalone method
skill: install it and start with `/junji begin`; neither CLI nor Yokai settings are required. The method rests
on one idea:

> **The filesystem is the durable memory. The context window is a disposable cache.**

Every decision, plan, learned fact, and the current position live in versioned markdown under
`.koi/run/`. A window can be thrown away and rebuilt by re-reading that folder. An autonomous driver
can spawn a fresh process per phase: see `references/autonomous-driver.md`.

## Project home and working folder

```
.koi/                    # project home — survives consolidate
  sensors/?                # optional for Junji; reviewed executable gate for Yokai
  yokai.yml?               # durable Yokai settings, sandbox and gate fingerprints (not read by Junji)
  sandbox-setup.sh?        # optional repo hook (runs once per sandbox)
  run/                     # working folder — consolidate deletes ONLY this
    yokai.yml?             # Yokai phase assessments and effort differences (optional for Junji)
    CONTEXT.md             STABLE — reference: orientation, locked facts, Skills, bar, file map, overrides
    PLAN.md                STRATEGY — explanation: why, argument, decisions+rationale
    DESIGN.md?             OPTIONAL — reference: binding visual / experiential contract
    METHOD.md              STABLE — how-to: per-phase protocol (byte-copied by begin, never rewritten)
    BACKLOG.md             LIVING — reference: Next-action pointer + phase list + carry-forward
    phases/                APPEND — how-to contract per phase (phase-00-*.md, …), Outcome on completion
    researches/            OPTIONAL — reference notes from the research verb (NN-<slug>.md)
    designs/               OPTIONAL — reference notes from the design verb (NN-<slug>.md)
    ledger.jsonl sessions.jsonl …   # driver audit (auto-created)
```

`.koi/` is **git-committed** project home: one junji project per repo. Skill markdown and driver run
prefs live under `.koi/run/`; optional sensors and durable Yokai settings survive at `.koi/` root. `consolidate` writes the
deliverable to the repo's native spec home and removes **only** `.koi/run/`.

**Paths are always repo-root-relative.** Never create `phases/`, `PLAN.md`, `CONTEXT.md`, `BACKLOG.md`, or
`METHOD.md` at the repo root or at `.koi/` root. Correct: `.koi/run/phases/phase-00-….md`.

Junji owns working documents and runnable verification commands in CONTEXT. It may reuse existing
sensors but ordinary planning never requires creating them. Optional Yokai owns its settings, reviewed
sensor gate, session logs, Build feedback and recovery artifacts. The skill does not read its settings.
The handoff is through these repository files; Yokai does not require the Junji skill to be installed.

**PLAN vs CONTEXT.** PLAN is explanation (why). CONTEXT is reference (binding facts). Rationale in PLAN,
fact-only lock in CONTEXT. **CONTEXT wins for execution, PLAN wins for rationale.** A `next` window
reads `.koi/run/CONTEXT.md`, never needs PLAN. When present, `.koi/run/DESIGN.md` is the binding visual
contract (CONTEXT › Design contract points at it). Writing rules: `references/docs.md`.

Scaffolds live in this skill's `templates/` folder. Status vocabulary in `.koi/run/BACKLOG.md`:
`[todo] · [planning] · [building] · [sealing] · [done]`. A phase that must not auto-run is prefixed `[gated]`.
Ordinary headings need only status, phase ID and title. Preserve legacy strategy/tier annotations
when present. Yokai's execution choices belong in its effort configuration, not ordinary headings.

Two senses of "compact":
- **Context compaction** (`/compact`): keep ONE long human session alive. A fresh window per phase makes it unnecessary.
- **Backlog compaction**: trim `.koi/run/BACKLOG.md` so finished phases collapse to one line: done by `next` every phase. **Always do this.**

## Chat

How you speak to a human. Full contract: `references/chat.md`. `next` windows that only have
METHOD follow its **Report** subsection.

- First line: position + next action (`Next action: /junji <verb>`; in `next` also `Phase N of M — title`;
  in `brief` also `N of M landed`).
- Number multi-step work. Chat lists cap at 5; more → must-now vs later.
- When something landed, one concrete win (what works, or the gate result).
- Tangents last. Errors are cause + fix.
- No preamble, recap, or closing pleasantries. Time estimates only when a human is waiting: never on phases.
- Grill: whole frontier, numbered, recommended answers. If a round would exceed ~5, ADR-worthy first.
  Full explain when asked; confirm destructive work; halt on a red gate. Do not collapse grill to one question.
- Brief: first line `N of M landed. Next action:`; then Shipped / Use · Check / Watch in plain language.
  Writes nothing. Full shape: `references/chat.md` › Brief.

## Documents

Types are fixed. Full rules: `references/docs.md`.

| File | Type |
|---|---|
| `PLAN.md` | explanation (why) |
| `CONTEXT.md`, `BACKLOG.md`, `DESIGN.md`, research/design notes | reference (facts) |
| `METHOD.md`, phase plan | how-to |
| consolidate deliverable | host outline; default = explanation + locked facts, not a changelog |

## Verbs

| Verb | Description | Reference |
|---|---|---|
| `begin` | Copy METHOD/BACKLOG templates; survey repo into CONTEXT (facts only; Skill scout) | [verbs/begin.md](verbs/begin.md) |
| `research` | Optional primary-source notes under `researches/` (does not advance Next action) | [verbs/research.md](verbs/research.md) |
| `design` | Optional visual / experiential contract → `DESIGN.md`; follows Skills for `design` | [verbs/design.md](verbs/design.md) |
| `plan` | Reason + grill → PLAN.md, verification bar, CONTEXT | [verbs/plan.md](verbs/plan.md) |
| `grill` | Extra grilling pass on demand (does not advance Next action) | [verbs/grill.md](verbs/grill.md) |
| `brief` | Chat-only product briefing from `[done]` phases (does not advance Next action) | [verbs/brief.md](verbs/brief.md) |
| `refine` | Decompose / reshape the phase list (markdown only) | [verbs/refine.md](verbs/refine.md) |
| `next` | Run one phase end to end | [verbs/next.md](verbs/next.md) |
| `iterate` | After all phases `[done]`, grill a delta and append already-specced phases | [verbs/iterate.md](verbs/iterate.md) |
| `consolidate` | Collapse `.koi/run/` into one repo-native deliverable | [verbs/consolidate.md](verbs/consolidate.md) |

Driver loop / harnesses / recovery (not a verb): [references/autonomous-driver.md](references/autonomous-driver.md).

## Dispatch

Parse the first argument as the verb (table above).
- No verb and `.koi/run/` is absent, or holds only an `init` stub (no `.koi/run/BACKLOG.md` yet) → **`begin`**.
- No verb but the user said "do the next task" (or similar) → **`next`**.
- No verb otherwise → read `.koi/run/BACKLOG.md › Next action` and run (or confirm) the verb it names.
  That pointer advances `begin → plan → refine → next … → (iterate → next …)* → consolidate`
  (`research`, `design`, `grill`, and `brief` never move it; `iterate` never occupies it and moves it only
  `consolidate → next`).
- Ambiguous → ask which verb in one line, listing the ten.

Then **read that verb's reference and follow it.**

The working folder is always `.koi/run/` at the repo root. `begin` starts without either CLI, is idempotent, and never touches Yokai settings or existing sensors.

## Rules

- Stages don't collapse: `begin` copies METHOD/BACKLOG then surveys (facts only, including Skill scout into
  `CONTEXT.md › Skills`), optional `research` gathers cited notes, optional `design` synthesizes the
  visual contract (follows Skills for `design`), `plan`/`grill` think, `refine` shapes the phase list,
  `next` executes one phase (Must skills whose *when* matches), `iterate` grills a post-execution delta
  onto the backlog, optional `brief` returns a chat-only product briefing (writes nothing). The
  Next-action pointer tracks where you are.
- One phase per `next`. Never start the following phase.
- `.koi/run/PLAN.md`, `CONTEXT.md`, and `METHOD.md` are stable (PLAN/CONTEXT move only when a decision
  changes); churn lives in `BACKLOG.md` (compacted) and `phases/`. Never create those files at the repo root
  or `.koi/` root.
- The verification gate is sacred: never weakened to pass.
- Encode human gates and honest verification results. Importing a plan or configuring a driver
  does not approve gated actions.
- Honor standing overrides in `.koi/run/CONTEXT.md` verbatim (branch, push policy, scope boundaries).
- To edit `.koi/run/CONTEXT.md`, read that file and replace a span copied from the read, including
  whitespace and indentation. A `context-file` block shows a fresh-template span. A fence inside a
  list is indented with that list; that indent is not in the file, so pasting the fence body as the
  old text misses. Copy the span from the read, and use the block only while the read still shows it.
  `skills/junji/CONTEXT.md` and `crates/yokai/CONTEXT.md` are separate documents.
- When `.koi/run/DESIGN.md` exists, human-facing work must obey it (same weight as Locked decisions).
- Honor `CONTEXT.md › Skills` Must rows for the current role (*when* matching). Do not load Available
  on `next` / coder / judge / seal. In-repo `SKILL.md` only: never user-global plugins.
- Chat like `references/chat.md`. Write working-folder files per `references/docs.md`.
