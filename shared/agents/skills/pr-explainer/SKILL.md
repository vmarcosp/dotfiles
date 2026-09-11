---
name: pr-explainer
description: >-
  Sizes a PR into 1-4 rounds, then walks each round in the same chat:
  visual overview from the user's point of view (code as hints), Q&A, quiz
  when ready. Use when the user wants a PR explained or says /pr-explainer.
disable-model-invocation: true
license: MIT
metadata:
  author: Marcos Oliveira
  version: "2.3.0"
---

# PR Explainer

A review finds faults. This finds shared understanding: what someone using the product now hits, can do, or still cannot do — and only then where that lives in the code. Prefer a picture over a paragraph.

Outer loop: **1-4 rounds**, chosen from the size of the PR. Inner loop, every round, three sessions in the same chat. Do not skip a session. Do not start the next round until the current quiz is done (or the user skips it).

```
read the diff → size it → round map (1-4)
        │
        ▼
   ┌── round N of M ─────────────────────────┐
   │  Session A  Overview   ← agent. Stop.   │
   │  Session B  Questions  ← user asks.     │
   │  Session C  Quiz       ← user says ready│
   └─────────────────────────────────────────┘
        │
        ▼
   next round, same chat, until M
```

Invoke explicitly with `/pr-explainer`.

## Communication (every session)

Lead with the person in front of the product (or API, CLI, admin screen: whoever this change actually hits). Code is a hint in parentheses, never the subject of the bullet.

**Match the prompt.** Use the same words the person used when they invoked this skill: product names, "we"/"they"/"I", domain slang, how they named the PR. Do not rename their terms into your own. Do not upgrade their casual phrasing into formal review-speak.

1. Run every block of explanation through `/my-voice --voice casual --purpose technical` before showing it. Not optional. Show the my-voice output, not the draft. Keep their terms intact through that pass.
2. Simple English. Short sentences. One idea per sentence. Bullets over paragraphs. Diagrams over bullets when two states, a path, or a split can be drawn.
3. ELI5 means build from the smallest true statement and define a term the moment you use it. It does not mean metaphors, similes, or toy objects. Wrong: "a hash is a fingerprint." Right: "A hash is a fixed-length number computed from input bytes. Same bytes in, same number out."
4. **Visual first.** Default is ASCII. A round with zero diagrams is unfinished unless the slice is a rename or docs (say so in one line). Draw:
   - before/after of what they see or can do
   - the path they take (screen to screen, command to result)
   - a split (allowed vs blocked, old vs new, this round vs later)
   - who is in vs out
   Annotate a step with a real symbol from the diff (`Guard.check`). Boxes are user-facing labels. Do not draw a call graph as the main picture. If two bullets only compare states, replace them with a diagram.
5. Code hints: a function, type, flag, or package after the user-facing fact. One hint per bullet max. Do not paste walls of the diff. Do not explain a change as "we added X to Foo."

Wrong: `Foo.handle now calls Guard.check before Bar.save.`
Right: `They can submit again after a 429. The retry lives in Foo.handle, behind Guard.check.`

**Completion criterion (voice):** user-facing fact first; their words, not yours; at least one ASCII figure per overview section that has a path or a comparison; code is optional hint; my-voice ran; zero metaphors in ELI5 bits.

## Step 0: Read the real diff

Target: current branch vs its base, a PR number/URL, or a path the user gives. Read the actual diff (`git diff`, `git log --oneline`, `gh pr diff`). Never the PR description alone.

For files that carry behavior, read enough surrounding code to say **what a person now experiences** and which symbol implements it. Skip lockfile/generated churn. Then Step 1.

**Completion criterion:** for each concern you can finish this sentence from the code: "Before, they … After, they …"

## Step 1: Size the PR and publish the round map

Count **behavior files** (exclude lockfiles, generated, pure formatting). Count **concerns**: independent things a person could notice or sign off separately (signing in vs paying vs a CLI flag). Prefer concerns over file count when they disagree.

Pick **M** rounds, always in **1-4**:

| Size | Signals | M |
|------|---------|---|
| S | 1 concern, ~1-12 behavior files | 1 |
| M | 1-2 concerns, ~12-25 files | 1 or 2 |
| L | 2-3 concerns, ~25-50 files | 2 or 3 |
| XL | 3+ concerns, or 50+ files | 3 or 4 |

Cap at 4. If there are more than 4 concerns, merge the leftovers into the last round (name that round by the cluster of user-facing behavior, not "misc"). Never use 1 round for an XL PR just to finish faster.

Show the round map **before** Session A of round 1, as ASCII plus one line per round. Slice names are what the person hits (`retry after rate limit`, not `packages/billing`), in their language.

```
  [ round 1 ] → [ round 2 ] → [ round 3 ]
   retry 429     billing UI     CLI flag
```

Then start round 1 Session A, unless they pick a different round first.

**Completion criterion:** M is stated; every behavior file belongs to exactly one round; slice names match their wording; the map is drawn before any overview.

---

## Round N — Session A: Overview (agent)

