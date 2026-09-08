---
name: phasing
description: >-
  Turns settled PRD/TDD/ADR scope into an ordered set of phases, each sized
  to be exactly one /spec (one Approach, one Verify surface, one PR),
  organized as a dependency graph so parallel streams fall out of real
  technical dependency instead of being guessed upfront. Writes the roadmap
  to docs/roadmaps/<slug>/roadmap.md; each phase becomes its own /spec
  afterward. Use when the user wants to break a feature or system into
  phases, plan a rollout across multiple PRs, or invokes /phasing.
disable-model-invocation: true
license: MIT
metadata:
  author: Marcos Oliveira
  version: "1.2.0"
---

# Phasing — Roadmap from Anchor Docs

Turns PRD/TDD/ADR scope into an ordered set of phases — each phase sized to be exactly one `/spec`: one Approach, one Verify surface, one reviewable PR. Streams are not guessed upfront; they fall out of a dependency graph between phases. Invoke explicitly with /phasing.

## Layout

A roadmap is never a single file — one durable doc plus per-phase carry-over fragments, both scoped to the same slug:

```
docs/roadmaps/<slug>/
├── roadmap.md                 (Step 8 — the durable doc, Sync updates it in place)
├── carryover-phase-1.md       (written by Phase 1's /implement, deleted once absorbed)
└── carryover-phase-4.md       (written by Phase 4's /implement, deleted once absorbed)
```

## When NOT to apply

- No PRD/TDD/ADR exist yet, or the idea itself is unsettled — run `/brainstorm` and the anchor-doc skills first; phasing needs settled scope to cut, not an open question.
- The work already passes `/spec`'s own boundary test (one sentence, one Approach, Steps with no forward reference) — just run `/spec` directly, phasing a single change adds nothing.
- Cutting the scope produces exactly one phase — same as above, skip straight to `/spec`.

## Two modes

- **Create** — no roadmap exists yet for this scope. Cut phases from anchor docs for the first time.
- **Sync** — a roadmap already exists. Absorb pending carry-over fragments, revalidate the dependency graph, fold in any newly discovered phase. **Trigger:** an `/implement` run flags a fragment written in its delivery summary — run Sync before the next wave of phases starts. An unabsorbed fragment blocks nothing (`/spec` reads pending fragments directly), but the graph and streams only reflect corrections after Sync absorbs them.

## Step 1: Determine scope and mode

Name the boundary — which PRD/TDD/ADR this roadmap covers, and derive its slug. Search for an existing roadmaps root, in order: `docs/roadmaps/`, `docs/roadmap/`, `roadmaps/`. Every roadmap gets its own subfolder under that root — `<root>/<slug>/` — because a roadmap is never a single file: it's one durable doc plus per-phase carry-over fragments, unlike PRD/TDD/ADR/spec which are always one file.

- **Root found, and `<root>/<slug>/roadmap.md` exists** → **Sync** mode. Read it fully.
- **Root found, no `<root>/<slug>/` for this scope** → **Create** mode, create `<root>/<slug>/`.
- **No root found** → propose `docs/roadmaps/` as the default root, and use the AskQuestion tool so the user can confirm it or name a different path. Do not create any file or directory before they answer. **Create** mode.

**Completion criterion:** the scope is named, the mode (Create/Sync) is known, and `<root>/<slug>/` exists on disk (create it once approved).

## Step 2: Gather anchor docs

Search `docs/prds/`, `docs/tdds/`, `docs/adrs/` (same locations `/spec` Step 3 uses) for anything touching this scope. Read each in full — these are inputs, not content to duplicate.

- **PRD** — goals, user stories: what the finished scope must do.
- **TDD** — Building Blocks: the natural fault lines between phases live here, not in the PRD.
- **ADR** — binding constraints. An Accepted ADR can force an ordering (e.g. "must migrate to Postgres before X") — treat it the same way `/spec` treats ADRs: non-negotiable on the cut.

**Sync mode only:** also locate every `carryover-phase-*.md` fragment inside `<root>/<slug>/` — these get absorbed in Step 7, not re-derived.

**Completion criterion:** every anchor doc touching this scope is read in full; in Sync mode, every pending fragment is located before cutting continues.

## Step 3: Cut phases

Apply `/spec`'s own boundary test to the gathered scope — reuse it, don't reinvent a size rule:

- Can what changes be stated in one sentence, without an "and"?
- Does it resolve to one Approach, not several unrelated technical decisions?
- Does it stay inside one (or a few tightly related) TDD Building Block, not span independent ones?
- Is it non-trivial (more than one file, a real decision to record)?

A phase that already passes all four can be a whole feature — don't split further just because it's called "a feature." Split only where the answer to one of these genuinely flips: a different Approach, a different Building Block, or a Verify that couldn't isolate what broke if bundled.

Each phase that survives the test gets a **contract** — the material its block carries in Step 8:

- **Goal** — one or two sentences: what changes when this ships.
- **In / Out** — the boundary. The Out line names the sibling phase that owns each deferred piece ("the real adapter (#8)") — the seams between phases live here and nowhere else.
- **Source** — the anchor-doc sections (full heading paths) this phase implements; the phase's `/spec` derives its Success criteria from exactly these.
- **Notes for the spec** — optional: facts the `/spec` could not infer (a pending POC, a cross-phase constraint). Requirements, steps, and acceptance criteria stay out — the phase's `/spec` authors those.

