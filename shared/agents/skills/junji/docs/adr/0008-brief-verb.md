# On-demand `brief` verb (chat-only product briefing)

## Status

Accepted

## Context

After some phases are `[done]`, a human who will use or review the product needs a short briefing:
what works now, how to run and check it, what to watch. Outcomes already sit on disk; Chat contract
already governs how windows speak. Neither is that briefing. ADR-0004 rejected `verbs/chat.md`
(chat is not a verb). Writing a `BRIEF.md` would fight “filesystem is durable memory” less than it
looks — it would add a file the next window must keep in sync — and the user asked for no document.

## Decision

1. **Add an on-demand `brief` verb** — tenth verb under the same progressive-disclosure skill.
   Requires `.koi/run/BACKLOG.md`. If no phase is `[done]`, stop (nothing shipped yet). Extra args
   ignored. Does not advance Next action. Yokai never calls it. `METHOD.md` is unchanged.
2. **Chat-only regenerable projection.** Read `[done]` Outcomes, BACKLOG (pointer, carry-forward),
   CONTEXT (toolchain, verification bar, use-affecting locks/overrides), and `DESIGN.md` when
   present. Do not read `PLAN.md` or `researches/`; do not inspect product source for invented
   how-to. Write nothing — any window can re-run `/junji brief` from the same folder.
3. **Product reader, operator first line.** First line: `N of M landed. Next action: /junji <pointer>`.
   Then three capped blocks in plain language (no method jargon): **Shipped** (synthesize current
   product state, not a phase changelog, ≤5 sentences); **Use** / **Check** from CONTEXT only
   (≤5 lines together; verification commands, not sensor paths; missing use → “no run guide on
   disk”); **Watch** (carry-forward, Explicitly out, use-affecting locks, DESIGN checks; ≤5 lines,
   extras dropped). Flag a missing tutorial; never write one.
4. **Name.** The verb owns **brief**. Source doc no longer lists `brief` under `_Avoid_`. Informal
   “a brief” for a source doc is a flagged ambiguity — do not use it.

ADR-0001’s one-skill progressive disclosure is unchanged (verb body under `verbs/`). Do not amend
ADR-0001’s historical “nine”.

## Consequences

- Verb count is ten. Pipeline narrative unchanged; `brief` joins `research`, `design`, and `grill`
  as on-demand (none of those four advances Next action).
- Glossary distinguishes **brief** (the verb) from **Chat contract**, **Outcome**, and **source doc**.
- Site/guide/README copy that said “nine verbs” updates in lockstep.

## Rejected

- **Report overlay / `verbs/chat.md`** — ADR-0004; chat is how every window speaks, not an ask.
- **`BRIEF.md` (or a research-note analogue)** — the briefing is regenerable from disk; storing it
  duplicates Outcomes and drifts.
- **Phase-by-phase changelog** — recaps steps; the reader wants what works now.
- **Live-code mini-tutorial in chat** — not objective, not “given the phases”; ADR-0004 no tutorials.
- **`/junji brief P3` filter** — v1 covers all `[done]` this run.
- **Yokai invoking brief** — driver carries no work-intelligence; this is a human ask.
