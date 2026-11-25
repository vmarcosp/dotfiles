---
name: handoff
description: Write or read the orchestrator's handoff note in Marcos's Brain so a long session survives /compact or a restart. Use before /compact or at the end of a session ("/handoff", "/handoff write"), and right after /compact or in a fresh session to resume ("/handoff read", "retoma", "onde paramos").
---

The handoff is one note per epic or task in the Brain, overwritten each time:
`~/projects/brain/Agent/<Projeto>/<ÉPICO> <nome>/handoff.md`. It holds "where I am now"; the epic's
`Estado.md` holds the longer state and `Runs/* — decisões.md` the run logs. The Brain's rules are in
the `brain` skill.

Subagents started with the Agent tool keep running across `/compact` in the same session, but not into
a new session. A handoff for a new session lists them as "to restart", not "running".

## Find the note

1. List `~/projects/brain/Agent/*/*/handoff.md`. Pick the epic from the argument, from the folder this
   session already used, or by matching a Jira key: a story key (e.g. FSPG-1344) maps to its epic
   through the `Estado.md` phase table.
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
   - **Next steps:** in order, naming the first one exactly (for example "Estado › Até a Fase 4, item 1").
   - **Do not reopen:** decisions already taken.
   - **Local state:** env lines, forged versions, ports, spare worktrees, backup tags with the repo they
     live in.
2. Overwrite `handoff.md` with the frontmatter (`date`, `type: notes`) and the sections `Running`,
   `PRs`, `Waiting on Marcos`, `Next steps`, `Do not reopen`, `Local state`, in en-US. Link `[[Estado]]`
   and the active run log. Keep it under ~60 lines: detail belongs in `Estado.md` or the run log.
3. If a milestone changed (phase closed, scope decided), update `Estado.md` too.
4. Append one line to the active run log, if any: date, "handoff escrito".
5. Tell Marcos the path and that he can `/compact`.

Done when the file is written and every running item names its agent or process, worktree and push state.

## /handoff read

1. Read `handoff.md`, `Estado.md`, the tail (last ~80 lines) of the active run log and
   `~/projects/brain/Agent/Método/Como trabalhar com o Marcos.md`. After a `/compact` or in a new
   session, always read all four.
2. Check reality against the note, read-only:
   - each worktree: `git -C <wt> fetch -q` then `git -C <wt> status -sb` and `git -C <wt> log --oneline -3`;
   - each PR: `gh pr view <n> -R <repo> --json state,mergeable,headRefOid,statusCheckRollup`;
   - each process: `run-yokai.sh status <log>` for a Yokai run, `pgrep -fl "<command in the note>"` otherwise;
   - each subagent: in the same session, its notification; in a new session, treat it as stopped.
3. Update the affected lines of `handoff.md` with what you found (it is in `Agent/`, so this is allowed).
4. Tell Marcos in at most 6 lines: what is running, what waits on him, the next step you will take, and
   each drift. Then continue; do not redo finished work.

Done when the summary is sent and `handoff.md` matches what step 2 found.
