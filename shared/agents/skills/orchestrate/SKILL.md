---
name: orchestrate
description: Run Marcos's orchestrator role for a large task: prepare a Junji/Yokai run from an approved RFC, supervise it headless in a Rex pane beside the session (detached shell process outside Rex) with a watchdog, decide non-destructive halts with a Fable second opinion, review each phase, and drive the post-run (review, QA, fixes, CI). Use when Marcos asks to set up, start, watch or close a run, or says "orchestrate", "set up the run", "start the run".
---

The orchestrator delegates; it does not implement. It reviews what comes back, decides what is its own
to decide and brings Marcos only what is his. Read `~/projects/brain/Agent/Method/Working modes.md`
and `Working with Marcos.md` if this session has not. State goes to the Brain (skill `brain`);
context across `/compact` goes through the `handoff` skill. Before trusting any phase result, read
[references/traps.md](references/traps.md).

## Mandate

Decide alone only what is non-destructive and reversible. Ask Marcos first for: force push; deleting a
branch, file, tag or store; reset or discarding work; changing a gate, sensor or verification bar;
editing an approved RFC beyond status and links; opening a `[gated]` phase; signing a CLI in or out or switching its account;
spending outside what was agreed; posting to Slack or publishing outside. An approval covers that one
case.

When a decision is not obvious, run `/second-opinion` (a Fable with the situation, the evidence and the
options, never your conclusion), then decide. Log both. Default models: `~/.agents/rules/models.md`;
the PR policy of the repo's organization, when there is one, is linked from `~/.agents/AGENTS.local.md`.

## 1. Prepare

1. The RFC is approved and the Jira story exists (if not, `/feature-flow` gets there first). Create the epic folder and run log in the Brain if
   missing: `Agent/<Project>/<EPIC> <name>/Runs/<STORY> <run> — decisions.md` with a "Mandate"
   section copied from above and the environment (worktree, branch, base commit, links, models).
2. Junji: spawn one named **Opus** subagent and keep it alive across verbs (`begin`, `plan`, `refine`).
   Answer its grill questions from the RFC and the rules; bring Marcos only real decisions, one at a time.
3. Yokai with Marcos, not delegated: `/yokai sensors` (smoke the checks; a known failure is approved
   explicitly), `/yokai assess` (tiers and models per phase), `yokai doctor --probe` green.
4. Write the handoff (`/handoff write`). Marcos usually runs `/compact`; start the run only in the fresh
   context after `/handoff read`.

Done when doctor is green, tiers are approved by Marcos, the run log exists and the handoff names the
start command.

## 2. Start and watch

1. Start Yokai headless: `~/.claude/skills/orchestrate/scripts/run-yokai.sh start <worktree> <log>`,
   with the log outside the repo (e.g. `~/.worktrees/yokai-<story>.log`). Inside Rex (`REX_SESSION` and
   `REX_BLOCK` set) it opens a pane to the right of the orchestrator's pane, without taking focus, and
   Marcos watches the run there; the output also goes to the log. Outside Rex (SSH, cloud) it runs
   detached with `nohup`. `YOKAI_ARGS` defaults to `--headless --max-iters 2`; the script refuses
   `--allow-gated`. `run-yokai.sh status <log>` prints `RUNNING <pid>`, `EXITED <code>` or `STOPPED`;
   `run-yokai.sh stop <log>` stops the run and leaves the pane open on its last output. The pane's
   block id is in `<log>.block`; read it with `rex capture -s "$REX_SESSION" -b <block> --trim`. Never
   type into the pane; closing it kills the run.
2. Start the watchdog with the Bash tool in the background:
   `~/.claude/skills/orchestrate/scripts/watchdog.sh <worktree> <log> [precheck]`.
3. On each watchdog exit, act, log one entry (time, phase, what happened, decision, Fable's view if
   asked, how to undo) and start the watchdog again:
   - `NEW_COMMIT` → review the phase: `git show --stat`, the phase plan's Outcome, the judge lines in the
     log; for e2e claims, the build transcript. Note follow-ups for the post-run list.
   - `HALTED` / `STALLED` / `DEAD` / `STOPPED` / `PRECHECK_FAILED` (the line carries Yokai's exit
     status) → read the log tail, decide within the mandate,
     escalate otherwise. A defect found mid-run that later phases do not depend on goes to the post-run
     list instead of stopping the run.
   - `FINISHED` → go to 3.
4. Tell Marcos about each phase in a few lines; between phases, answer his questions without touching
   the run's worktree.

Done for a phase when it is reviewed and logged.

## 3. Post-run

Defaults, unless Marcos says otherwise:

1. Run the e2e suite once from the place that rebuilds; fix real breaks first.
2. Push and open the PR (repo's `open-pr` skill).
3. Review: **Fable** for a run or a large PR (`/code-review … --comment`), **Opus** for a small one.
4. QA: an agent with the repo's QA skill, preflight first (sign-in, budget, services up); write its
   report to the evidence folder if the agent cannot.
5. Fixes: group findings by area and give each group to one agent, serially in the same worktree
   (parallel agents collide on hooks and builds), or in separate worktrees. Each group follows the fix
   and verify steps of `/pr-loop`.
6. Consolidate on the same PR, **before the merge**: `/junji consolidate` and the repo's `consolidate`
   skill turn the plan into reference docs, set the RFC to Implemented (and its ADRs' status), rewire
   links and remove `.koi/` with `git rm`. The merge must never land the run's plan on main.
7. CI green, per the organization's PR policy (review bots: blockers only after round one; Marcos
   marks the manual checks).
8. Marcos's manual QA; merge and release (his); close the Jira story with PR and release links.

Done when the PR is merged and released with no `.koi/` on main, the run log has a closing entry and
`State.md` is updated.
