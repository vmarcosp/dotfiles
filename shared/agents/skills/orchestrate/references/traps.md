# Traps in a run (learned the hard way)

Read before accepting a phase as green.

## Evidence

- **A phase's e2e is self-reported.** The Yokai gate runs the sensors (lint, typecheck, unit); the judge
  runs nothing. Check the Build transcript (`~/.claude/projects/<worktree-slug>/<session>.jsonl`; the ids
  are in the Yokai log, line `claude session …`) for the reporter line of each spec in Verify.
- **Stale build.** In a monorepo, a package's e2e script may not rebuild (often only the root script
  does). A "green" e2e on an old build proves nothing.
- **Specs that skip silently** for a missing env var count as "passed" in the summary. Read the
  `N passed, M skipped` line.
- **An assertion moved to a later phase**: note it in the log and check it in the phase that should
  restore it.
- **Flaky or real?** Two e2e runs on the same machine (another worktree, another session) collide on
  ports and resources. Rerun the spec alone before calling it flaky; when it fails alone, it is real.
- **Spec races with automatic turns.** A spec that hands a stub model its next script right after a
  turn can lose it to an automatic follow-up turn. Wait for that turn's own marker first.

## Running the run

- **Do not edit the BACKLOG while the run is live**: the driver rewrites it. Wait for the halt.
- **An orchestrator commit in the middle of a phase**: only with `git commit -- <file>`, so the phase's
  work does not go with it. It fires the watchdog's NEW_COMMIT.
- **A linked local dependency** (symlink to another repo's build): `pnpm install` undoes it; a watchdog
  precheck re-links it. The linked package's version may read `0.0.0` and break what reads it.
- **Shared resources**: debug ports, local service ports and build output folders. Two e2e or live
  agents in the same worktree collide; use another worktree and another port.
- **Rex pane of the run**: closing the pane kills Yokai (there is no `nohup` in Rex mode); the watchdog
  sees `DEAD` and its restart opens a new pane. `/compact` or restarting Claude does not kill the run:
  the pane belongs to Rex. Never type into the pane (Yokai runs with stdin on `/dev/null`).

## Subagents and sessions

- **A subagent "idle, waiting for tests" may be stuck for good.** A subagent that starts a command in
  the background and ends its turn does not always wake when the command ends. Ask for long commands in
  the foreground with a timeout. After each "idle" notice, check `pgrep` and `git log`; if nothing
  runs, tell it to resume. Check actively about every 20 minutes instead of waiting for a notice.
- **A machine reboot** kills subagents, background processes and local services, and can sign CLIs
  out. After one: check each worktree's uncommitted work, restart services, check sign-ins, then
  respawn agents from where the work stopped.
- **Login and budget**: run the QA preflight (valid sign-in, model budget, services reachable) before
  live QA; CLI tokens expire.

## The PR

- **Main moves during the post-run.** A PR in conflict with its base runs no CI and gives no error.
  After each push, `gh pr view --json mergeable`; a rebase needs a force-push ok.
- **Consolidate before the merge**, on the run's PR: the run's plan must never land on main.
- **Review bots review the whole PR on every push** and can find something new each round. After the
  agreed rounds, close instead of chasing new findings; contest or defer them in their thread.
