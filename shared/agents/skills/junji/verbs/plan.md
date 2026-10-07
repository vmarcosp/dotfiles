# Verb: `plan` — turn the source into PLAN.md and define the bar

The thinking verb. Takes a source doc or rough idea and produces the strategy after a reasoning + grilling
pass. **Load-bearing decisions happen here.** Writes `.koi/run/PLAN.md` and fills `.koi/run/CONTEXT.md`.

Chat like `references/chat.md`. Write `PLAN.md` as **explanation** and `CONTEXT.md` as **reference**
(fact-only locks) per `references/docs.md`.

1. **Gather the source.** Read the RFC/ADR/PRD/idea the user points at; skim the target codebase enough to
   name what's changing and what it depends on. If `.koi/run/researches/` exists, **read every research
   note**: treat cited findings as factual context for the reasoning that follows (missing folder: skip).
   If `.koi/run/DESIGN.md` exists, **read it**: treat it as the binding visual / experiential contract for
   any human-facing surface (missing file: skip unless step 1b applies).
1b. **Activate design when needed.** If the work clearly includes a human-facing surface (web, mobile,
   desktop, TUI, docs UI) **and** `.koi/run/DESIGN.md` is missing, follow **`verbs/design.md`** now (or
   instruct the user to `/junji design …` with references) **before** locking surface-related decisions.
   Pure backend / library / non-UI work: skip entirely.
2. **Reason.** Work out the approach: major moving parts, how the new thing plugs in, what stays out. Form a
   position *before* grilling it.
3. **Grill.** Follow **`verbs/grill.md`** (same method as the standalone `grill` verb: frontier rounds).
   Output: **locked decisions** plus a sharpened **`.koi/run/CONTEXT.md › Language`** glossary.
4. **Define the verification bar (load-bearing).** Objective, automatable gate that proves a phase correct
   (see CONTEXT template › Verification bar). Commands that exit 0: never a judgment call. Wire the
   project's real stack gates (fmt/lint/typecheck/tests); do not invent a bespoke growing assertion script.
   Record runnable commands, their working directory (normally repo root), and prerequisites in
   `.koi/run/CONTEXT.md › Verification bar`. `begin` may already have listed detected commands under
   `## Toolchain`; choose from those. Existing sensors may supply those commands; read them
   when relevant, but do not require, create, or overwrite scripts during ordinary planning.
5. **Pin the deliverable spec model.** Decide what `consolidate` will produce. Detect host convention
   (`specs/`, `docs/`, `rfcs/`, `adr/`, authoring skills). Propose to the user; if none, narrative default.
   Record in `.koi/run/CONTEXT.md › Deliverable spec model` **as data**: section outline inlined, native
   location, filename convention: so headless `consolidate` is deterministic.
6. **Write `.koi/run/PLAN.md`** from `templates/PLAN.template.md` as **explanation**: problem/request,
   chosen approach, reasoning & alternatives, key decisions **with rationale**, success criteria. Do not
   put execution recipes here.
7. **Promote into `.koi/run/CONTEXT.md`.** Read the file immediately before each edit and replace a
   span copied from that read, including whitespace and indentation. Fill what `begin` left:
   orientation, **Language** (canonicalize begin's candidates: pick terms, `_Avoid_` aliases, resolve
   conflicts), locked decisions (**fact-only**: the decision, not why), verification bar, file map,
   deliverable spec model, standing overrides, code style. **Keep `CONTEXT.md › Skills`** from Skill
   scout unless grilling settled a different Must / role assignment (then edit Skills to match the
   lock). CONTEXT must be self-sufficient for execution.
   These spans are in a fresh skeleton until an earlier edit replaced them. A fence inside this list
   is indented with the list; that indent is not in the file. Use one only when the read still shows
   the span:

   ```context-file
   - **<Area, e.g. Architecture>:** <the decision, stated as a fact>.
   - **<Dependencies / tooling>:** <pinned crates/libraries/versions; anything explicitly NOT used>.
   - **<Scope boundary>:** <what stays out of scope / stays in the old system forever>.
   - **<Integration boundary>:** <how the new thing plugs in; what the boundary contract is>.
   ```

   ```context-file
   - **Language gates:** `<formatter --check>`, `<linter -D warnings>`, `<unit tests>`.
   - **Repo gates:** `<lint>`, `<test>`, `<typecheck>` — all exit 0.
   - **Commit hygiene:** `<conventional-commit format / any hooks>`.
   ```

   ```context-file
   - **Branch:** `<the single branch all phases commit to>`.
   - **Push policy:** <e.g. "commit locally, never push" | "push after each phase">.
   ```

   ```context-file
   - **Port / change from:** `<exact source files and dirs the work reads and mirrors>`.
   - **Mirror (shape only):** `<schemas/types to reproduce without changing>`.
   - **Leave untouched:** `<what stays as-is — the boundary the project must not cross>`.
   - **Corpus / fixtures:** `<the example inputs the verification bar runs over>`.
   ```

   ```context-file
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
   ```

   ```context-file
   <Point to the repo's style guide and commit convention; the few rules that matter most for generated code.>
   ```
   If the bar changes, record the actual required commands. Yokai must reconcile its executable gate
   through human review before unattended execution; Junji does not edit its configuration or receipt.
8. **Advance the pointer & stop.** Set `.koi/run/BACKLOG.md › Next action` to `/junji refine`. First line:
   `Next action: /junji refine`. Then the runnable verification commands. **Do not
   decompose into phases: that's `refine`.**
