# <project> — plan

**Explanation: why this approach.** Written for a human. Binding execution facts live in `CONTEXT.md`
(CONTEXT wins for execution; this file wins for rationale). Not a how-to and not phase-by-phase.

> The filesystem is the durable memory. The context window is a disposable cache.

## Problem / request

<What are we being asked to do, and why does it matter? State the request in the user's terms, then the
underlying problem it solves. One or two paragraphs: enough that a newcomer understands the point.>

## Chosen approach

<Describe the major parts and how they fit into the existing system. Explain the strategy here. Leave the phase sequence to refine.>

## Reasoning & alternatives

<Explain why this approach won, which assumptions were challenged, which alternatives you rejected, and the trade-offs. Give future readers enough context to avoid reopening settled decisions.>

## Key decisions

The decisions that came out of grilling, each with its rationale. The terse, binding form of these is
mirrored into `CONTEXT.md › Locked decisions`; here they keep their argument.

- **<Area>:** <decision> — <why this, not the alternative; what it costs us>.
- **<Area>:** <decision> — <rationale>.

## Success criteria

<What "done and good" looks like at the project level — the outcome, not the per-phase gate (the concrete,
automatable gate lives in `CONTEXT.md › Verification bar`). What must be true for this to have worked?>

## Open questions

<Anything still unresolved that `grill` should chew on, or that a human must answer before `refine`. Empty
once the plan is solid.>
