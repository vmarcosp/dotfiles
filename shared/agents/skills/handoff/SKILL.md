---
name: handoff
description: Write or read the orchestrator's handoff note in Marcos's Brain so a long session survives /compact or a restart. Use before /compact or at the end of a session ("/handoff", "/handoff write"), and right after /compact or in a fresh session to resume ("/handoff read", "resume", "where were we"), and when an epic or task ends ("/handoff close").
---

The handoff is one note per epic or task in the Brain, overwritten each time:
`~/projects/brain/Agent/<Project>/<EPIC> <name>/handoff.md`. It holds "where I am now"; the epic's
`State.md` holds the longer state and `Runs/* — decisions.md` the run logs. The Brain's rules are in
the `brain` skill.

Subagents started with the Agent tool keep running across `/compact` in the same session, but not into
a new session. A handoff for a new session lists them as "to restart", not "running".

## Find the note

1. List `~/projects/brain/Agent/*/*/handoff.md`. Pick the epic from the argument, from the folder this
   session already used, or by matching a Jira key: a story key (e.g. PROJ-123) maps to its epic
   through the `State.md` phase table.
2. More than one candidate, or none: ask Marcos with numbered options. A new epic folder is created
   only after he confirms its name.

Done when one path is chosen.

## /handoff write

1. Gather from this session, not from memory of older ones. For each item, write where it lives so a
   reader can check it:
   - **Running:** what it does, the agent's name or description, the process command (for a Yokai run,
     the `run-yokai.sh` log path and, in Rex, the pane's block id from `<log>.block`), the worktree, and the push state (`git -C <wt> status -sb`: ahead/behind origin).
   - **PRs:** number, head SHA, mergeable state, failing checks by name.
   - **Waiting on Marcos:** each item as a concrete action.
   - **Next steps:** in order, naming the first one exactly (for example "State › Before phase 4, item 1").
   - **Do not reopen:** decisions already taken.
   - **Local state:** env lines, forged versions, local services and their ports, sign-ins the work
     needs, spare worktrees, uncommitted work, with the repo or path each lives in.
2. Overwrite `handoff.md` with the frontmatter (`date`, `type: notes`) and the sections `Running`,
   `PRs`, `Waiting on Marcos`, `Next steps`, `Do not reopen`, `Local state`, in en-US. Link `[[State]]`
   and the active run log. Keep it under ~60 lines: detail belongs in `State.md` or the run log.
3. If a milestone changed (phase closed, scope decided), update `State.md` too.
4. Append one line to the active run log, if any: date, "handoff written".
5. Tell Marcos the path and that he can `/compact`.

Done when the file is written and every running item names its agent or process, worktree and push state.

## /handoff read

1. Read `handoff.md`, `State.md`, the tail (last ~80 lines) of the active run log and
   `~/projects/brain/Agent/Method/Working with Marcos.md`. After a `/compact` or in a new
   session, always read all four.
2. Check reality against the note, read-only:
   - each worktree: `git -C <wt> fetch -q` then `git -C <wt> status -sb` and `git -C <wt> log --oneline -3`;
   - each PR: `gh pr view <n> -R <repo> --json state,mergeable,headRefOid,statusCheckRollup`;
   - each process: `run-yokai.sh status <log>` for a Yokai run, `pgrep -fl "<command in the note>"` otherwise;
   - each subagent: in the same session, its notification; in a new session, treat it as stopped;
   - each local service in Local state: its health check or port (`lsof -nP -iTCP:<port> -sTCP:LISTEN`);
   - each sign-in the work needs (CLIs, VPN): its status command; a machine reboot can sign CLIs out;
   - each worktree's uncommitted work (`git -C <wt> status -s`): a dead agent may have left edits
     that the next agent must resume, not redo.
3. Update the affected lines of `handoff.md` with what you found (it is in `Agent/`, so this is allowed).
4. Tell Marcos in at most 6 lines: what is running, what waits on him, the next step you will take, and
   each drift. Then continue; do not redo finished work.

Done when the summary is sent and `handoff.md` matches what step 2 found.

## /handoff close

When the epic or task ends (merged, released, or dropped):

1. Read `State.md`, `handoff.md` and the run logs. Move what stays true out of the folder: a lasting
   technical decision to the repo (RFC, ADR, reference), open follow-ups to Jira (with Marcos's ok),
   stable project facts and new traps to `<Project>/Context.md`, lessons about the method to
   `Method/`. Nothing about the finished work itself stays in the Brain.
2. Delete the epic folder (the vault's git keeps the history).
3. List the leftovers outside the Brain for Marcos: worktrees, branches, local services, temp folders,
   evidence folders, unmerged PRs, open Jira items, unpushed commits. Clean only what he approves.

Done when the folder is gone, nothing true was lost, and Marcos has the leftover list.
