---
name: pr-loop
description: Take a change from task to a green pull request with Marcos's implement → review once → fix loop, run by the orchestrator through subagents. Use when Marcos asks to implement, fix or finish a PR with agents, says "pr-loop", "deixa o PR verde", "implementa e revisa", or when a post-run or a small Jira task needs code, a review and the fixes.
---

The orchestrator runs the loop; it does not write the code. Model defaults are in
`~/.agents/rules/models.md`; Marcos may name others. The PR policy of the repo's organization (review bots, required checks, force
push), when there is one, is linked from `~/.agents/AGENTS.local.md`.

```
implement (Sonnet | Opus) ──► review once (Opus | Fable) ──► fix (Sonnet) ──► verify (orchestrator)
                                                   ▲                                │
                                                   └──── only if a fix changed the design
```

## Inputs

The task (Jira key, RFC section, findings list or Marcos's words), the repo and the worktree, the base
branch, and whether a PR exists. Missing worktree: create one from the base, never work in Marcos's
main checkout.

## 1. Implement

Spawn one subagent: **Sonnet** for mechanical work, **Opus** when it needs judgment. Brief it with the
task, the worktree, the repo's `AGENTS.md`/`CLAUDE.md` (gates, commit format, boundaries), the exact
checks that define done, and what it must not do (no force push, no `--no-verify`, no editing files
outside the scope). It commits, runs the repo's gates, pushes with a plain push and opens the PR with the
repo's `open-pr` skill when none exists. It reports SHAs, gates with exit codes and anything it skipped.

Done when the PR exists, the head SHA is known and the agent's gate claims are checked against the
commands' output, not its summary.

## 2. Review once

One reviewer: **Opus** for a small PR, **Fable** for a large one or a run. It reads the diff against the
base and the source of truth (RFC, story, findings) and returns ranked findings: blocker, should-fix,
nit, each with file, line and a concrete failure. It does not fix. Prefer `/code-review <PR>` when the
repo has no review skill of its own.

Done when the findings list exists and each one is classified as fix now, follow-up or rejected (with
the reason).

## 3. Fix

One **Sonnet** (Opus if a finding needs design judgment) fixes, in one round: the reviewer's fix-now
findings, review-bot comments per the organization's PR policy (fix or answer each), and every red CI
check. It
replies to each thread it addressed. One agent per worktree at a time: parallel agents collide on hooks
and builds.

A second review runs only when a fix changed the design or touched code the first review did not see.

## 4. Verify and report

- `gh pr checks <n> --watch` (or read `statusCheckRollup`); `gh pr view <n> --json mergeable,headRefOid`.
- Open threads: none unanswered.
- Tell Marcos in a few lines: PR, head SHA, checks, what is left for him (approvals, SDD/Component,
  merge) and the follow-ups that went to Jira.

Done when CI is green or every red check has a stated owner, and Marcos has the summary.
