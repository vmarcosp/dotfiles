# Autonomous driver — looping `next` without a human

The `junji` skill is the **per-phase intelligence**. To run a project unattended, a thin external
supervisor (e.g. a small Rust CLI, a shell loop, a CI job) replaces the human who types "do the next
task" and `/compact`. The supervisor carries **no work-intelligence**: it only enforces the objective
contract that the `next` verb already guarantees on disk. The shipped implementation is the
**yokai driver**: see [yokai run](https://koi.deno.dev/yokai/docs/run) for launch flags, TUI, and ledger.

This works because of the central insight: a fresh process *is* a clean context window. There is nothing
to compact between phases: state transfers through `.koi/run/`, not through a resumed
conversation. (TUI/ACP reattach of an interrupted mid-turn is ACP `session/resume`, not Claude CLI
`--resume`, and is not how the loop transfers state.) So the driver only has to *spawn*, then
*verify the contract held*.

**Onboarding.** Run interactive `yokai` on a prepared project. Missing reusable settings are saved in
`.koi/yokai.yml`; reviewed phase assessments and effort differences live in `.koi/run/yokai.yml`. The configured agent proposes
an executable gate from CONTEXT and project checks, then a human reviews commands, temporary smoke results and final saving. Compact fingerprints live
in durable settings. Per-phase tier/strategy/reason is reviewed separately through `yokai`,
through the helper or preparation wizard, then saved in effort YAML. Complete choices need no second
approval or fingerprint. Missing or incomplete assessments stop headless execution. Changed bars
or scripts require reconciliation. Headless startup only reports what is missing and writes no setup.
Neither onboarding nor execution needs the installed Junji skill: copied METHOD and CONTEXT are binding.
A failed valid check is kept and reported; it is never replaced with an easier bar.

**Precondition.** The driver presumes the project is already **planned**: a human (or an earlier step) ran
`begin` → `plan` → `refine` (and later `/junji iterate` if they wanted more work after the backlog emptied),
so `.koi/run/` exists with a populated phase list. The driver only loops `next`: it never creates the project strategy or backlog, grills,
iterates, or briefs. When no `[todo]` remain it surfaces consolidate (destructive); the human may `/junji iterate` instead.

## The loop

This is a minimal custom-driver example. The shipped Yokai driver uses ACP and enables recovery by default, as described below.

1. Parse `.koi/run/BACKLOG.md`; find first_runnable (`[planning]`/`[building]`/`[sealing]`, else first `[todo]`). None left → go to step 4.
2. If it's `[gated]`, **halt for a human**: never auto-run an irreversible/terminal phase *unless a human
   explicitly pre-authorized it*, such as `yokai --allow-gated`. Bare Yokai halts at human gates.
   Standing directives remain binding even with that flag.
3. Spawn a **fresh** Claude Code run (no `--resume`; the fresh process is the clean context):

   ```bash
   claude -p "Read .koi/run/METHOD.md and do the next task" \
     --output-format json \
     --permission-mode acceptEdits \
     --max-turns 300
   ```

   Then **verify the contract held**:
   - the phase is now `[done]` in `.koi/run/BACKLOG.md`,
   - a new commit exists (`git HEAD` advanced),
   - the verification bar from `.koi/run/CONTEXT.md` re-runs green (via every `.koi/sensors/*.sh`).

   If any check fails → halt (allow **one** retry in a fresh window for a stall, then stop). Otherwise
   loop back to step 1.
4. No runnable phases left: **do not** auto-run consolidate. Surface `/junji consolidate` for a human (it removes
   `.koi/run/`). They may `/junji iterate <request>` instead, then relaunch the driver.

## Why this is safe

The supervisor never decides *what the code should be*: it only checks that the same objective gate a
human would check (**phase marked done + commit exists + gate green**) passed on disk. The
verification bar defined in `plan` (runnable stack checks) is doing the real quality assurance; the
driver just refuses to advance until it's green. That is why wiring a strong, stable verification bar in
`plan` is the single highest-leverage decision for unattended runs.

### Safety envelope (halt conditions)

- **Complete:** no runnable phases remain → surface consolidate (or iterate), exit 0. Never auto-run
  `consolidate`.
- **Halt for human (not a failure):** the next phase is `[gated]` and the run was launched
  without explicit `--allow-gated`. Importing a plan never grants approval.
- **Halt on broken contract:** phase didn't mark itself `[done]`; or the gate re-run is red; or the work is left
  uncommitted / the tree is dirty. Never paper over a violated on-disk invariant. *Exception:* when
  **recovery** is on (default), yokai intercepts the miss: repair (green-gate bookkeeping, including
  transcription of `[done]`) then Diagnose → optional Fix → supervisor re-entry. Set `recovery: false`
  for fail-fast Halt. Cost ceiling, abort, and `--guarded` still Halt.
- **Liveness guard:** if two consecutive fresh windows fail to advance the *same* phase, that stall
  enters recovery when it is on (default); `recovery: false` Halts. Don't burn tokens respawning a
  stuck phase without Diagnose.
- **Budget guard (cost ceiling):** with `--max-cost <usd>` or `--max-tokens <n>`, the driver sums the ledger
  **before each phase's turn** and halts pre-turn once spend ≥ the ceiling: `cost ceiling reached`. Cost is the preferred meter (precise,
  agent-reported); tokens are the fallback. Both unset ⇒ unbounded.

