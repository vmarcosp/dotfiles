# Optional design verb and run DESIGN.md

## Status

Accepted — amended in part by [0006](0006-skill-scout-and-context-skills.md): in-repo
design skills are in-bounds; hardcoded vendor MCP recipes stay rejected.

## Context

Long projects that ship human-facing surfaces (web, mobile, desktop, TUI, docs UI) need a durable
**visual / experiential contract** before `plan` locks surface decisions and before `next` implements them.
Until now the method had no place for reference-driven design synthesis: product repos often keep a root
`DESIGN.md`, but a *run* had only `PLAN.md` / `CONTEXT.md` / optional `researches/`. Inspiration: semantic
DESIGN.md structure (atmosphere, palette, type, layout), distinctive anti-generic direction-setting, and
proposing a few divergent directions before consolidating — all kept **universal** (no Stitch/MCP, no
framework-specific codegen).

## Decision

1. **Add an optional on-demand `design` verb** — eighth verb under the same progressive-disclosure skill.
   Protocol: **research** references → **analyse** (2–3 directions + recommend; optional design grill via
   `verbs/grill.md`) → **consolidate** into binding `.koi/run/DESIGN.md`. Working notes live under
   `.koi/run/designs/NN-<slug>.md` (folder on first use). Does not advance Next action. Prefer sub-agents
   when available; inline is equivalent.
2. **Project vs run design docs** — if a project/root `DESIGN.md` (or equivalent) exists, the run file
   **cites and inherits** it and records only this-run deltas. The verb **never overwrites** the project
   design doc.
3. **`plan` may activate design** — when the work clearly includes a human-facing surface and
   `.koi/run/DESIGN.md` is missing, `plan` runs the design protocol (or instructs `/junji design`) before
   locking surface-related decisions. Pure backend/library work skips design entirely.
4. **Skill-level guard** — when `.koi/run/DESIGN.md` exists (or `CONTEXT.md › Design contract` points at
   it), `plan` / `grill` / `next` must read and obey it for human-facing output. `design` writes the
   CONTEXT Design-contract pointer on consolidate. No aesthetic sensors; no driver/Rust preflight.
5. **Design grilling** — reuse frontier rounds in `verbs/grill.md` inside `design` before consolidate.
   Standalone `/junji grill` still requires `PLAN.md`, but reads `DESIGN.md` when present. Visual
   decisions crystallize into `DESIGN.md` (+ CONTEXT pointer), not into PLAN Key decisions unless they
   are also product/strategy locks. Grilling's **"design tree"** means decision topology — not this verb.

## Consequences

- Verb count is eight; ADR-0001's progressive-disclosure rationale still holds (one skill, verb bodies
  under `verbs/`).
- Pipeline narrative: `begin → (research*|design*) → plan → refine → next … → consolidate`, with
  `research`, `design`, and `grill` on demand (none of those three advance the Next-action pointer).
- Glossary must distinguish **design** (verb), **DESIGN.md** (run binding artifact), **design note**
  (`designs/`), and grilling's **design tree** (decision topology).
- `plan` _Avoid_ no longer lists "design" as a forbidden synonym for the thinking verb.

## Rejected

- **Required design step in the Next-action pipeline** — fights optional; forces empty work on non-UI runs.
- **Aesthetic sensors / visual scoring in the gate** — judgment call; verification bar stays exit-0 commands.
- **Separate design skill** — fragments `/junji` dispatch; ADR-0001 already rejected multi-skill verbs.
  (0006: *consuming* a host-repo design skill from `CONTEXT.md › Skills` is allowed; junji stays one method skill.)
- **Stitch/MCP or framework-specific codegen in the verb** — method must stay universal.
  (0006: no hardcoded vendor recipe; optional in-repo `SKILL.md` follow is not a recipe in the verb.)
- **Overwrite project/root DESIGN.md from the verb** — durable product system is repo-owned; run file is
  this-effort application.
- **Single rolling notes file without `designs/`** — hard to cite per reference; fights parallel research.
- **Scaffold `designs/` in `begin`** — folder should appear on first use only.
