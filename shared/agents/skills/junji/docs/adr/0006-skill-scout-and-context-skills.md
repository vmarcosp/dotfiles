# Skill scout at begin; roles consume CONTEXT › Skills

## Status

Accepted — amends [0003](0003-design-verb-and-run-design-md.md) (in-repo design skills
are in-bounds; hardcoded vendor MCP recipes are not).

## Context

A host repo often already names the skills a coding agent must follow (`AGENTS.md`,
`DESIGN.md`, `CLAUDE.md`, and siblings) and keeps those skills on disk. Until now
junji's `design` verb was universal-only (no product MCP, no codegen recipes) and
`next` / yokai coder/judge had no on-disk map of which `SKILL.md` files apply to
which role. Fresh windows guessed. Yokai's judge prompt was spec-only and never
saw the map.

## Decision

1. **`begin` gains a Skill scout step** — still facts only, still not a new verb.
   Reconnaissance (yokai ADR-0007) remains the name of begin's whole survey; **Scout**
   is this step. Project docs that exist (`AGENTS.md`, `CLAUDE.md`, `DESIGN.md`,
   `PRODUCT.md`, `.cursor/rules`) name **Must** skills and any *when* clause as
   written. In-repo `SKILL.md` trees (`.claude/skills/`, `.cursor/skills/`,
   `.agents/skills/`, `skills/`) are the **catalog** that resolves names to paths.
   Skip `junji` and `yokai`. Unnamed catalog entries are **Available**, never silently
   Must. Vague assignments are marked guesses; `plan`/`grill` canonicalize. Begin
   does not grill.
2. **Record in `CONTEXT.md › Skills`** — own section (not File map, not Design
   contract): Must, Available, and a **by-role** index. Roles are junji `design` /
   `next` and yokai `plan` / `coder` / `judge` / `seal` (ADR-0038 names). No
   per-phase bindings at begin — phases do not exist yet. Triage/repair omitted
   unless a project doc names a recovery skill.
3. **Consumers follow their Must rows.** `design` follows Must-for-`design`, else
   may pick among **design-flavored** Available skills (grill if several). `next`
   implement follows Must-for-`next` whose *when* matches the phase. Coder/judge/seal
   do **not** load Available. Junji still owns `.koi/run/DESIGN.md`; a skill that
   would write repo-root `PRODUCT.md` / `DESIGN.md` is redirected to the run files.
   Grill any unsettled visual decision or which of several design skills — not
   whether to obey a Must row.
4. **Yokai judge reads the map** — driver ADR-0043. Coder already receives
   `CONTEXT.md` as a file guide; METHOD plus a one-liner on the coder prompt make
   Skills unmissable. Do not inject every `SKILL.md` as extra tengu `build.guides`
   (Guide ≠ Skill). No global harness plugins; in-repo only.

## Consequences

- Glossary: **Skill scout**, **Skills** (CONTEXT section), **Design skill** (visual
  subset). Flagged: scout vs reconnaissance vs yokai Guide.
- `plan` keeps begin's Skills section unless grilling settled a different assignment.
- Hardcoded Stitch/MCP / framework codegen in `verbs/design.md` stay rejected (0003).
  Consuming an in-repo design skill is allowed. A separate junji design skill is still
  rejected (ADR-0001).

## Rejected

- **New `/junji scout` verb** — fragments dispatch; scout is reconnaissance, not a
  pipeline stage.
- **Per-phase skill list at begin** — inventing phase-03 bindings is a decision;
  refine has not run.
- **Every in-repo SKILL.md is Must** — leftover skills are not standing orders.
- **User-global `~/.claude/skills`** — yokai/`next` windows only share the repo.
- **Inject Must SKILL.md paths as tengu File guides** — duplicates CONTEXT and
  conflates Guide with Skill.
