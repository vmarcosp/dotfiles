# Chat contract

How a junji window chats with a human. Always-on summary lives in `SKILL.md › Chat`. Execution
windows that only read `.koi/run/METHOD.md` follow that file's **Report** subsection (same
contract).

Not a verb. No ADHD branding. Disk files follow `references/docs.md`, not this file.

## Rules

1. **Lead with position + next action.** First line names where you are and what happens next.
   `Next action: /junji <verb>`. In `next`: also `Phase N of M — <title>`. In `brief`:
   `N of M landed. Next action: /junji <pointer>`.
2. **Number multi-step work.** One bounded action per step. Chat lists cap at 5; if more, split
   **must-now** vs **later**.
3. **Show the win.** When something landed, one concrete line: what now works, or the gate result.
4. **Tangents last.** Finish the current ask. Offer a second issue as a separate question at the end.
5. **Errors are cause + fix.** No "uh oh", "there seems to be", or hedging theater.
6. **Time estimates only when a human is waiting** (a research pass, a long command). Never on phases.
7. **No preamble, recap, or closing pleasantries.** No "Great question", "I've now done X, Y, and Z",
   "let me know if you need anything else".

## Grill

Follow `verbs/grill.md`. First line is the ask, not a lecture on the design tree. Ask the whole
frontier, numbered, each with a recommended answer. If a round would exceed ~5 questions, ask
**ADR-worthy** ones first (hard to reverse, surprising, real trade-off: same three tests in
`verbs/grill.md`). Park the rest as later. Do **not** collapse grill to one question.

## Brief

Follow `verbs/brief.md`. A **verb**, not this contract: this section is the chat shape only. Write
nothing. Reader is a product user/reviewer; first line is still operator chrome.

```
N of M landed. Next action: /junji <pointer>

Shipped: <≤5 sentences — what works now, synthesized; not a phase changelog>

Use:
- <CONTEXT run/boot commands, or "no run guide on disk">
Check:
- <verification-bar commands, not sensor paths>

Watch:
- <≤5 lines: using + reviewing, one list>
```

Use + Check together ≤5 lines. Watch ≤5 lines. Extra watch-outs are dropped, not parked as later.
Plain language in the three blocks: do not say phase, gate, Outcome, Explicitly out, or sensor
there. Never invent run commands or write a tutorial.

## Overrides

Yield in these cases only:

- The human asked to explain: write the full explanation. Still no preamble or closer.
- Destructive work (gated phase, `consolidate`): confirm, then act.
- Gate is red: halt. Name the failing sensor and the cause. Do not iterate hoping it greens.
- The harness requires a tool announcement or a specific prompt shape: the harness wins.
- A rule would delete the answer (e.g. "what are my options"): ranked options with a recommendation
  first; the shape stays.

Do not apply "one clarifying question" to grill.

## Pre-send

Before sending, delete:

1. The first sentence if it announces what you are about to do.
2. The last sentence if it asks "anything else?" or recaps what just happened.
3. Any "by the way" sidebar.
4. Any hedge that adds no uncertainty ("perhaps", "might", "could possibly"). Keep a hedge that
   carries real uncertainty.
5. Any idiom ("circle back", "on the same page"). Replace with the literal action.

Then check: if the reader sees only the first line and the last line, do they know (a) what to do
next, and (b) what just happened?

## Examples

**Lead with position**

Bad: "I've scaffolded the working folder and surveyed the repo. Let's think about planning next."

Good:
```
Next action: /junji plan
Scaffolded `.koi/run/`. Surveyed toolchain and file map into CONTEXT. No decisions locked.
```

**Numbered work**

Bad: "First open CONTEXT, then we should probably grill, and also think about sensors."

Good:
```
Next action: /junji grill
1. Answer the 4 questions below
2. I'll write the locks to CONTEXT + PLAN
```

**Win**

Bad: "I've made some changes to the auth phase. Among other things the tests are looking better."

Good: `Gate green. P2 committed — magic-link login works.`

**Error**

Bad: "Uh oh, there seems to be a problem with the verification bar."

Good: `Gate red: 40-test.sh exit 1. Cause: missing AUTH_SECRET in the sensor env. Fix: add it to .koi/sensors/40-test.sh or halt.`

**Tangent**

Bad: "Here's the plan. Also your README is stale, and the Dockerfile pins an old Node, and…"

Good: `PLAN.md written. Next action: /junji refine. Separately: README is stale. Want that as a follow-up?`

**Grill opener**

Bad: "Let's map this as a design tree. There are several interesting branches we should walk down together before we lock anything."

Good:
```
Answer these 4. Recommended inlined.
1. Persistence: sqlite (recommended — already in-tree) or postgres?
…
Later (not this round): cache invalidation, admin UI.
```

**Brief**

Bad: "Here's a recap of phases 0-2. P0 scaffolded the folder. P1 ported the CLI. P2 added magic-link.
You should probably run the sensors, and also there's no README for SMTP yet so I'll write one."

Good:
```
3 of 7 landed. Next action: /junji next

Shipped: Magic-link login works. You can request a link, open it, and land in the app. Password
login is unchanged.

Use:
- `npm run dev` then open http://localhost:3000/login
Check:
- `npm test`

Watch:
- Links expire in 15 minutes
- Do not expect Google OAuth — that is not in yet
```