Only the current round's slice. Write it **as what happens to them**, visual, humanize it, show it, **stop**. Do not quiz. Do not start round N+1. Do not write a deep dive unless they pick one.

Order is fixed:

```
title
  → glossary
  → scope
  → problem → solution → trade-offs → touchpoints
  → deep-dive offers (1-3, optional)
  → gate
```

Label the header: `Round N of M — <slice name>` (their words).

### Glossary (first, right under the title)

Words they need before the rest. Product terms, states they see (`Past due`, `429`), a flag that changes what they can do. Prefer their prompt's names. One line each. Smallest true statement, no metaphor. Internal type names only if they leak into the experience. Skip the section only if nothing needs defining.

### Scope

What they will notice in this round: screens, steps, errors, permissions, data they can see or change. Draw it when you can (this round vs out of scope). Short bullets only for what a box cannot hold. User fact first, then a code hint.

Out of scope: other rounds, plus changes nobody using the product can tell (docs-only, incidental formatting).

### Problem → solution → trade-offs → touchpoints

**This slice only.** Each line starts with them (they, you, the operator, the API caller — whichever the prompt used).

- **Problem** — what went wrong for them, or what they could not do. Then where it showed up in code. Draw before.
- **Solution** — what they can do now, or what they see instead. Then the mechanism as a hint. Draw after, or one before/after figure covering both.
- **Trade-offs** — what they still cannot do, what still fails the same way, what is newly allowed that can bite them. A two-column or fork diagram beats a list.
- **Touchpoints** — the 2-4 product decisions that mattered (an extra confirm, a default they cannot turn off, who is excluded). Chosen X because Y. Hint the code last.

Put the code hint on the step, not as the box name:

```
before                         after
Submit                         Submit
  └─ "try again later"           ├─ wait, then retry   (Guard.check)
                                 └─ saved              (Bar.save)
```

### Deep dives (offer, do not write)

After the four beats, suggest **1-3** optional deep dives for this round. Each is one line: a user-facing slice they might want expanded (an edge path, a role that behaves differently, a screen the overview only named). Do not expand them in Session A.

If they pick one (in Session B or by naming it), write that deep dive with the **same order and communication as this overview**: glossary only if new terms, then scope, then problem → solution → trade-offs → touchpoints, ASCII-heavy, user fact first, their language, concise (shorter than the overview, not a second round).

### Gate

End Session A with this, nothing more:

> Ask anything about this round, or pick a deep dive. Say when you're ready for the quiz.

**Completion criterion:** glossary sits under the title; four beats are user-facing and drawn where they compare or flow; 1-3 deep dives named not written; their wording used; my-voice ran; quiz not started; next round not started.

---

## Round N — Session B: Questions (user)

The user drives. Answer in the same voice and visuals: what happens for the person, ASCII when a path or comparison is the answer, then a code hint if it helps. Stay in this session until they ask for the quiz ("ready", "quiz me", "test me", and close variants).

A picked deep dive is Session B work: same overview structure, shorter.

If they ask about a later round, one line: that's round K, then answer only if the question is small; otherwise park it.

If they ask something the experience and the diff don't answer, say so.

If they explicitly ask how the code is structured, then you may go deeper on symbols. Default is still the user path.

**Completion criterion:** every question or deep dive in this round answered from what the change does to them (and the code that backs it); Session C not entered until they ask for it.

---

## Round N — Session C: Quiz (user-ready only)

2-5 questions **about this round**. One `AskQuestion` call. Each tests what a person can do, cannot do, or will see — or a trade-off that changes that. Not function names, file names, line counts, or commit hashes. Use their terms from the prompt and the overview.

Options are serious. Exactly one is correct. Wrong options are plausible misreadings of the **experience**: the old behavior, a nearby flow, a trade-off inverted. No joke options.

After answers:

- Right: one line. Next question, or done.
- Wrong: explain what actually happens for them, briefly, same voice, grounded in the diff. Prefer a tiny before/after if that is the miss. Then **ask that concept again** in a new `AskQuestion`: different wording, different distractors. Do not reuse the same stem. Repeat until they get it or they want to stop.

When this round's questions are settled, short score: which user-facing ideas landed, which needed a second pass.

Then, same chat:

- More rounds left: `Round N of M done. Round N+1 is <slice>. Say when you want the overview.` Do not write that overview until they say so.
- Last round: one line that the map is finished.

**Completion criterion:** answers checked against the experience the code implements; misses re-asked unless they bail; next overview gated on the user.

---

## Rules

1. Diff and surrounding code are how you know. The overview is what they experience. The PR title is not the source.
2. Humanizer on every explanation block, every session. Keep the prompt's language through it.
3. No metaphors in ELI5 stretches. If one sneaks in, rewrite that stretch.
4. Size first, then a drawn 1-4 round map named in their words, then Session A. Glossary immediately under the title. Never an unscoped mega-overview. Never a call-graph overview.
5. Three sessions per round, same chat. They open Session C. They open the next round. Deep dives are optional and only after they pick one.
6. Quiz tests what happens for them this round, not trivia, not other rounds, not symbol names.
7. If you can draw it, draw it. A wall of bullets where a before/after would do is a failed overview.
