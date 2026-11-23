---
name: second-opinion
description: Get an unanchored second opinion from a Fable subagent before an orchestrator decision that is not obvious — a halt in a run, a red gate, a scope or design call, a fix with several valid paths. The brief carries the situation, the evidence and the options, never the orchestrator's conclusion. Use when the orchestrate skill or Marcos's mandate asks for a second opinion, or when Marcos says "pede uma segunda opinião", "pergunta pro Fable".
---

A second opinion is worth something only if the reviewer cannot see which way you lean. Write the
brief as if you had not decided, then decide yourself after reading the answer.

## 1. Brief

Spawn one **Fable** subagent (Agent tool, `model: fable`) with this shape and nothing else:

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
any order that puts your choice first or last on purpose. Let the reviewer read files itself when the
evidence is large; give paths.

Done when the brief has all five parts and no trace of your conclusion.

## 2. Decide and record

Read the answer, then decide. You may disagree with it; say why. Record in the run log (or the session's
Brain note when there is no run): the question, the options, Fable's view in one or two lines, your
decision, the reason and how to undo it. When the decision needs Marcos under the mandate, bring him
the options with both views, one question at a time.

Done when the decision and both views are written down.
