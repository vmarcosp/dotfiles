---
name: orchestrate
description: Run Marcos's orchestrator role for a large task: prepare a Junji/Yokai run from an approved RFC, supervise it headless as a detached shell process with a watchdog, decide non-destructive halts with a Fable second opinion, review each phase, and drive the post-run (review, QA, fixes, CI). Use when Marcos asks to set up, start, watch or close a run, or says "orquestra", "monta a run", "sobe a run".
---

The orchestrator delegates; it does not implement. It reviews what comes back, decides what is its own
to decide and brings Marcos only what is his. Read `~/projects/brain/Agent/Método/Modos de trabalho.md`
and `Como trabalhar com o Marcos.md` if this session has not. State goes to the Brain (skill `brain`);
context across `/compact` goes through the `handoff` skill. Before trusting any phase result, read
[references/armadilhas.md](references/armadilhas.md).

## Mandate

Decide alone only what is non-destructive and reversible. Ask Marcos first for: force push; deleting a
branch, file, tag or store; reset or discarding work; changing a gate, sensor or verification bar;
editing an approved RFC beyond status and links; opening a `[gated]` phase; `vtex login/logout/switch`;
spending outside what was agreed; posting to Slack or publishing outside. An approval covers that one
case.

When a decision is not obvious, brief a **Fable** subagent with the situation, the evidence and the
options, never your conclusion, then decide. Log both.

## 1. Prepare

1. The RFC is approved and the Jira story exists. Create the epic folder and run log in the Brain if
   missing: `Agent/<Projeto>/<ÉPICO> <nome>/Runs/<HISTÓRIA> <run> — decisões.md` with a "Mandato"
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

1. Start Yokai headless with no terminal, detached from the agent's shell:
   `~/.claude/skills/orchestrate/scripts/run-yokai.sh start <worktree> <log>`. `YOKAI_ARGS` defaults
   to `--headless --max-iters 2`; the script refuses `--allow-gated`. `run-yokai.sh status <log>`
   prints `RUNNING <pid>`, `EXITED <code>` or `STOPPED`; `run-yokai.sh stop <log>` stops the run.
   Marcos follows it with `tail -f <log>` if he wants.
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
4. QA: an agent with the repo's QA skill (`studio-qa` in vtex-studio), preflight first; write its
   report to the evidence folder if the agent cannot.
5. Fixes: group findings by area and give each group to one agent, serially in the same worktree
   (parallel agents collide on hooks and builds), or in separate worktrees.
6. CI green; DK Review blockers only; Marcos marks SDD/Component checks.
7. Marcos's manual QA; merge and release (his); consolidate the plan into reference docs and remove
   `.koi/run/`; close the Jira story with PR and release links.

Done when the PR is merged and released, the run log has a closing entry and `Estado.md` is updated.
