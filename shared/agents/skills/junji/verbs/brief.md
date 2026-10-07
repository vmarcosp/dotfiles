# Verb: `brief` — chat-only product briefing

Return a short briefing for a human who will **use or review** the product: what works now, how to
run and check it, what to watch. Synthesize from `[done]` phase Outcomes and CONTEXT: a
**regenerable projection**. Write nothing. Extra arguments after `brief` are ignored.

**On demand.** Optional; run any time after `begin`. Does **not** advance `.koi/run/BACKLOG.md › Next
action`. Distinct from **Chat contract** (how every window speaks) and from **Outcome** (the on-disk
paragraph `next` writes). The autonomous driver never calls this verb.

Chat like `references/chat.md` (Brief subsection). Do not write working-folder files.

## Prerequisites

- Requires `.koi/run/BACKLOG.md` (a real `begin`). If missing, say so and stop: point at `/junji begin`.
  Do **not** scaffold the working folder from this verb.
- If no BACKLOG heading is `[done]`, stop. First line: `0 of M landed. Next action: /junji <pointer>`.
  Then: `Nothing shipped yet.` Do not preview `PLAN.md`.

## Protocol

1. **Read (working folder only).**
   - `BACKLOG.md`: Next action, phase headings (count M, count N = `[done]`), carry-forward.
   - Every `[done]` phase plan: **Outcome** and **Explicitly out** only. Skip Approach.
   - `CONTEXT.md`: toolchain, file map, verification bar, Locked decisions and standing overrides that
     affect **use**, not strategy rationale.
   - `.koi/run/DESIGN.md` when present: UI review checks only.
   - Do **not** read `PLAN.md` or `researches/`. Do **not** inspect product source or README to invent
     how-to. Follow CONTEXT pointers only as already recorded commands.

2. **Chat: operator chrome, then three blocks.** Shape SSOT: `references/chat.md` › Brief.

   First line: `N of M landed. Next action: /junji <whatever BACKLOG already says>`.

   Then, in **plain language** (read method terms; do not say phase, gate, Outcome, Explicitly out,
   sensor in these blocks):

   ```
   Shipped: <≤5 sentences — current product state, synthesized from all [done] Outcomes this run
   (including prior iterate batches). Not a phase changelog. In-flight work stays out.>

   Use:
   - <run/boot commands already in CONTEXT toolchain or file map>
   Check:
   - <verification-bar *commands*, not `.koi/sensors/*.sh` paths>
   ```

   Use + Check together ≤5 lines. If CONTEXT has no use/boot command: one line `no run guide on disk`.
   Never invent `npm start` (or any command not recorded). If a tutorial the reader would need is
   missing: one line that it is needed and not on disk: do not write the tutorial.

   ```
   Watch:
   - <≤5 lines: using + reviewing, one list>
   ```

   Watch sources: carry-forward, Explicitly out of `[done]` phases, use-affecting locks/overrides,
   DESIGN.md checks if present. Extra watch-outs are **dropped**, not parked as later.

3. **Stop.** Write nothing. Do not edit PLAN/CONTEXT/BACKLOG/phases. Do not start another verb unless
   the user asked.

## Rules

- Finding *what shipped* is this verb's job; *decisions* belong to grilling.
- The briefing is not stored. Re-run `/junji brief` after more phases `[done]` to refresh it.
- `consolidate` removes the sources with `.koi/run/`: after that this verb is illegal (no BACKLOG).

## Worked example

```
3 of 7 landed. Next action: /junji next

Shipped: Magic-link login works. You can request a link, open it, and land in the app. Password
login is unchanged.

Use:
- `npm run dev` then open http://localhost:3000/login
Check:
- `npm test`
- `npx tsc --noEmit`

Watch:
- Links expire in 15 minutes — don't treat them as standing sessions
- Dev prints the email in the console; production SMTP is not this slice
- Do not expect Google OAuth — that is not in yet
```
