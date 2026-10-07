# Verb: `iterate` — grill a post-execution delta onto the backlog

After every phase is `[done]`, add more work without consolidating. **Markdown only: write no product code.**
One call may append N independently-verifiable phases; the grilling *is* the plan (the exploration writes
the phase how-to contracts). Execution is `/junji next` or yokai.

Chat like `references/chat.md`. Write phase plans as **how-to contracts** and BACKLOG as **reference**
per `references/docs.md`. Crystallize locks like `verbs/grill.md`.

**Guard.** Stop unless all of these hold: name the miss and the verb to run instead:

- `.koi/run/PLAN.md` exists (else `/junji plan`).
- `.koi/run/BACKLOG.md` has **at least one** phase heading (else `/junji refine`).
- **Every** phase is `[done]`: no `[todo]`, no in-flight tag (`[planning]` / `[building]` / `[sealing]`)
  (else `/junji next` / yokai). Serial: illegal while any phase is not done.
- The user named a request. Missing → ask what to iterate, one line, stop.

`iterate` never occupies Next action.

1. **Gather.** Read `.koi/run/CONTEXT.md` (including **Skills**), `.koi/run/PLAN.md`, `.koi/run/BACKLOG.md` (Carry-forward +
   compacted phases). If `.koi/run/researches/` exists, **read every research note**. If
   `.koi/run/DESIGN.md` exists (or `CONTEXT.md › Design contract` names it), **read it**. Skim the
   implemented code enough to name what the request would change.
1b. **Activate design when needed.** Same as **`verbs/plan.md` step 1b**: human-facing surface and no
   `DESIGN.md` → follow **`verbs/design.md`** (or instruct `/junji design …`) before locking surface
   decisions. Pure backend / library / non-UI work: skip entirely.
2. **Reason.** Form a position on the request *before* grilling: what changes, what stays out, a candidate
   slice list (count, boundaries, `depends_on`, `[gated]`).
3. **Grill.** Follow **`verbs/grill.md`**. The frontier includes the slice list (how many phases, each
   phase's in/out, `depends_on`, and `[gated]`). Do **not** write phase
   files or BACKLOG headings until the frontier is empty and the user confirms shared understanding.
4. **Crystallize.** Already happening during the grill. New terms → `.koi/run/CONTEXT.md › Language`.
   New locks → CONTEXT (fact) + `PLAN.md › Key decisions` (rationale). Read `.koi/run/CONTEXT.md`
   before each of those edits and replace a span copied from that read. Do not rewrite PLAN's
   problem/approach unless the goal is reframed (standing override). Record bar changes in CONTEXT;
   Yokai must review its gate again before running. Visual locks → `.koi/run/DESIGN.md`.
5. **Write the backlog.** Continue `P{max+1}` (yokai only parses `P<digits>`). For each settled phase:
   - Append an ordinary heading: `### [todo] PN - title` (or `### [gated] [todo] PN - title`).
     Then one-line goal, source files, `depends_on` where it isn't obvious. Runtime tags are optional;
     preserve any annotations on existing phases without copying them onto new headings.
   - Write `.koi/run/phases/phase-NN-<slug>.md` from `templates/phase-plan.template.md`: full how-to
     contract (**Explicitly out**, numbered Approach). Pad NN to match siblings (usually two digits;
     yokai match is padding-robust). Never write under repo-root `phases/`. Do not mirror strategy or
     tier on the phase-plan `Status:` line.
   Re-read new headings for dependency order and human gates. Write **no product code**.
6. **Commit.** Conventional commit of the working-folder artifacts (PLAN / CONTEXT / BACKLOG / new phase
   files, DESIGN if touched). Honor Standing overrides (e.g. commit locally, never push). No product tree.
7. **Advance the pointer & stop.** Set `.koi/run/BACKLOG.md › Next action` to `/junji next`. First line:
   `Next action: /junji next`. Then the new phase goals (chat cap 5; full list in BACKLOG).
