# Verb: `consolidate` — collapse the working folder into one repo-native spec

Replace the execution record with the *documentation* a later reader wants. `.koi/run/phases/` is a
*build log*; the deliverable is the spec. **Destructive to the working folder**: only `.koi/run/` is
removed; durable project home (`sensors/`, `yokai.yml`, …) survives. Git history is the archaeology.

Chat like `references/chat.md`. Write the deliverable per `references/docs.md`: host outline verbatim;
narrative default is explanation + locked facts, not a changelog. Confirm before collapsing.

1. **Guard.** Refuse unless **every phase is `[done]`**: never collapse a live project. (A `[gated]` terminal
   phase must already have run on human go-ahead, or been explicitly waived.)
2. **Read** every `.koi/run/phases/phase-*.md` (especially **Outcome**),
   `.koi/run/BACKLOG.md › Carry-forward decisions`, `.koi/run/PLAN.md`, and `.koi/run/CONTEXT.md`,
   including **Deliverable spec model**.
3. **Render in the repo's spec model.** Produce the document in the **section outline recorded in
   CONTEXT › Deliverable spec model, verbatim**. Map: **what the system is** + **locked decisions** (settled
   facts); a **concise phase-by-phase story** (drop risks-that-didn't-fire, scaffolding, acceptance
   checklists); **carry-forward** folded into design-notes/gotchas. Documentation, not a diff log: no
   tutorial, no per-phase checklist dump. _(No model recorded: older project? Fall back to explanation +
   locked facts in that same shape.)_
4. **Write to the model's home**: location + filename from Deliverable spec model (repo native spec home,
   else `specs/`), **named for what was delivered, never `SPECIFICATION.md`** (fallback: `specs/<slug>.md`).
5. **Collapse the working folder.** `git add` the new spec, then `git rm -r .koi/run/` (PLAN, CONTEXT,
   METHOD, BACKLOG, phases, and driver-owned `yokai.yml`/`ledger.jsonl`/`sessions.jsonl` (and any legacy `config.yml`),
   all of it) in a **single commit**. Durable project home stays. The deliverable is the only new survivor
   from the run scaffolding.
6. **Report.** First line: the new file's path. Confirm `.koi/run/` was collapsed into it.
