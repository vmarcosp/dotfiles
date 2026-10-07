# Method

**How-to: the recipe for "do the next task."** Stable: copied verbatim by `begin`, never edited per
phase. Project facts live in `.koi/run/CONTEXT.md`; position lives in `.koi/run/BACKLOG.md`.

> The filesystem is the durable memory. The context window is a disposable cache.
> Write every decision, plan, and learning to `.koi/run/` *before* the window ends.
> Skill files live under `.koi/run/`; sensors live under `.koi/sensors/`. Never create `phases/`, `PLAN.md`,
> `CONTEXT.md`, `BACKLOG.md`, or `sensors/` at the repo root.

This file governs the **execution** loop. Getting here is `begin` (scaffold) → `plan` (write
`.koi/run/PLAN.md`, define the verification bar) → `refine` (decompose `.koi/run/PLAN.md` into the phase list
below); from then on every "do the next task" runs `next`. After every phase is `[done]`, a human may
`/junji iterate` to grill more work onto the backlog, then `next` again.

## On "do the next task" (= `/junji next`)

1. **Load state.** Read `.koi/run/CONTEXT.md` (including **Skills**), `.koi/run/BACKLOG.md` (status + "Carry-forward decisions"), and
   this file (`.koi/run/METHOD.md`). If `.koi/run/DESIGN.md` exists (or `CONTEXT.md › Design contract`
   names it), read it: binding for human-facing output. Pick **first_runnable**: the first
   `[planning]` / `[building]` / `[sealing]`, else the first `[todo]`. Two in-flight tags → stop.
   **If it is `[gated]`, stop and ask a human: do not proceed** (unless this run says gated phases are
   pre-authorized: e.g. an explicit `yokai --allow-gated`; standing directives still apply).
2. **Phase research.** Read the exact source files the phase names. Study idiomatic patterns for the slice. The
   bar: faithful to current behavior AND idiomatic, clean, lint-passing.
3. **Write the phase plan.** If status is `[building]` or `[sealing]`, or exactly one matching
   `.koi/run/phases/phase-NN-*.md` already exists for this phase, **reuse it**: do not rewrite
   (`iterate` writes these; the driver skips Plan when they exist). Otherwise set `[planning]`
   (keep `[gated]`, `[plain]` / `[swarm]`, and any existing tier tag) and
   create it from the phase-plan template. NN is the heading number, zero-padded: `P0` →
   `phase-00-<slug>.md`, not `phase-01`. Fill the **Explicitly out** list — it is what
   prevents scope creep. **Approach** is a numbered recipe. If the phase ships UI and `DESIGN.md` exists,
   cite it under constraints. If a Must row lists **plan**, follow those `SKILL.md` files while writing
   the phase plan. Never write under repo-root `phases/`. The plan's `Status:` line points at
   the BACKLOG heading; do not mirror tags there.
4. **Implement.** If status is `[sealing]`, skip to step 6. Otherwise set `[building]` (keep `[gated]`,
   `[plain]` / `[swarm]`, and any existing tier tag; never leave a
   reused plan as `[planning]`). On the fixed branch (see `.koi/run/CONTEXT.md › Standing overrides`), scoped
   strictly to this phase. Obey `.koi/run/DESIGN.md` for human-facing surfaces when present. Follow
   `CONTEXT.md › Skills` Must rows for **next** / **coder** whose *when* matches this phase (read those
   `SKILL.md` files). Do not load Available. Do not start the next phase. Record adjacent ideas as
   follow-ups, don't act on them.
5. **Verify.** Run every documented command in `.koi/run/CONTEXT.md › Verification bar`, from
   its documented working directory. Existing `.koi/sensors/*.sh` may be reused when they implement
   that bar; scripts are optional for manual Junji. Every command must exit 0. Never weaken the bar
   to pass: fix the root cause or halt. Preserve failing checks and leave the phase `[building]`.
6. **Compact the backlog.** Set `[sealing]`, then mark the phase `[done]` with a 1-2 line summary
   (keep `[gated]`, `[plain]` / `[swarm]`, and any existing tier tag). Move anything later phases depend on into
   "Carry-forward decisions". Trim the finished phase; keep the next
   detailed. Add an **Outcome** section to the phase plan. Update `Next action` (`/junji next` while
   `[todo]` or in-flight phases remain, else `/junji consolidate`). (When run unattended, make
   carry-forward + Outcome fatter and self-contained.)
