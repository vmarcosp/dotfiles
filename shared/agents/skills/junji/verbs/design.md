# Verb: `design` — visual / experiential contract for the run

Synthesize a binding **visual / experiential contract** for any human-facing surface this run will ship
(web, mobile, desktop, TUI, docs UI) into `.koi/run/DESIGN.md`. Context for `plan`, `grill`, `iterate`, and
`next`: not a phase plan, not module API design, and not code generation.

**On demand.** Optional; run zero, one, or many times. Does **not** advance `.koi/run/BACKLOG.md › Next
action`. Prefer sub-agents when available; **inline is allowed and equivalent**: same bar, same files.

Universal: no product-specific MCP, no framework codegen recipes in *this* verb. Atmosphere, tokens, and
principles in `.koi/run/DESIGN.md`. If `CONTEXT.md › Skills` names an in-repo design `SKILL.md`, **read
and follow it** inside the protocol below: that is not a vendor recipe in this file.

Chat like `references/chat.md`. Write design notes and `DESIGN.md` as **reference** per `references/docs.md`.

## Prerequisites

- Requires `.koi/run/BACKLOG.md` (a real `begin`). If missing, say so and stop: point at `/junji begin`.
  Do **not** scaffold the working folder from this verb.
- Does **not** require `PLAN.md`.

## Inputs

Accept any mix of:

- URLs (sites / apps used as references)
- Local paths (screenshots, existing UI code, design exports on disk)
- Short brief text naming the surface and constraints
- Implicit or explicit use of a **project design doc** (commonly repo-root `DESIGN.md`) when it exists

If the user passes **no** references and there is **no** project design doc → ask for at least one
reference **or** confirm a greenfield direction before spinning research sub-agents.

When `plan` or `iterate` invokes this method because the work is human-facing and `.koi/run/DESIGN.md` is
missing, treat the source doc + any named references as the inputs: no separate confirm if references are
already clear.

## Protocol

1. **Discover project design.** Look for a durable project/root `DESIGN.md` (or the repo's named visual
   system doc). If found, it is the **parent** system: the run file will cite and inherit it. **Never
   overwrite** the project design doc from this verb.

2. **Load Skills.** Read `.koi/run/CONTEXT.md › Skills`. If the section is missing or looks stale, re-walk
   the in-repo `SKILL.md` trees the same way `begin` scouts (disk wins; update Skills if the set changed).
   - **Must** rows for `design` → follow those `SKILL.md` files (and only the files they say to load). Do
     not grill *whether* to use a Must row.
   - Else **Available** that are **design-flavored** (name `impeccable` or `frontend-design`, or YAML
     description is visual / frontend / UI / UX / experiential). One → follow it. Several → grill which
     (`verbs/grill.md`); lock the choice fact-only in Locked decisions; By role still lists Must only.
   - None → native protocol (this file's remaining steps).
   If a followed skill would write repo-root `PRODUCT.md` / `DESIGN.md`, capture into `.koi/run/designs/`
   and `.koi/run/DESIGN.md` instead (inherit the project design doc; never overwrite it). Do not install
   or vendor a skill. Session tools (browser, image gen) may help capture a reference if already attached;
   they are not a CONTEXT fact.

3. **Ensure `.koi/run/designs/`.** Create the folder on first use. Do not create it in `begin`.

4. **Research: capture references.** For each reference (and for the project design doc if present), write
   one note from `templates/design-note.template.md` → `.koi/run/designs/NN-<slug>.md` (`NN` = next
   zero-padded sequence; `<slug>` from the source). Prefer a **sub-agent per reference** (or one for the
   project doc) when the host can spawn them; parallel when researching several at once, else serialize.
   Capture observable patterns only: atmosphere, color, type, layout, component feel, motion stance,
   with citations. Do not invent load-bearing product decisions here. Apply the loaded skill's research /
   extract / document guidance **inside** this step.

5. **Analyse: diverge, then recommend.** From the notes (and project design parent), propose **2-3
   divergent directions** for *this run*, then a **recommended** direction with rationale (fit to brief,
   parent system, and references). If any visual / experiential decision cannot be settled from the notes,
   parent, and the skill's defaults: or which of several design skills to follow: run a **design grill**:
   follow **`verbs/grill.md`** frontier rounds scoped to those unsettled decisions before consolidating.
   Standalone `/junji grill` still requires `PLAN.md`; this in-verb grill does not. A missing skill is
   not a question.

6. **Consolidate: write the binding contract.**
   - Write or update `.koi/run/DESIGN.md` from `templates/DESIGN.template.md`: Atmosphere · Color (with
     hex) · Typography · Layout principles · Component feel · Motion stance · Do/Don't · Sources.
   - Name one aesthetic direction; put anti-generic / anti-template rules under Do/Don't.
   - Under Sources: cite every reference note and link the project design doc when present. Record only
     **this-run deltas** relative to the parent when a parent exists.
   - Fill or update `.koi/run/CONTEXT.md › Design contract`: path to `.koi/run/DESIGN.md` plus one line
     that human-facing surfaces in this run must obey that file. Read `.koi/run/CONTEXT.md` first and
     replace a span copied from that read. On a fresh skeleton the binding lines are still the block
     below. A fence inside this list is indented with the list; that indent is not in the file.

     ```context-file
     - **Binding file:** `<.koi/run/DESIGN.md | none>`
     - **Rule:** <e.g. "Any human-facing surface in this run must obey `.koi/run/DESIGN.md`" | "n/a — no UI">
     ```

     Create the section if the read shows it is missing.

7. **Stop.** First line: `Next action:` whatever BACKLOG already says (this verb does not move it). Then
   the paths written. Do not start `plan` unless the user asked (or `plan` invoked this mid-flight and
   should resume).

## Rules

- Finding *observable patterns* is research; *visual decisions* settle in analyse/grill; the *binding
  contract* is `DESIGN.md`.
- A missing `designs/` or `DESIGN.md` is normal until first use: `plan`/`grill`/`iterate`/`next` skip
  without error unless `plan` or `iterate` has determined the work is human-facing and design is required
  (then activate this verb).
- Visual decisions crystallize into `.koi/run/DESIGN.md` (+ CONTEXT Design contract). Put them in
  `PLAN.md › Key decisions` / Locked decisions **only** when they are also product/strategy locks.
- Grilling's **"design tree"** means decision topology: not this verb and not `DESIGN.md`.
- Honor `CONTEXT.md › Skills` for `design` as above. Do not treat Available non-design skills as Must.
- `consolidate` removes these artifacts with the rest of `.koi/run/`.