Run on the project's dedicated branch (honoring the push policy in `.koi/run/CONTEXT.md › Standing overrides`);
optionally a git worktree per run for isolation. Keep a **run ledger** (one line per phase: phase id,
session id, turns, cost, gate result) so a human can audit the whole unattended run afterward.

## Plan → Build → Seal

Every phase runs **Plan → Build → Seal**: the only implementation path
([ADR-0039](https://github.com/getkoi/koi/blob/main/crates/yokai/docs/adr/0039-yokai-owns-build-and-recovery.md);
[Build](https://koi.deno.dev/yokai/docs/build) in the reading room). Yokai splits the `next` protocol across three acts, leaving the on-disk contract (and this safety
envelope) unchanged:

With `token_savings: true`, yokai reuses two conversations per phase: Plan, coder and Seal
(including corrections and bookkeeping repair), and judge (including repeated review
and diagnosis). Review is required; `[swarm]` phases run serially,
and agent delegation is prohibited. Reattachment failures or context exhaustion may
require replacements, so two is not a hard cap. Normal mode still uses fresh sessions.

1. **Plan**: an agent turn does steps 1-3 only: load state, research, write
   `.koi/run/phases/phase-NN-<slug>.md`, then **stop before implementing**. **Skipped** when exactly one
   matching phase file already exists (`iterate` writes these; same reuse as a killed Plan act).
2. **Build**: a loop converges the implementation (steps 4-5): a coder turn → run the gate
   (authoritative) + an advisory **judge** (a read-only review turn) → on red, append findings to
   `.koi/run/FEEDBACK.md` → repeat until the gate is green and the judge raises no blocking finding, or an
   iteration budget is spent (omit `max_iters` for unlimited). The judge can **veto** convergence (drive another iteration) but never
   **grant** it: only the gate decides green. If the loop can't converge, **recovery** (default on)
   Diagnoses and may grant another Build; `recovery: false` **halts before Seal** and leaves `.koi/run/FEEDBACK.md`.
3. **Seal**: an agent turn does steps 6-7: compact the backlog (`[done]`, carry-forward, Outcome) and make
   the one commit.

Yokai runs over the shared tori Connector. The driver wires the phase
plan in as its spec and the verification bar in as its authoritative sensors. See
[`crates/yokai/CONTEXT.md`](https://github.com/getkoi/koi/blob/main/crates/yokai/CONTEXT.md).

## Swarm (optional yokai knob)

Yokai fans out **inside one Build act** only when `swarm.enabled` is on **and** the reviewed phase mapping
selects `phases.PN.strategy: swarm` in the effort file. A split turn writes work items,
concurrent worker turns write isolated scratches under `.koi/run/swarm/`, and a merge turn is the only
product-tree writer. One work item skips the fan-out and uses today's single coder (or single judge).
Cap `max_workers` (default 8) is both item count and concurrency; over the cap, bad JSON, or any worker
error is a Build miss. Each later Build iteration splits the remaining work again. Phases assessed as `plain` stay a single coder even when swarm is enabled. This is not a junji verb. **next** in an
interactive window stays one serial phase. `yokai` controls whether the project permits swarms.

```yaml
swarm:
  enabled: true
  max_workers: 8
```

## Recovery (default on)

When a phase would Halt, yokai can keep the run moving: one **repair** turn if the miss is green-gate
bookkeeping, otherwise **Diagnose** (read-only) → optional **Fix** (run files only) → supervisor
re-entry (transcription of `[done]` or a full-Budget Build). Diagnose cannot Halt; unreadable JSON
grants Build. Cycles and **saves** (`.koi/run/saves/NNNN.md`; `RECOVERY.md` is the index) are
unlimited. `--max-cost` / `--max-tokens` (if set), user abort, and `--guarded` still Halt.

Reusable settings in `.koi/yokai.yml` (optional differences in `.koi/run/yokai.yml`):

```yaml
recovery: true    # default when omitted; false = halt immediately
```

Legacy nested maps still parse. Diagnose uses `roles.triage`. See the driver's ADR-0044 (amends 0010).
