# Verb: `refine` — decompose the plan into phases, then reshape

Two modes, one verb. Re-plan without touching code. Chat like `references/chat.md`.
Write the phase list in BACKLOG as **reference** per `references/docs.md`.

**First run: decompose.** Read `.koi/run/PLAN.md` and `.koi/run/CONTEXT.md` and turn the plan
into an ordered phase list in `.koi/run/BACKLOG.md`:

1. Break the work into coherent, independently-verifiable phases. Order dependencies before
   dependents; record `depends_on` wherever it is not obvious.
2. Flag irreversible, destructive, or human-decision phases `[gated]`. Importing or refining a
   plan does not authorize these actions. Preserve standing directives.
3. Write ordinary headings with a status and phase ID. Strategy and model-tier tags are optional
   legacy annotations, not planning decisions Junji requires. Preserve existing annotations when
   reshaping; do not add them to ordinary headings. Yokai owns execution choices outside the backlog.
4. Set `Next action` to `/junji next`.

```text
### [todo] P0 - First real slice
Goal. Source files. What to read. Acceptance checks.

### [todo] P1 - Follow-up slice
depends_on: P0.

### [gated] [todo] P2 - Irreversible step
GATED: explicit human go-ahead. depends_on: P1.
```

After execution, `next` compacts a finished phase without adding runtime metadata:

```text
### [done] P0 - First real slice
One-line outcome. Verification green. → `.koi/run/phases/phase-00-first-slice.md`.
```

**Later runs: reshape.** While any phase is unfinished, split unrelated work, merge slices too
small to verify alone, and reorder dependencies. Preserve completed progress and user content.
If a locked decision changes, record the directive in CONTEXT, mirror its rationale in PLAN,
and re-scope affected phases. Do not silently renumber existing phases: runtime overrides may
refer to their IDs, so flag any necessary ID changes for Yokai configuration review.

**All phases done:** point to `/junji iterate <request>`; do not append work through `refine`.

Keep edits to BACKLOG, with CONTEXT/PLAN only for changed decisions. Write no product code and
no phase plans. Report `Next action: /junji next`, the decomposition result, and a numbered phase
list (chat cap 5; full list in BACKLOG). No runtime configuration or sensor scripts are required.
