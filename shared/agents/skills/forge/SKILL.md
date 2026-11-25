---
name: forge
description: Take a change from a task to a green, ready pull request with a configurable plan → implement → review → fix → QA → verify loop, with a preset weight (lite, standard, heavy) and per-role overrides (who plans, who implements, which model reviews at which level, how many rounds, QA or not). Use when Marcos asks to implement, fix or finish a PR with agents, says "forge", "/forge lite|standard|heavy", "make the PR green", "implement and review", or when a post-run or a small task needs code, a review and the fixes.
---

`/forge [lite|standard|heavy] [task] [role=value …]`. The orchestrator (this session) runs the loop and
owns the result. Default models per kind of work: `~/.agents/rules/models.md`; a preset or an override
wins over it, and Marcos's words win over both. The PR policy of the repo's organization (review bots,
required checks, force push), when there is one, is linked from `~/.agents/AGENTS.local.md`.

```
plan ──► implement ──► review (× rounds) ──► fix ──► qa ──► verify ──► Marcos
 │           │              │                  │       │        │
session   session        none |              session  none |   CI, mergeable,
| opus    | sonnet|opus  <model>:<level>     | sonnet  <model>  bots, threads
                                              | opus
```

## Roles and values

| Role | Values | What it sets |
|---|---|---|
| `plan` | `session` · `opus` · `none` | Who breaks the task down before code (a named Opus keeps the plan) |
| `impl` | `session` · `sonnet` · `opus` | Who writes the code |
| `review` | `none` · `<model>:<level>`, e.g. `opus:medium`, `fable:high` | Who reviews and how deep: the level is the `/code-review` effort (`low`…`max`) |
| `rounds` | `1` · `2` | Review rounds; the second runs only if a fix changed the design or touched unreviewed code |
| `fix` | `session` · `sonnet` · `opus` | Who fixes review findings, bot comments and red CI |
| `qa` | `none` · `<model>` | An agent with the repo's QA skill, preflight first |
| `bots` | `1` · `<n>` | Rounds of review-bot findings to fix; after them, blockers only, or close (Marcos decides) |

## Presets

| Preset | plan | impl | review | rounds | fix | qa | For |
|---|---|---|---|---|---|---|---|
| `lite` | session | session | `opus:low` | 1 | session | none | A small change: speed, plus one outside pair of eyes |
| `standard` | session | sonnet | `opus:medium` | 1 | sonnet | none | The default |
| `heavy` | opus | sonnet (opus for judgment) | `fable:high` | 2 | sonnet | opus | A large PR, a post-run, a risky area |

No preset given: pick one from the diff size and risk, and say which and why in one line before
starting. Overrides apply on top: `/forge standard review=fable:high`, `/forge heavy qa=none`.

## Steps

**Inputs.** The task (issue key, RFC section, findings list or Marcos's words), the repo, the base
branch and whether a PR exists. Work in a worktree from the base, never in Marcos's main checkout.

1. **Plan** (when `plan` is not `none`): the planner writes the slices and the checks that define done
   for each. `session` plans inline; `opus` is a named subagent kept alive for later questions.
2. **Implement.** Brief the implementer with the task, the worktree, the repo's `AGENTS.md`/`CLAUDE.md`
   (gates, commit format, boundaries), the exact checks that define done, and what it must not do (no
   force push, no `--no-verify`, nothing outside the scope). It commits, runs the gates, pushes with a
   plain push and opens the PR with the repo's PR skill when none exists. Check its gate claims against
   the commands' output, not its summary.
3. **Review** (when `review` is not `none`): the reviewer reads the diff against the base and the source
   of truth (RFC, story, findings) and returns ranked findings (blocker, should-fix, nit), each with
   file, line and a concrete failure. It does not fix. Prefer `/code-review <PR>` at the level given
   when the repo has no review skill of its own. Classify each finding: fix now, follow-up, rejected
   with a reason. Brief it with the code, not your conclusion.
4. **Fix.** The fixer applies, in one round: fix-now findings, review-bot comments per the PR policy
   (fix or answer each), and every red CI check; it answers each thread it addressed. Repeat 3–4 only
   within `rounds`.
5. **QA** (when `qa` is not `none`): an agent with the repo's QA skill against the requirements, after a
   preflight (sign-ins, model budget, services reachable). It reports; findings go back to step 4.
6. **Verify and report.** `gh pr checks <n>`; `gh pr view <n> --json mergeable,headRefOid`; no
   unanswered threads. Tell Marcos in a few lines: PR, head SHA, checks, what is left for him (approval,
   manual checks, merge) and the follow-ups filed.

## Always

- One agent works in a worktree at a time; another may only watch CI. Parallel agents collide on hooks,
  builds and ports.
- Brief agents to run long commands in the foreground with a timeout, never in the background while
  ending their turn. Check them actively about every 20 minutes (`git log`, `pgrep`), not only on notices.
- After every push: `mergeable`. A PR in conflict with its base runs no CI and says nothing; a rebase
  needs Marcos's force-push ok.
- A failing e2e is real until it fails alone: rerun it with nothing else running on the machine before
  calling it flaky.
- Review bots review the whole PR on every push. After the agreed `bots` rounds, stop chasing new
  findings: defer or contest them in their thread.

Done when CI is green or every red check has a stated owner, the PR is mergeable, and Marcos has the
summary.
