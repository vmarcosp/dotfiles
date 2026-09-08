---
name: review
description: >-
  Reviews a delivered change against its contracts — the /spec plan, the
  roadmap phase's boundary, binding ADRs, and test authenticity — and
  returns a verdict with blocking and advisory findings.
disable-model-invocation: true
license: MIT
metadata:
  author: Marcos Oliveira
  version: "1.0.0"
---

# Review — Diff Against Contracts

A generic reviewer judges a diff against taste; this one judges it against contracts: the plan that promised the change, the roadmap phase that bounds it, and the ADRs that constrain it. Nothing passes because it looks good — it passes because every contract demonstrably holds. Invoke explicitly with /review.

## When NOT to apply

- No plan exists for the change — run a generic reviewer instead; this skill's whole value is the contracts.
- The change hasn't been implemented yet — this reviews code, not plans; plans get refined in `/spec`.

## Step 1: Load the contracts

Read in full: the plan (Goal, Success Criteria, Steps with their Verify lines, Verification, Assumptions in the PR), every ADR the plan references, and — when the plan is a roadmap phase — that phase's contract block (Goal, In/Out, Source) and the carry-over fragment `/implement` wrote, if any.

**Completion criterion:** every contract the checks below will judge against is read, not skimmed — plan, ADRs, phase block, fragment.

## Step 2: Read the diff

Read the full diff of the PR or branch, every changed file — plus enough surrounding code to judge each change correct in context, not just plausible in isolation.

**Completion criterion:** no changed file unread; context opened wherever a change's correctness depends on code outside the diff.

## Step 3: Run the four checks

A flat set — apply every check to the whole diff; a skipped check is a review not done.

1. **Plan fidelity** — every Step landed in the diff, and everything in the diff belongs to a Step: an unplanned change is a finding even when it's good, and anything crossing the phase's Out line into a sibling's scope is blocking.
2. **Test authenticity** — the tests prove behavior, not theater: each new or changed test can actually fail (it asserts the outcome, not a mock of the thing under test); no Verify was weakened to pass; every bug fixed en route carries a regression test.
3. **ADR compliance** — the diff honors every binding ADR. A violation is blocking regardless of any justification in comments or PR prose — reopening an ADR is a conversation with the user, never a review pass.
4. **Criteria delivery** — each Success Criterion demonstrably holds: run the plan's Verification checks yourself where runnable; where not, trace the criterion to the specific code and tests that guarantee it.

**Completion criterion:** all four checks applied to the entire diff; every finding written down with file/line, the contract it breaks, and its severity (blocking or advisory).

## Step 4: Verdict and deliver

- **Approve** — every contract holds; only advisory findings remain.
- **Request changes** — at least one blocking finding: a missing or unplanned change, test theater, an ADR violation, or an unmet criterion.

The review reports; the fix is a separate `/implement` pass — judging and patching in the same breath corrupts both. A finding that affects another phase (a fact its `/spec` needs, a dependency the roadmap missed, an anchor doc the diff disproves) is appended to this phase's carry-over fragment — created at the reserved path if `/implement` skipped it — never left as a loose comment.

Deliver as a PR review when a PR exists (`gh pr review`), otherwise in the session: verdict first, then findings grouped by check with file/line and contract, then what was actually run (Verification commands, test suite) and the results.

**Completion criterion:** verdict stated; every blocking finding actionable without re-deriving the review; cross-phase findings sit in the fragment.

## Rules

1. Contracts over taste — a style nit is advisory unless it breaks a formatter or linter rule the repo treats as law.
2. A test that cannot fail is a blocking finding, same as a test that fails.
3. Run what you can — a Verification you could execute but only read is a check not done.
4. Never fix while reviewing — report, and let `/implement` patch.
5. Cross-phase findings go to the carry-over fragment, never loose comments.
6. Write in the same language the user uses.