**Completion criterion:** every phase passes all four checks and carries Goal, In/Out, and Source; every deferred piece in an Out line names its owning phase; nothing is split "for tidiness" without a check actually failing.

## Step 4: Build the dependency graph

For each phase, declare `depends on: [other phases]` — a judgment call from the anchor docs (which Building Block needs which to exist), not inferred from code; code-level Recon happens later, inside each phase's own `/spec`.

Compute:

- **Critical path** — the longest chain of dependencies; the minimum number of sequential phases even with infinite parallel capacity.
- **Waves** — phases whose dependencies are already satisfied at each step; the width of the widest wave is the maximum useful parallelism.

**Completion criterion:** every phase has an explicit `depends on` (possibly empty), and critical path length + max parallelism per wave are both stated as numbers, not vibes.

## Step 5: Render streams

Present the critical path and max parallelism from Step 4. Ask via the AskQuestion tool how many concurrent streams the user wants to commit to right now — offer the computed max as the recommended option, "1 (sequential)" as the safe option, and a custom count.

Assign phases to the chosen number of streams respecting the dependency graph — never assign a phase to a stream before every phase it depends on is assigned earlier in some stream.

**Completion criterion:** every phase belongs to exactly one stream, in an order that never violates a dependency.

## Step 6: Reserve carry-over paths

For each phase, reserve (don't write) a fragment path: `<root>/<slug>/carryover-phase-<n>.md`. This is where that phase's own `/implement` run records facts, dependency corrections, or new scope that affects other phases — see `references/carryover-template.md` for its shape. Record the reserved path in the roadmap doc so `/implement` knows where to write without asking.

**Completion criterion:** every phase has a reserved, unique carry-over path — never shared between phases, never inside another phase's file.

## Step 7: Absorb pending carry-over (Sync mode only)

For each located fragment (Step 2): read it, apply its entries —

- **Fact** → note it against the target phase's row in the Phases table (a one-line pointer, not the full fact — the fact itself stays in the fragment's git history via the link).
- **Dependency correction** → update the `depends on` column for the affected phase(s); re-run Step 4's critical path / wave computation if any edge changed.
- **New scope** → add a new phase row, run it through Step 3's boundary test before accepting it.
- **Doc correction** → an anchor doc said something the build disproved. Fix the doc section directly (or via `/tdd`/`/adr` when the correction reopens a decision), and log it in the Carry-over Log.

Once absorbed, delete the fragment file — its content now lives in the roadmap's `Carry-over Log`.

This step runs alone, never concurrently with another Sync or with a phase's own `/implement` run — absorbing while a stream is still writing its fragment risks exactly the shared-file conflict this design avoids by having fragments in the first place.

**Completion criterion:** every located fragment is absorbed and deleted, or explicitly deferred with a stated reason; the dependency graph reflects every correction found.

## Step 8: Write the document

Follow `references/template.md` structure exactly.

Writing rules:

- **One phase, one row plus one contract block.** The table is the index — short title (4–10 words), dependencies, status; the block carries the contract from Step 3, nothing more. Anything beyond the contract belongs to the phase's `/spec`.
- **No persuasion.** State the cut and the graph, don't justify them — the reasoning behind a split, if worth keeping, is one line in the phase's contract, not a paragraph.
- **Diagram required unless trivial.** Render the dependency graph as a mermaid `flowchart` — skip only if there's a single phase with no dependencies (and if so, reconsider whether `/phasing` was the right skill per "When NOT to apply").

## Step 9: Save and present

Save the file, then summarize:

- Path written (or updated), Create or Sync.
- Phase count, critical path length, max parallelism, streams rendered.
- ADRs found and what they forced on the cut or ordering; PRD/TDD used as reference.
- Fragments absorbed this run (Sync mode), and what each changed.
- Next step: which phase's `/spec` to run first (the one with no unmet dependency, in stream order).

## Lifecycle

| Status | Meaning | Trigger |
|---|---|---|
| `Draft` | Cut written, not yet handed to any `/spec` | Roadmap generated |
| `Active` | At least one phase has an in-progress or done `/spec`/`/implement` | First phase starts |
| `Done` | Every phase's `/spec` is `Done` | Last phase completes |

Per-phase status in the Phases table: `Pending → Spec'd → Done` — the phase's own `/spec` flips it to `Spec'd` and its `/implement` flips it to `Done`, each editing only its own row's status cell. Sync revalidates the column but doesn't own it.

## Rules

1. A phase's boundary is `/spec`'s boundary test (one sentence, one Approach, one Verify surface) — never a line-count or file-count target.
2. Dependency between phases is declared from the anchor docs, not inferred from code — code-level correctness is `/spec`'s Recon, later.
3. Streams are a capacity-bounded cut of the dependency graph, computed via Step 4 — never fixed upfront independent of real dependency.
4. Carry-over is always a fragment file, one per phase, never a shared file two phases could write concurrently.
5. Absorption (Sync) is a serialized, single-actor step — never run as part of a phase's own `/implement`, autonomous or not.
6. One roadmap per scope — update in place via Sync, don't duplicate.
7. Write in the same language the user uses.
