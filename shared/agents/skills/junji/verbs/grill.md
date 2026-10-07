# Verb: `grill` — grilling method (SSOT)

Junji's relentless interview for sharpening a plan **and** building the project's domain model as it goes.
Self-contained: no external skill required. Same method in four places:

- **Inside `plan`** (step 3): harden the freshly-reasoned approach before decisions are locked.
- **Inside `design`** (analyse): settle unsettled visual / experiential direction, or which of several
  design skills to follow, before consolidating `.koi/run/DESIGN.md`.
- **Inside `iterate`**: harden a post-execution request, including how to slice it into phases, before
  writing BACKLOG headings and phase contracts.
- **As the `grill` verb**: a standalone pass any time the plan feels soft, scope is fuzzy, or terminology
  is drifting.

**When run as the `grill` verb:** requires `.koi/run/PLAN.md`: if missing, say so and stop. Does **not**
move the `Next action` pointer; it sharpens whatever stage you're already in.

Chat like `references/chat.md`. Write PLAN as **explanation**, CONTEXT locks as **reference** (fact-only)
per `references/docs.md`. First line of every round is the ask, not a lecture on the design tree.

The "with-docs" half is the point: grilling **writes to disk as it goes**: glossary into
`CONTEXT.md › Language`, rationale into `PLAN.md › Key decisions`, binding fact into
`CONTEXT.md › Locked decisions`. Nothing settled stays only in the conversation.

## Before the interview

If `.koi/run/researches/` exists, **read every research note** first. Treat cited primary-source findings
as factual context: don't re-litigate them without cause. Missing folder is fine (skip; no error).

If `.koi/run/DESIGN.md` exists, **read it**: binding visual / experiential contract for human-facing
surfaces. Missing file is fine (skip; no error). When the soft spot is visual direction, prefer settling
those decisions into `DESIGN.md` (see Crystallize below) rather than overloading PLAN.

If `.koi/run/CONTEXT.md › Skills` exists, **read it**: Must rows are standing orders for their roles;
do not re-litigate whether to obey them. Guess-marked mappings and which of several *Available* design
skills to follow may still be grilled. Missing section is fine (skip).

## The interview — frontier rounds

Map the work as a **design tree** (decision topology: not the `design` verb, not `DESIGN.md`): every
decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled,
the questions you can ask *now* without guessing at answers you haven't heard yet.

1. **Ask the whole frontier in one round.** First line: `Answer these N. Recommended inlined.` Number
   each question and give your **recommended answer** (and why). Then wait for the user's answers before
   the next round. If the frontier would exceed ~5 questions, ask **ADR-worthy** ones first (the three
   tests below) and park the rest as **Later (not this round)**. Do not collapse grill to one question.
2. **Recompute.** Each round of answers reshapes the tree: settled decisions push the frontier outward and
   unblock questions that depended on them. A question whose answer depends on another still open in *this*
   round belongs to a *later* round, not this one.
3. **Facts vs decisions.** Finding *facts* is your job, never the user's. If the codebase (or a quick local
   lookup) can answer it, read it: don't ask. When a frontier item needs durable primary-source dig (API
   docs, external specs), follow **`verbs/research.md`** for that gap (write a note under
   `.koi/run/researches/`): **don't block the rest of the round**: only questions downstream of that
   exploration wait; ask the other frontier questions now. The *decisions* are the user's: put each to them
   and wait.
4. **Done when empty.** The session is done when the frontier is empty: every branch visited, nothing left
   silently assumed. Do **not** act on the plan until the user confirms you have reached a shared
   understanding.

Output: **locked decisions** plus a sharpened glossary.

## Build the domain model as you go

Treat the codebase as the source of truth for what words mean.

- **Challenge against the glossary.** When a term clashes with `CONTEXT.md › Language`, call it out.
- **Sharpen fuzzy language.** When a word is vague or overloaded, propose the precise canonical term.
- **Stress-test with scenarios.** Concrete edge cases that force precision about concept boundaries.
- **Cross-reference with the code.** When the user states how something works, check the code agrees; on
  contradiction, surface it.

## Crystallize on disk — don't batch

The moment something settles, write it where it belongs.

- **A term resolves →** read `.koi/run/CONTEXT.md` and edit `## Language` there. Replace a span copied
  from that read. On a fresh skeleton the placeholders are the blocks below. A fence inside this list
  is indented with the list; that indent is not in the file.

  ```context-file
  **<Canonical term>**:
  <One or two lines in the project's real domain terms — and, where it matters, how it differs from a
  neighbouring term.>
  _Avoid_: <the tempting-but-wrong synonyms this term replaces>
  ```

  ```context-file
  **<Canonical term>**:
  <Definition.>
  _Avoid_: <aliases>
  ```

  If those placeholders are already gone, edit the candidate entry the read shows. Terms are
  the glossary; choices are locked decisions: keep the sections apart.
