---
name: triage-pr-followups
description: >-
  Interactively triages leftover follow-ups on an open PR, one item at a time.
  Collects every follow-up from the PR body (and related carry-over notes),
  presents each with short bullet context plus an optional ASCII diagram,
  then uses AskQuestion with Issue / Not applicable / Address now (one option
  marked Recommended). Queues Address-now work and only after the last item
  asks how to execute the batch: this session, one subagent, or many subagents.
  Use when the user wants to triage PR follow-ups, leftovers, carry-overs, or
  technical-debt bullets on a pull request, or says /triage-pr-followups.
disable-model-invocation: true
---

# Triage PR follow-ups

Walk every leftover on an open PR with the human, one item at a time. Do not dump the list into a single form. Do not start implementing, filing, or deleting until that item's AskQuestion returns.

## Sources

Identify the PR (`gh pr view` on the current branch, or the URL / number the user gave). Collect follow-ups from, in order:

1. A `## Follow-ups` / `## Follow-ups and technical debt` / `## Carry-over` section on the PR body
2. Explicit leftover / debt / out-of-scope lists in the same body
3. Only if the body has none: matching sections in specs, TDDs, or ADRs linked from the PR

Skip items already filed as issues and linked. Deduplicate. Number them `N / M`.

## Hard rule: iterate, don't batch the questions

Present **one item**, wait for the answer, act on that answer, then present the next.

Never put all items in one `AskQuestion` with N questions. Context belongs in the chat message, not crammed into the prompt string.

If the user asks a clarifying question mid-item, answer it (look up the code), then re-ask that same item. Do not skip ahead.

## Per-item card

Chat message, in this order:

1. **Title** — `N / M — <short name>`
2. **Bullets** — 3–6 lines of why it exists, what is true in the code today, who owns it, what "done" would mean. No essay.
3. **ASCII diagram** — only when a flow, ownership split, or before/after is easier to see than to read. Skip it when bullets already say it.
4. **`AskQuestion`** — exactly three actions, plus a recommendation.

### AskQuestion contract

Title: `Follow-up N of M — <short name>`

Prompt: `What should we do with this follow-up on PR #<n>?`

Options, always these three ids:

| id | label |
|---|---|
| `github-issue` | Turn into GitHub issue |
| `n-a` | Non applicable (delete from PR) |
| `address-now` | Address right now |

**Recommendation.** Pick one. Put it first. Append `(Recommended)` to its label. Ground the pick in one sentence in the bullets (schema owners → issue; reviewer note that says "do not cleanup" → n-a; Studio-only and unblocked → address now). The user still decides.

Do not add extra options. The tool already has Other.

### ASCII

Use it for:

- a data flow the bullet would have to narrate (`codegen → attribute → chip`)
- two scripts / two questions that share a regex
- a layout or lifecycle the follow-up is about (dispose/create runtime, show/hide window)

Do not decorate. Boxes and arrows only.

## Acting on each answer

Keep a running ledger: item, decision, extra constraints the user typed, URLs.

### `github-issue`

Create the issue **now** (`gh issue create`). Body: context, proposal, link back to the PR, pointers to the code / TDD / ADR. Labels that already exist and fit (do not invent labels).

Reply with the URL. Continue to the next item.

### `n-a`

Record it as dropped. Do not file. Continue. The PR body is rewritten once at the end, not per item.

### `address-now`

**Queue. Do not implement yet. Do not dispatch a subagent yet.**

Capture any extra instruction in the same answer (key chord, Figma file, SVG path, "hide windows but do not enable CI"). If the work is ambiguous, ask one clarifying question, then re-ask or confirm.

Tell the user it is queued and move to the next item.

## After the last item

1. **Rewrite the PR follow-up section once.**
   - Keep filed items as bullets with issue links.
   - Delete `n-a` bullets.
   - List queued Address-now work under a short "Landing in this PR" (or equivalent) until it actually lands, then drop those bullets.
2. **Show the Address-now batch** as a numbered list (what, extra constraints, likely files).
3. **Ask how to execute that batch** — one `AskQuestion`, only if the queue is non-empty.

### Delegation AskQuestion

Title: `Address-now batch`

Prompt: how should the queued work run?

Options (mark one Recommended; put it first):

| id | label | When to recommend |
|---|---|---|
| `session` | This session (you implement here) | Tiny, or the user will keep steering |
| `one-subagent` | One subagent, whole batch | Default when items share files / one branch / one worktree |
| `many-subagents` | Many subagents in parallel | Only when file sets do not overlap |

If they pick subagent(s), ask model only when they have a preference; otherwise use the model they named in the thread, else `composer-2.5-fast`.

### Dispatch rules

- Same worktree + overlapping files → **one** subagent, even if they picked many. Say so.
- Parallel subagents only with disjoint paths, and never on the same git index.
- Prompt each subagent with the queued spec, the extra constraints, repo coding rules, **do not commit**, **do not push**, **do not create a branch**.
- After they finish: verify, then strip "Landing in this PR" from the body if the work is in the tree.

Do not commit or push unless the user asks.

## Anti-patterns

- One mega-form with every follow-up as a question
- ASCII on every card
- Dispatching a subagent on the first Address-now
- Filing an issue and also leaving the old bullet unchanged
- Collapsing "do not DRY this" reviewer notes as Address-now without the user overriding
- Implementing behind the AskQuestion
