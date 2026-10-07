# Post-execution iterate verb

## Status

Accepted

## Context

Once every phase is `[done]`, the Next-action pointer names `consolidate`. That verb is destructive: it
collapses `.koi/run/`. Until now the method had no way to grill a delta against the *implemented* plan
and append work without starting a new project. `refine` reshapes a live list and does not write phase
plans; `/junji plan` would rewrite strategy. Unattended yokai already skips its Plan act when
`phases/phase-NN-*.md` exists, so a verb that writes those files can hand execution to `next` or yokai
without a second planning turn.

## Decision

1. **Add an on-demand `iterate` verb** — ninth verb under the same progressive-disclosure skill. Legal
   only after the original (or previous iterate) backlog has *executed*: `.koi/run/PLAN.md` exists, the
   backlog has at least one phase, and **every** phase is `[done]` (no `[todo]`, no in-flight tag). Serial — refuse while
   any phase is not done. Missing request → ask what to iterate, one line, stop. Empty or never-refined
   list → refuse (point at `refine` / `next`).
2. **Grill includes the slice list.** Reason, then frontier rounds (`verbs/grill.md`). Phase count,
   boundaries, `depends_on`, `[gated]`, and `[plain]` / `[swarm]` are decisions in the same tree. Do not write until the
   frontier is empty and the user confirms shared understanding. One call may append **N** independently
   verifiable phases. Human-facing request and no `.koi/run/DESIGN.md` → activate `design` the same way
   `plan` step 1b does.
3. **The exploration is the plan.** After confirmation, **select strategy** (`[plain]` or `[swarm]`) for
   each phase, continue `P{max+1}`, append that many BACKLOG headings **with the strategy tag**, and write
   a full `phases/phase-NN-<slug>.md` how-to contract for each (padding-robust so yokai skip-Plan matches).
   Write **no product code**. Chat reports `Strategy selected.` and lists each new phase with its tag.
   Crystallize like grill: terms → CONTEXT Language; locks → CONTEXT (fact) + PLAN key decisions
   (rationale). Do not rewrite PLAN's problem/approach unless the goal is reframed (standing override).
   Touch sensors only if grilling settles a bar change.
4. **Commit, then `next`.** Conventional commit of those working-folder artifacts, honoring Standing
   overrides. Set Next action to `/junji next`. `iterate` never occupies the pointer (it needs a human
   request). When those phases complete, the pointer returns to `/junji consolidate`; chat also names
   `/junji iterate <request>` as the way to add more work.
5. **`refine` yields once the list is done.** Live list (any phase not `[done]`) may still reshape. When
   every phase is `[done]`, `refine` does not add work — tell them to `/junji iterate`. `next` / METHOD
   (new begins only) skip rewriting a matching phase file; still load and phase-research, then implement.
   Do not patch in-flight `METHOD.md`.
6. **Driver stays dumb.** Yokai does not grill. Plan act already skips when the phase file exists. Only
   the complete-state hint mentions iterate as the non-destructive alternative to consolidate.

## Consequences

- Verb count is nine; ADR-0001's progressive-disclosure rationale still holds (one skill, verb bodies
  under `verbs/`).
- Pipeline narrative: `begin → (research*|design*) → plan → refine → next … → (iterate → next …)* →
  consolidate`, with `research`, `design`, and `grill` on demand (none of those three advances the
  Next-action pointer). `iterate` moves the pointer only `consolidate → next`.
- Glossary must distinguish **iterate** (the method verb) from yokai Build **iteration** (one coder/judge
  pass inside a phase).
- `next` step 3 becomes "write or reuse": a matching `phase-NN-*.md` is the spec.

## Rejected

- **Stacking while `[todo]` remain** — mixes two grilled requests; serial iterate → next → iterate keeps the
  guard honest.
- **One task per call, no split** — a large request still has to become independently-verifiable phases;
  the grill decides how many.
- **BACKLOG heading only** — yokai Plan act would re-plan and can drift from the grill. The exploration
  writes the spec.
- **`iterate` as Next action** — headless windows have no request; the pointer stays `consolidate` until
  a human invokes iterate, then `next`.
- **Auto-consolidate after iterate** — iterate *adds* work; consolidate stays a human (destructive) verb.
- **Driver-owned grilling** — yokai carries no work-intelligence; iterate is a human skill verb.
- **Patch in-flight METHOD.md** — that file is stable after `begin`. Skill `next.md` and yokai
  skip-Plan cover existing runs.