7. **Commit.** Conventional commit, honoring `.koi/run/CONTEXT.md › Standing overrides`. Open/update the
   phase PR if that is the project's flow. Before staging: put regenerable noise (deps, build outs,
   test/tool caches: e.g. `node_modules/`, `dist/`, `target/`, coverage) in `.gitignore` and do not
   commit it as part of the phase deliverable.

> **Driver split (optional).** An autonomous driver may run these steps as three acts across separate fresh
> windows: *Plan* (1-3), *Build* (4-5, possibly a self-correction loop against the gate), *Seal*
> (6-7). The driver writes `[planning]` / `[building]` / `[sealing]` before each act; Seal writes
> `[done]`. The steps and the definition of done are identical; only who runs each changes.

## Rules

- **One phase per execution.** Junji, not batched. After that phase's compact + commit, **stop**: never
  continue to the next phase in the same window (the driver or a human starts the next turn).
- **Never consolidate unattended.** When no `[todo]` or in-flight phases remain, set `Next action` to
  `/junji consolidate` and stop. Do **not** run consolidate, `git rm -r .koi/run/`, or otherwise delete
  `.koi/run/` unless a human (or an explicit `/junji consolidate` invocation) asked for that destructive
  collapse. Adding more work after that is `/junji iterate`, not this file.
- Keep `.koi/run/CONTEXT.md` and this file stable; churn lives in `.koi/run/BACKLOG.md` (compacted) and
  `.koi/run/phases/`. When a locked decision does change CONTEXT, read `.koi/run/CONTEXT.md` first and
  replace a span copied from that read, whitespace included. Do not search for a template placeholder
  or a glossary example that the read does not show.
- Follow the repo's code style and commit conventions (see `.koi/run/CONTEXT.md`). Honor **Skills** Must
  rows for this act.
- Never weaken lint/test/typecheck or any sensor to pass. Fix root causes.
- Report what the gate actually says. If a metric is misleading, frame it honestly rather than shipping a
  flattering-but-wrong number.

## Report

When a human is reading (chat or TUI). Unattended: still no bloat in chat; Outcome + carry-forward on
disk stay self-contained.

1. First line: `Phase N of M — <title>`. Then `Next action: /junji next` (or `/junji consolidate`).
   When pointing at consolidate, also name `/junji iterate <request>` as the way to add more work.
2. The win or the ask, in one concrete line (gate green/red; what now works).
3. If gated or halted: cause + what the human must do.
4. No preamble, no recap of the seven steps, no "let me know".

## Definition of done (per phase)

The phase's Acceptance checklist is all checked AND every command in
`.koi/run/CONTEXT.md › Verification bar` exits 0 AND the change is committed per the standing overrides.

## Definition of done (whole effort)

Every phase is `[done]`, the full corpus passes the verification bar, and `consolidate` has collapsed
`.koi/run/` into the single deliverable spec (per `.koi/run/CONTEXT.md › Deliverable spec model`). Any
`[gated]` terminal phase runs only on explicit human go-ahead.

## Phase-plan template

See `.koi/run/phases/`: each plan follows `phase-plan.template.md`: Outcome · Goal & scope (in /
**Explicitly out**) · Port from · Approach (numbered) · Risks & mitigations · Tests & parity gate ·
Acceptance checklist. Phase status lives on the BACKLOG heading, not on the plan's `Status:` line.

## Optional handoff to Yokai

These repository files are sufficient for a driver; the Junji skill need not be installed on the
execution machine. Prepare CONTEXT (including runnable verification commands and standing directives),
METHOD, and a populated BACKLOG with dependency order and human gates. Phase plans may already exist.
Run `yokai` to configure reusable settings, review and smoke-test its executable sensor gate, and
review phase assessments before choosing whether to start. Headless execution requires this preparation in advance. No raw-goal intake is implied.

Yokai keeps runtime settings and compact gate fingerprints in `.koi/yokai.yml`. Reviewed per-phase
tier/strategy assessments and effort differences belong in `.koi/run/yokai.yml`. New or changed phase
scope can be assessed through the helper or explicit CLI. Human-approved YAML needs no second CLI
approval or fingerprint. Never put runtime choices in method Markdown. Junji alone does not require this mapping; ordinary headings remain unchanged
except for progress. Preserve legacy annotations when present. Approving configuration, assessments or sensors
does not approve `[gated]` phases. Never let automation override standing directives.

Consolidation removes all of `.koi/run/`, including overrides, sessions, recovery and budget accounting.
The rest of `.koi/` survives. Existing customized METHOD/CONTEXT copies remain authoritative; adopt
new method text only by a reviewed merge of the template changes, preserving local directives.
