---
name: implement
description: >-
  Executes an implementation plan (from /spec) end to end: turns its
  Steps into a tracked checklist, works through them one at a time —
  implement, run the Step's Verify, check it off, commit — then runs the
  plan's overall Verification and delivers a PR. Invoking /implement is
  itself the go-ahead to execute; there's no separate approval gate. Use
  when the user wants to execute, build, or ship a plan that already
  exists, or invokes /implement.
disable-model-invocation: true
license: MIT
metadata:
  author: Marcos Oliveira
  version: "1.1.0"
---

# Implement — Plan to Code

Executes a plan (see /spec) by turning its Steps into a tracked checklist and working through them one at a time: implement the Step, run its Verify, check it off, commit, move on. Nothing counts as done because it looks done — only because its Verify ran and passed. Invoke explicitly with /implement.

## When NOT to apply

- No plan exists yet for this change — run /spec first.
- The change is trivial enough that /spec itself said planning wasn't worth it.

## Step 1: Load the plan

Read the plan file in full — invoking this skill is itself the go-ahead to execute it; there's no status to check before starting. Extract the Goal, the Recon table, any ADRs referenced (still binding during execution), the Approach, the ordered Steps with their Verify lines, and the overall Verification section.

If a Step is too vague to implement or verify unambiguously — no concrete target, no runnable Verify — stop and ask via the AskQuestion tool before writing code; don't fill the gap with a guess.

**Completion criterion:** every Step's target and Verify line is unambiguous and in hand before touching code.

## Step 2: Refresh recon

Spot-check the plan's Recon findings against the current codebase — files it names still exist, functions it references still have the shape described. Plans go stale between writing and executing; catching drift here is cheaper than discovering it mid-Step.

If something has drifted in a way that invalidates a Step, note it — it becomes an assumption or a blocker in Step 4, not a silent workaround.

**Completion criterion:** every Recon finding the Steps depend on has been re-checked against the current code.

## Step 3: Build the checklist

Create one todo per Step from the plan, in order, using the todo-tracking tool available in this environment. Todo text should be the Step's title — specific enough that "done" is unambiguous without re-reading the plan.

**Completion criterion:** one todo exists per Step, in the plan's order, all pending except the first.

## Step 4: Work the checklist

```
LOOP per todo, in order:
1. Mark it in progress.
2. Implement exactly what the Step describes — no more, no less.
3. Run the Step's Verify. If it fails, fix and re-run until it passes.
4. Mark the todo completed — immediately, not batched with later Steps.
5. Commit. One commit per Step, unless the plan groups several as one logical unit.
6. Move to the next todo.
```

**If a Step's Verify won't pass after reasonable focused attempts:**

Apply this tie-break order to resolve ambiguity: any ADR the plan references (non-negotiable — never override one to make a Step pass) → the Step's own wording → the plan's Approach → the plan's Goal → repository conventions. If that resolves it, implement the resolution and note it as an Assumption for Step 6.

If it's still unresolvable, or the fix would require contradicting the plan itself:

- **Interactive session, user reachable** → stop and ask via the AskQuestion tool; don't guess past a Step you can't verify.
- **No one reachable (sandboxed/background run)** → stop, leave the checklist and commits as-is, and record the blocker (which Step, what was tried, why it's blocked) in the plan file or the PR description instead of the git history.

Never mark a todo completed, or force a Verify to "pass," by weakening the Verify itself or editing the plan to match what the code happens to do.

**Completion criterion:** every todo is `completed`, each backed by a Verify that actually ran and passed — or the run stopped with a documented blocker.

## Step 5: Run the overall Verification

Once every Step is checked off, run the plan's Verification section as a whole — not just the per-Step checks, which only prove each piece in isolation.

**Completion criterion:** the plan's Verification passed, or a documented blocker explains why it didn't.

## Step 6: Deliver

1. Update the plan's status to `Done`.
2. Open or update the PR:
   - **Summary** — what changed, one line per Step.
   - **Verification** — what was run and the result.
   - **Assumptions** — from Step 4 tie-breaks, if any (omit if none).
   - **Blockers** — if the run stopped early (omit if the run completed).
   - **Plan** — link to the plan file.

## Rules

1. The plan is the contract — implement what it says, not what seems better in the moment; if the plan is wrong, that's a blocker, not license to improvise silently.
2. An ADR the plan references is a harder contract than the plan itself — never override one to force a Step to pass.
3. No todo is completed without its Verify having actually run and passed.
4. One commit per Step — keeps the history walkable against the plan.
5. Never edit the plan's Steps or Verify lines to make the run look successful — fix the code, or stop and report.
6. Ask explicitly via AskQuestion whenever a Step is too ambiguous to implement or verify with confidence, in an interactive session — never guess past it.
7. A blocked run ends without claiming the change is done — no PR that overstates what actually passed.
