# <project> — context

**Reference: binding facts a fresh window obeys.** Skeleton laid by `begin` (including **Skills**);
filled further by `plan`. Edited later only when a locked decision genuinely changes (record the
change under Standing overrides). No rationale here: that lives in `PLAN.md`.

## What this is

<One or two sentences for orientation — what this project builds or changes — so a fresh execution window
knows what it's working on without opening anything else. The full story (problem, approach, reasoning,
success criteria) lives in `PLAN.md`; this is just the at-a-glance.>

## Language

Define the project terms that later phases must use consistently. Keep this glossary free of implementation details. `begin` records candidate names from the repository as guesses. `plan` or `grill` chooses the canonical terms, defines them, and lists aliases to avoid. Record choices under **Locked decisions**.

**<Canonical term>**:
<One or two lines in the project's real domain terms — and, where it matters, how it differs from a
neighbouring term.>
_Avoid_: <the tempting-but-wrong synonyms this term replaces>

**<Canonical term>**:
<Definition.>
_Avoid_: <aliases>

## Locked decisions

The settled choices from grilling, **fact-only**: the decision, not why. Rationale lives in
`PLAN.md › Key decisions`. Later phases must not relitigate these.

- **<Area, e.g. Architecture>:** <the decision, stated as a fact>.
- **<Dependencies / tooling>:** <pinned crates/libraries/versions; anything explicitly NOT used>.
- **<Scope boundary>:** <what stays out of scope / stays in the old system forever>.
- **<Integration boundary>:** <how the new thing plugs in; what the boundary contract is>.

## Design contract

Optional. Filled by the `design` verb when this run needs a visual / experiential contract for human-facing
surfaces. Missing section (or "none") is normal for non-UI work.

- **Binding file:** `<.koi/run/DESIGN.md | none>`
- **Rule:** <e.g. "Any human-facing surface in this run must obey `.koi/run/DESIGN.md`" | "n/a — no UI">

## Skills

In-repo `SKILL.md` files this run must follow. Filled by `begin` **Skill scout** (facts). `plan` /
`grill` may canonicalize guesses. Not File map, not Design contract. Paths are repo-root-relative.

**Must** (named in `AGENTS.md` / `CLAUDE.md` / `DESIGN.md` / `PRODUCT.md` / `.cursor/rules`):

- `<path>` (`<name>`) — <when as the docs state, or "always">. Roles: `<design | next | plan | coder | judge | seal>`. <optional: _Guess_: inferred mapping>

**Available** (catalog, not named in those docs: `next` / coder / judge / seal do **not** load these):

- `<path>` (`<name>`) — <one line from SKILL.md description>
- `none`

**By role** (Must paths only; `none` if empty):

- **design:** `<paths or none>`
- **next:** `<paths or none>`
- **plan:** `<paths or none>`
- **coder:** `<paths or none>`
- **judge:** `<paths or none>`
- **seal:** `<paths or none>`

## Toolchain

Detected build, test, and lint commands. `begin` records what it found. `plan` chooses which of
these become the verification bar. This section is not the bar.

- **Build:** `<command, or "not found">`
- **Test:** `<command, or "not found">`
- **Lint:** `<command, or "not found">`

## Verification bar (load-bearing — this is how "done" is decided)

"Done" is commands that exit 0, never a judgment call. Run all of these in step 5 of every phase.
Record runnable commands and working directories here. Sensor scripts are optional for Junji;
existing sensors may be reused. Yokai separately prepares a reviewed executable gate from these
commands.

- **Language gates:** `<formatter --check>`, `<linter -D warnings>`, `<unit tests>`.
- **Repo gates:** `<lint>`, `<test>`, `<typecheck>` — all exit 0.
- **Commit hygiene:** `<conventional-commit format / any hooks>`.

Wire the project's real stack gates. Do not invent a bespoke growing assertion script the judge can keep
punching holes in.

## File map

- **Port / change from:** `<exact source files and dirs the work reads and mirrors>`.
- **Mirror (shape only):** `<schemas/types to reproduce without changing>`.
- **Leave untouched:** `<what stays as-is — the boundary the project must not cross>`.
- **Corpus / fixtures:** `<the example inputs the verification bar runs over>`.

## Deliverable spec model

Record the final document's format, section outline, location, and filename. `plan` derives these from the repository's conventions. `consolidate` follows the recorded values, so a fresh session can produce the same structure.

- **Format:** <model name + source, e.g. "SDD — the repo's `specification` skill" | "ADR" | "RFC" |
  "matches exemplar `<path>`" | "narrative default (no house style found)">.
- **Section outline (authoritative: `consolidate` follows THIS verbatim, even if the referenced
  skill/exemplar isn't loaded):**
  1. `<Section>` — <what belongs here>.
  2. `<Section>` — <what belongs here>.
  3. `<…>`
- **Location:** `<the repo's native spec home if it has one, e.g. docs/adr/ or rfcs/; else specs/>`.
- **Filename:** `<naming convention resolved to the deliverable, e.g. NNNN-<slug>.md | <slug>.md>` —
  represents what was delivered; **never `SPECIFICATION.md`**.

## Standing overrides

Durable user directives that outrank the default protocol. Honor verbatim in every window.

- **Branch:** `<the single branch all phases commit to>`.
- **Push policy:** <e.g. "commit locally, never push" | "push after each phase">.
- **<Other standing directive>:** <e.g. "keep both old and new runnable for comparison; do not delete the
  old one">.

## Code style & commits

<Point to the repo's style guide and commit convention; the few rules that matter most for generated code.>