- **A decision settles →** rationale (and rejected alternatives) into `PLAN.md › Key decisions`,
  **fact-only** lock into `CONTEXT.md › Locked decisions`. PLAN wins for the *why*, CONTEXT for
  execution: edit both together. On a fresh skeleton:

  ```context-file
  - **<Area, e.g. Architecture>:** <the decision, stated as a fact>.
  - **<Dependencies / tooling>:** <pinned crates/libraries/versions; anything explicitly NOT used>.
  - **<Scope boundary>:** <what stays out of scope / stays in the old system forever>.
  - **<Integration boundary>:** <how the new thing plugs in; what the boundary contract is>.
  ```
- **A visual / experiential decision settles →** update `.koi/run/DESIGN.md` (create via `verbs/design.md`
  consolidate sections if the file is missing mid-grill and the work is human-facing) and keep
  `CONTEXT.md › Design contract` pointing at it. Put the same choice into PLAN / Locked decisions **only**
  when it is also a product/strategy lock.
- **Which skill a role follows settles →** fact-only lock in `CONTEXT.md › Locked decisions` and update
  `CONTEXT.md › Skills` By role / Must to match. Do not grill whether to obey an existing Must row.
  On a fresh skeleton those Skills lines are:

  ```context-file
  - `<path>` (`<name>`) — <when as the docs state, or "always">. Roles: `<design | next | plan | coder | judge | seal>`. <optional: _Guess_: inferred mapping>
  ```

  ```context-file
  - **design:** `<paths or none>`
  - **next:** `<paths or none>`
  - **plan:** `<paths or none>`
  - **coder:** `<paths or none>`
  - **judge:** `<paths or none>`
  - **seal:** `<paths or none>`
  ```
- **A goal gets reframed →** directive into `CONTEXT.md › Standing overrides`. On a fresh skeleton:

  ```context-file
  - **Branch:** `<the single branch all phases commit to>`.
  - **Push policy:** <e.g. "commit locally, never push" | "push after each phase">.
  - **<Other standing directive>:** <e.g. "keep both old and new runnable for comparison; do not delete the
    old one">.
  ```
- **The verification bar changes →** edit runnable commands in `CONTEXT.md › Verification bar` in the same
  breath. Read the file and replace a span it still contains. On a fresh skeleton:

  ```context-file
  - **Language gates:** `<formatter --check>`, `<linter -D warnings>`, `<unit tests>`.
  - **Repo gates:** `<lint>`, `<test>`, `<typecheck>` — all exit 0.
  - **Commit hygiene:** `<conventional-commit format / any hooks>`.
  ```

  Existing Yokai gates require human reconciliation before unattended execution.

`CONTEXT.md › Language` is a glossary and nothing else: no implementation detail, not a spec or scratchpad.

## ADR-worthy decisions — record richly, not separately

A decision is **ADR-worthy** when all three hold:

1. **Hard to reverse**: changing your mind later costs real work.
2. **Surprising without context**: a future reader will ask why this way.
3. **The result of a real trade-off**: genuine alternatives, picked for reasons.

When all three hold, give a **full `PLAN.md › Key decisions` entry**: alternatives, trade-off, reason,
not just the CONTEXT fact. The same three tests rank a crowded grill round: ask those first, park the
rest. junji keeps **no `docs/adr/` inside `.koi/`**: PLAN is the decision record during the project;
`consolidate` may render these as ADRs in the host repo's format if that's the Deliverable spec model.
If any of the three is missing, a Locked-decisions line is enough.

## Worked example (junji's own vocabulary)

> Round 1 frontier might include: "Is the connector's unit a **phase** or a **turn**?" Recommended: turn,
> one prompt→stop exchange; a phase runs as one or more turns.

That resolved into two glossary entries. The shape below is an illustration of a filled Language
entry. It is not text already in `.koi/run/CONTEXT.md`, and it is not a span in
`skills/junji/CONTEXT.md` or `crates/yokai/CONTEXT.md`. Record the real term by editing a span the
run file actually contains.

```text
**Turn**:
One prompt→stop exchange with an agent — the connector's unit of work. A phase runs as one or more turns;
the connector knows turns, not phases.
_Avoid_: phase, request, run

**Phase**:
Junji's unit of work — one coherent, independently-verifiable slice. Runs as one or more turns.
_Avoid_: turn, step, task
```

The *decision* that followed: rename in the connector so junji vocabulary stops leaking into the agnostic
port: went to `PLAN.md › Key decisions` with rationale, and its fact-form to
`CONTEXT.md › Locked decisions`.
