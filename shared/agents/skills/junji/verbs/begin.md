# Verb: `begin` — scaffold the working folder + survey the repo

Create the working folder and record observable facts from the repository. Leave strategy, verification requirements, and locked decisions for `plan`. Do not read the source document during `begin`.

You can run `begin` when `.koi/run/` is missing, contains a legacy setup stub, or already holds project state. Preserve existing backlogs and decisions as described below.

Chat like `references/chat.md`. Write CONTEXT as **reference** per `references/docs.md`. Do not author
METHOD.md or BACKLOG.md: copy them.

1. **Ensure `.koi/run/`.** Create `.koi/` and `.koi/run/` if absent. No executable installation,
   runtime settings, or sensor scripts are required. Leave all driver-owned files and existing
   sensors alone, including legacy configuration awaiting migration. Never regenerate an active effort.
2. **Copy, do not read, do not rewrite.** From this skill's `templates/` (sibling of `verbs/`), copy
   into `.koi/run/` (never the repo root or `.koi/` root). Use a filesystem copy (`cp`). Do **not**
   Read `METHOD.template.md` or `BACKLOG.template.md` into this context. Do not substitute a project
   name. Do not edit the copies.
   - If `.koi/run/METHOD.md` is absent: `METHOD.template.md` → `.koi/run/METHOD.md`.
   - If `.koi/run/BACKLOG.md` is absent: `BACKLOG.template.md` → `.koi/run/BACKLOG.md`. **Never
     overwrite** a BACKLOG that already exists (it may hold a live phase list). The template is
     begin-ready: `Next action: /junji plan`, empty Tasks.
   - If `.koi/run/CONTEXT.md` is missing, or is an untouched legacy `koi init` stub (the title line is
     exactly `# junji — not scaffolded yet` and the file has no project customizations): replace the
     whole file by copying `CONTEXT.template.md` → `.koi/run/CONTEXT.md` (`cp`). That stub is not the
     skeleton. If CONTEXT is already a real skeleton, do **not** recopy it and do **not** search for
     the stub title.
   - Create `.koi/run/phases/` if absent.
   (`.koi/run/PLAN.md` is written by `plan`, not here.)
3. **Survey the repo and fill only the *observable* `.koi/run/CONTEXT.md` sections**: facts you can read
   off the codebase without choosing a strategy. Read `.koi/run/CONTEXT.md` immediately before each
   edit. Replace a span copied from that read, including whitespace and indentation. The `context-file`
   blocks below show fresh-template spans. A fence inside this list is indented with the list; that
   indent is not in the file. Use a block only when the read still contains the span.
   After a span has been filled, later edits use the text now in the file. Leave every `<…>` that encodes a
   *decision* for `plan`. If this is a re-run of an already-begun CONTEXT, refresh observable sections
   only: do not wipe locked decisions, the verification bar, standing overrides, or Design contract.
   - **What this is**: one-line orientation (name, language, what the repo appears to do). Replace this
     span when it is still present:

     ```context-file
     <One or two sentences for orientation — what this project builds or changes — so a fresh execution window
     knows what it's working on without opening anything else. The full story (problem, approach, reasoning,
     success criteria) lives in `PLAN.md`; this is just the at-a-glance.>
     ```

   - **Language**: raw candidate terms from the code (core entities, types, recurring names), **marked as
     guesses**. Don't canonicalize: that is grilling's job (`plan`/`grill`). On a fresh skeleton the
     placeholder entries are:

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

   - **File map**: source dirs/files that exist and obvious boundaries; mark guesses. On a fresh
     skeleton:

     ```context-file
     - **Port / change from:** `<exact source files and dirs the work reads and mirrors>`.
     - **Mirror (shape only):** `<schemas/types to reproduce without changing>`.
     - **Leave untouched:** `<what stays as-is — the boundary the project must not cross>`.
     - **Corpus / fixtures:** `<the example inputs the verification bar runs over>`.
     ```

   - **Toolchain**: detected build / test / lint commands under `## Toolchain` (raw material for
     `plan`: do *not* set the bar). On a fresh skeleton:

     ```context-file
     - **Build:** `<command, or "not found">`
     - **Test:** `<command, or "not found">`
     - **Lint:** `<command, or "not found">`
     ```
   - **Deliverable spec model**: detect host convention: scan `specs/`, `docs/adr/`, `rfcs/`, note any
     authoring skill (`specification`, `rfc-writer`, `prd-writer`). Record what you **found**; `plan` pins it.
     On a fresh skeleton the placeholder is:

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
   - **Skills (Skill scout).** Facts only: copy what the repo already says; do not invent Must rows.
     1. **Catalog.** Walk `.claude/skills/`, `.cursor/skills/`, `.agents/skills/`, `skills/` for
        `SKILL.md`. Skip folders named `junji` or `yokai`. Record repo-root-relative path, YAML `name`,
        one line from `description`.
     2. **Must.** Read project docs that exist: `AGENTS.md`, `CLAUDE.md`, `DESIGN.md`, `PRODUCT.md`,
        `.cursor/rules` (and `*.mdc` under that folder). Extract skill names the docs tell agents to
        follow, plus any *when* clause as written. Resolve each name to a catalog path (folder or YAML
        name, case-insensitive). Unresolved names: keep the name, `path: unresolved`, mark **guess**.
     3. **Roles.** Map as the docs state. If they only imply the work, guess and mark **guess**:
        implementation / "when writing code" → `next` + `coder`; review / critique of diffs → `judge`;
        visual / UI / frontend design → `design`; commit / seal hygiene → `seal`; planning the phase
        file → `plan`. Do not assign triage/repair unless a doc names a recovery skill. Do not bind
        to phase numbers (the list does not exist yet).
     4. **Available.** Catalog entries not in Must. Coder/judge/seal will not load these.
     5. Write `CONTEXT.md › Skills` (Must, Available, By role). Empty Must / none-per-role is normal.
        On a fresh skeleton, replace these placeholders (they are still in the file only until this
        step writes the scout result):

        ```context-file
        - `<path>` (`<name>`) — <when as the docs state, or "always">. Roles: `<design | next | plan | coder | judge | seal>`. <optional: _Guess_: inferred mapping>
        ```

        ```context-file
        - `<path>` (`<name>`) — <one line from SKILL.md description>
        - `none`
        ```

        ```context-file
        - **design:** `<paths or none>`
        - **next:** `<paths or none>`
        - **plan:** `<paths or none>`
        - **coder:** `<paths or none>`
        - **judge:** `<paths or none>`
        - **seal:** `<paths or none>`
        ```

   On a first fill, leave **Verification bar**, **Locked decisions**, and **Standing overrides** as the
   template left them. Do **not** leave Skills as the template placeholders once scout has run.
4. **Stop.** First line: `Next action: /junji plan`. Then what you copied and surveyed. **Decide nothing.**
