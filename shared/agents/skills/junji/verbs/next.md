# Verb: `next` — run one phase end to end

The core per-phase protocol. **One phase per execution: never start the next one.** A human types "do the
next task"; an autonomous driver calls this in a loop. Driver loop, harnesses, and recovery:
`references/autonomous-driver.md`.

Chat like `references/chat.md`. Report per `.koi/run/METHOD.md › Report`. Write the phase plan as a
**how-to contract** per `references/docs.md` (numbered Approach).

Backlog headings use tags. Pick **first_runnable**: the first
`[planning]` / `[building]` / `[sealing]`, else the first `[todo]`. Two in-flight tags → stop and tell
the human to leave only one. Yokai writes the same tags before each act; this verb writes them at the
matching steps below.

1. **Load state.** Read `.koi/run/CONTEXT.md` (including **Skills**), `.koi/run/BACKLOG.md` (status + Carry-forward), and
   `.koi/run/METHOD.md`. If `.koi/run/DESIGN.md` exists (or `CONTEXT.md › Design contract` names it),
   **read it**: binding for any human-facing output in this phase. Pick `first_runnable`.
   **If it is `[gated]`, stop and ask the human: do not proceed** (unless this run pre-authorized gated
   phases explicitly, e.g. `yokai --allow-gated`; standing directives still apply).
2. **Phase research.** Read the exact source files the phase names. Study idiomatic patterns for the slice.
   Bar: faithful to current behavior **and** idiomatic, clean, lint-passing. (Distinct from the optional
   `research` verb: that writes cited notes under `.koi/run/researches/` for plan/grill.)
3. **Write the phase plan.** If status is `[building]` or `[sealing]`, or exactly one matching
   `.koi/run/phases/phase-NN-*.md` already exists (NN = this phase's numeric id; `iterate` writes these;
   yokai skips Plan when they exist), **reuse it**: do not rewrite. Otherwise set the heading to
   `[planning]` (keep `[gated]`, `[plain]` / `[swarm]`, and `[low]` / `[medium]` / `[high]` / `[ultra]`
   if present) and create the file from `templates/phase-plan.template.md`.
   Fill "Goal & scope" with an explicit **Explicitly out** list: that list stops scope creep.
   **Approach** is a numbered recipe, one bounded action per step. If the phase touches a human-facing
   surface and `DESIGN.md` exists, cite it under constraints / approach. If Skills Must lists **plan**,
   follow those `SKILL.md` files while writing the phase plan. Never write under repo-root
   `phases/`. The phase-plan `Status:` line points at the BACKLOG heading; do not mirror tags there.
4. **Implement.** If status is `[sealing]`, skip to step 6. Otherwise set the heading to `[building]`
   (keep `[gated]`, `[plain]` / `[swarm]`, and any existing tier tag; never leave a reused plan as `[planning]`). On the project's fixed branch (from
   `.koi/run/CONTEXT.md › Standing overrides`), scoped strictly to this phase. When shipping
   human-facing UI, obey `.koi/run/DESIGN.md` with the same weight as Locked decisions. Follow
   **Skills** Must rows for `next` whose *when* matches this phase (read those `SKILL.md` files and the
   files they say to load). Do not load Available. Resist adjacent improvements: record them as
   follow-ups in the phase plan.
5. **Verify.** Run every documented command in `.koi/run/CONTEXT.md › Verification bar`, from
   its documented working directory. Existing `.koi/sensors/*.sh` may be reused when they implement
   that bar; scripts are optional for manual Junji. Every command must exit 0. Never weaken the bar
   to pass: fix the root cause or halt. Preserve failing checks and leave the phase `[building]`.
6. **Compact the backlog.** Set `[sealing]`, then mark the phase `[done]` with a 1-2 line summary
   (keep `[gated]`, `[plain]` / `[swarm]`, and any existing tier tag).
   Move any decision or discovered fact later phases depend on into **"Carry-forward decisions"**.
   Trim the finished phase; keep the next one detailed. Add an **Outcome** section to the phase plan.
   Update `Next action` (`/junji next` while `[todo]` or in-flight phases remain, else
   `/junji consolidate`). When pointing at consolidate, the Report also names
   `/junji iterate <request>` as the way to add more work. _If a driver is running unattended, make
   carry-forward and Outcome fatter and self-contained: they are the only memory the next window inherits._
7. **Commit.** Conventional commit, honoring Standing overrides (e.g. "commit locally, never push").
   Open/update the phase PR if that's the project's flow. Before staging: put regenerable noise (deps,
   build outs, test/tool caches) in `.gitignore` and do not commit it as part of the phase deliverable.

Report per METHOD › Report: `Phase N of M — title`, then `Next action`, then the win (gate result +
one-line summary now in BACKLOG). When Next action is consolidate, also name `/junji iterate <request>`.
Halt: failing sensor + cause, not a recap of the seven steps.
