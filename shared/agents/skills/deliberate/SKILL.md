---
name: deliberate
description: Get an unanchored outside opinion before a decision that is not obvious — a halt in a run, a red gate, a scope or design call, a fix with several valid paths — at one of three levels (quick, standard, council). The brief carries the situation, the evidence and the options, never the orchestrator's conclusion; the orchestrator decides and records both views. Use when the orchestrate skill or Marcos's mandate asks for a second opinion, or when Marcos says "deliberate", "/deliberate quick|standard|council", "get a second opinion", "ask Fable".
---

`/deliberate [quick|standard|council] [model=<model>]`. An opinion is worth something only if the
consultant cannot see which way you lean: write the brief as if you had not decided, then decide
yourself after reading the answer.

## Levels

```
            quick                     standard (default)             council
who         1 × Opus (low effort)     1 × Fable (high effort)        Fable + Opus, independent:
                                                                     same brief, no cross-talk
brief       Situation, Options,       all five parts                 all five parts + "argue the
            Question (short)                                         strongest case against each option"
answer      ≤ 10 lines                ranked view, what would        two views; the orchestrator
                                      change it, what I missed       compares them
use for     reversible, cheap,        not obvious, medium impact     irreversible, touches the mandate,
            a sanity check            (a halt, a red gate, a fix)    scope or design, costly to undo
```

**Who picks.** Marcos, by naming the level (and `model=` to change the consultant at any level). Else
the agent, by the rule in the table, saying in one line before consulting: "deliberate: standard,
because …". When Fable is unavailable, use Opus and say so in the record.

## 1. Brief

Spawn the consultant(s) with the Agent tool and this shape, nothing else:

```
Situation   what is happening, in facts: phase, state, what failed or what is being chosen.
Evidence    paths, SHAs, log excerpts, command output, links. Enough to check, not a summary of it.
Options     2–4 options, each with what it does and what it costs or risks. Include "do nothing / wait"
            when it is real. Same level of detail for every option.
Constraints the mandate (what needs Marcos), deadlines, what cannot change (approved RFC, gates).
Question    "Which option, and why? What would change your answer? What did I miss?"
```

Before sending, reread it and remove: your preferred option, words that rank options ("recommended",
"best", "I think", "probably", "obviously"), an option described in more detail than the others, and
any order that puts your choice first or last on purpose. Give paths when the evidence is large.

Done when the brief has the parts its level needs and no trace of your conclusion.

## 2. Decide and record

Read the answer(s), then decide. You may disagree; say why. In a council, when the two disagree and the
decision falls under the mandate, bring Marcos the options with both views, one question at a time.

Record in the run log (or the session's Brain note when there is no run): the level, the question, the
options, each view in one or two lines, the decision, the reason and how to undo it. A decision that
outlives the task also goes where it lasts: the RFC or ADR, or a comment on the issue.

Done when the decision and every view are written down.
