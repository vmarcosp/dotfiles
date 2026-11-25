---
name: feature-flow
description: Drive a large Jira story from the story to an approved, merged RFC (Mode B, steps 1–2 of Marcos's method) and hand it to /orchestrate. Checks the story, gathers context from pinned sources, has a named Opus write the RFC with the repo's rfc skill, gets a Fable review, publishes a technical artifact for Marcos and resolves the open questions one at a time. Use when Marcos starts a new phase or large story ("start phase N", "write the RFC", "feature-flow PROJ-123"), or asks for "the full flow" before a run.
---

Method and reasons: `~/projects/brain/Agent/Method/` (`Working modes.md`, `Working with
Marcos.md`). State goes to the Brain epic folder (skill `brain`); context across `/compact` through
`/handoff`. The orchestrator delegates the writing; it decides by rule what a rule settles and brings
Marcos only scope, deadlines, other people's dependencies and what is outside the mandate.

```
story ✓ ──► context note ──► RFC (Opus, named) ──► Fable review ──► artifact ──► Marcos's questions
                                    ▲                    │                              │
                                    └──── fixes by rule ─┘◄──── answers ────────────────┘
                                                                    ──► Approved, merged ──► /orchestrate
```

## 1. Story

Read the Jira story. It needs scope, out of scope, acceptance criteria and sources pinned to a commit
(PRD, design handoff, prototype). Missing parts: propose the text to Marcos; write it to Jira only with his ok
(title and description in the project's language, comments in English).

Done when the story has the four parts or Marcos accepted the gap.

## 2. Context

Write `Agent/<Project>/<Epic>/RFC <n> — context.md` in the Brain: the story, the requirements read from
the pinned sources (with line numbers), the code as it is today (paths), and the open product points.
Settle each open point by rule (PRD wins on behavior and scope; handoff and `CONTENT.md` on text and
visuals; handoff over prototype); ask Marcos the rest, one question at a time, and record his answers
in the note.

Done when no open point is left without an owner.

## 3. RFC

Spawn one **Opus** subagent with a name (e.g. `rfc<n>-writer`) and keep it alive until approval. It
works in its own docs worktree and branch, uses the repo's `rfc` skill and the context note, and does
not push. The RFC is the technical design and its decisions: components, contracts, states, flows,
risks, acceptance criteria, test strategy. No phases and no run order: those belong to the Junji plan.

Done when the draft is committed locally.

## 4. Review

One **Fable** reviews the RFC against the story, the sources and the code: blockers, should-fix, nits.
Resolve each by rule and send the list to the writer; escalate only what the rules do not settle. For a
call that is yours but not obvious, use `/deliberate`.

Done when every finding is applied, rejected with a reason, or queued for Marcos.

## 5. Artifact and questions

Publish the RFC as a page with the `technical-artifact` skill: easier to read, not shallower. Marcos
reads it instead of the RFC. Ask the queued questions one at a time; send each answer to the writer; if
answers change the design, update the artifact.

Done when Marcos says the RFC is approved.

## 6. Merge and hand off

The writer sets the status to Approved; open the docs-only PR with the repo's `open-pr` skill (pass the
description through `/my-voice`). Marcos merges. Update `State.md`, then recommend a run or no run with
the reason. On a run, continue with `/orchestrate` (Prepare); otherwise `/forge`.

Done when the RFC is merged as Approved and the next step is decided.
