---
name: review
description: >-
  Reviews a delivered change against its contracts — stated intent (PR or
  conversation), binding ADRs, linked TDDs or brainstorm docs, and test
  authenticity — and returns a verdict with blocking and advisory findings.
disable-model-invocation: true
license: MIT
metadata:
  author: Marcos Oliveira
  version: "2.0.0"
---

# Review — Diff Against Contracts

A generic reviewer judges a diff against taste; this one judges it against contracts: the intent that promised the change, the ADRs that constrain it, and any design docs it claims to follow. Nothing passes because it looks good — it passes because every contract demonstrably holds. Invoke explicitly with /review.

## When NOT to apply

- There is no delivered diff yet — this reviews code, not an idea.
- No intent and no design docs can be found (empty PR body, no linked ADR/TDD, no goal in the conversation) — run a generic reviewer instead; this skill's whole value is the contracts.

## Step 1: Load the contracts

Collect, then read in full:

1. **Intent** — PR title and body (`gh pr view` when a PR exists), else the user's stated goal in this conversation, else the branch's commit messages. Treat Goal, Success Criteria, Verification, and Assumptions as contracts when those headings exist; otherwise the whole intent statement is the contract.
2. **ADRs** the intent or diff references, plus any ADR whose decision the changed files sit under.
3. **Design docs** linked from the PR or named in the conversation — TDDs (`docs/tdds/` and siblings), brainstorm convergence docs (`docs/brainstorms/` and siblings). These bound shape, not taste.

Skip a class that does not exist; do not invent a plan file.

**Completion criterion:** every contract the checks below will judge against is read, not skimmed — intent, ADRs, design docs that apply.

## Step 2: Read the diff

Read the full diff of the PR or branch, every changed file — plus enough surrounding code to judge each change correct in context, not just plausible in isolation.

**Completion criterion:** no changed file unread; context opened wherever a change's correctness depends on code outside the diff.

## Step 3: Run the four checks

A flat set — apply every check to the whole diff; a skipped check is a review not done.

1. **Intent fidelity** — the diff delivers what the intent promised, and everything in the diff belongs to that intent: an unplanned change is a finding even when it's good.
2. **Test authenticity** — the tests prove behavior, not theater: each new or changed test can actually fail (it asserts the outcome, not a mock of the thing under test); no verification was weakened to pass; every bug fixed en route carries a regression test.
3. **ADR compliance** — the diff honors every binding ADR. A violation is blocking regardless of any justification in comments or PR prose — reopening an ADR is a conversation with the user, never a review pass.
4. **Criteria delivery** — each success criterion (or, if none were written, the intent's goal) demonstrably holds: run named Verification checks yourself where runnable; where not, trace the criterion to the specific code and tests that guarantee it.

**Completion criterion:** all four checks applied to the entire diff; every finding written down with file/line, the contract it breaks, and its severity (blocking or advisory).

## Step 4: Verdict and deliver

- **Approve** — every contract holds; only advisory findings remain.
- **Request changes** — at least one blocking finding: a missing or unplanned change, test theater, an ADR violation, or an unmet criterion.

The review reports; it does not patch. Judging and fixing in the same breath corrupts both. A finding that belongs in a design doc (an ADR the diff disproves, a TDD that drifted, a brainstorm assumption that died) is called out as a doc follow-up — never left only as a loose inline comment.

Deliver as a PR review when a PR exists (`gh pr review`), otherwise in the session: verdict first, then findings grouped by check with file/line and contract, then what was actually run (Verification commands, test suite) and the results.

**Completion criterion:** verdict stated; every blocking finding actionable without re-deriving the review; doc follow-ups named with a path or an explicit "no file yet."

## Rules

1. Contracts over taste — a style nit is advisory unless it breaks a formatter or linter rule the repo treats as law.
2. A test that cannot fail is a blocking finding, same as a test that fails.
3. Run what you can — a Verification you could execute but only read is a check not done.
4. Never fix while reviewing — report, then stop.
5. Design-doc drift is a named follow-up, never only a drive-by comment.
6. Write in the same language the user uses.
