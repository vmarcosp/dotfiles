---
description: The epic conductor. One tmux window per task, one at a time - opens /fs-task for the next eligible task, moves Jira, merges on your approval, advances the queue. Lives above any PR's lifecycle. Run inside tmux under /loop.
---

You are the **conductor** for an epic. You drive its tasks through `/fs-task`, one at a time, and you advance the queue: open the next task, merge the approved one, move Jira, repeat. You live **above** any PR's lifecycle — you never enter a PR to work comments (that's `/fs-task`'s job). Your only question each tick is: *can I advance?*

The control file is `specs/epics/<epic>.loop.json` (produced by `/json-from-epic`). Resolve `<epic>` from `$ARGUMENTS`; if absent, use the single epic under `specs/epics/`.

You are **one tick** of a loop. Run via `/loop <interval> /fs-loop <epic>`. Long interval — merge approval is human-paced; **20–30 min** is right, not 30s. Each trigger does at most one action and goes back to sleep.

**Resume is free.** The `.loop.json` is the durable state and the guard is stateless, so killing the session and re-running `/fs-loop <epic>` always picks up where you left off — merged tasks stay merged, a `ready` PR goes back to waiting for merge, the next `pending` gets opened. The one case that needs care is an orphaned `in_progress` task (its session died); the `BUSY` handling below detects and reopens it. Don't run two `/fs-loop` for the same epic at once — there's no lock; that's on you.

## 0. Preconditions (cheap, no subagent)

- **Inside tmux.** If `$TMUX` is unset, stop: tell me to start a tmux session first (`tmux new -s fs`), then run the loop inside it. You open a window per task; outside tmux there's nowhere to host them.
- **Git + gh ready**, and `specs/epics/<epic>.loop.json` exists. If the control file is missing, stop and tell me to run `/json-from-epic <epic>` first.

## 1. Read the verdict

```
bash ~/.agents/commands/fs-loop-check.sh <epic>
```

Read the **first line**:

- **`NEXT_TASK <id>`** → go to step 2 (open the next task).
- **`BUSY <id>`** → the task is `in_progress`. Before sleeping, **verify the session is actually alive** (resume safety): check for its tmux window:
  ```
  tmux list-windows -F '#{window_name}' | grep -qx fs-<lowercase-id>
  ```
  - **Window present** → a real `/fs-task` session is running. Say "Task `<id>` em andamento." and sleep.
  - **Window absent (orphan)** → the session died (you killed/restarted the loop, or the machine rebooted). The task is `in_progress` in the JSON but nothing is running it. **Reopen it** (step 2's window command), then notify via `/notification` (title `fs-loop`, message `Retomando <id> — sessão anterior caiu.`, tone `info`) and sleep. The reopened `/fs-task` resumes from the real state — it finds the existing branch/PR/spec and continues from where it stopped (it doesn't restart from scratch). Don't re-claim or touch the status; it's already `in_progress`.
- **`WAIT <id> pr=<n>`** → the ready PR has no merge approval yet. Say "Aguardando aprovação de merge no PR #`<n>`." Sleep.
- **`MERGE <id> pr=<n>`** → go to step 3 (merge).
- **`DONE`** → every task is merged. Say "Épico concluído — todas as tasks mergeadas." **Stop the loop** (don't reschedule). No notification.
- **`STALLED <detail>`** → nothing eligible (deps blocked) or the file is broken. Report the detail to me and **stop the loop**. No notification.

## 2. Open the next task (`NEXT_TASK`)

Order matters — claim before you boot, so the next tick sees `BUSY` and never re-opens the same task:

1. **Claim it.** Set the task's `status` to `in_progress` in `specs/epics/<epic>.loop.json` (jq edit, write back). You own the `pending → in_progress` write.
2. **Open the window.** Background tmux window in the current session, never stealing focus:
   ```
   tmux new-window -d -n fs-<id> -c "$PWD" 'claude "/fs-task <epic> <id>"'
   ```
   (lowercase the `<id>` for the window name, e.g. `fs-fspg-765`). If a window by that name already exists, kill the stale one first.
3. **Notify** via `/notification` (title `fs-loop`, message `Iniciando <id> numa nova janela.`, tone `info`).

Then stop this tick. The `/fs-task` session takes it from here (research → spec → … → ready → its own post-ready watch).

## 3. Merge (`MERGE <id> pr=<n>`)

You saw `@agent: lgtm` / `@agent: pr approved` from me on the **ready** PR. Do the merge sequence:

1. **Jira → Done.** Via Atlassian MCP, `transitionJiraIssue` for `<id>` with the `Done` transition.
2. **Merge.** `gh pr merge <n> --rebase --delete-branch`. If branch protection refuses (a required review missing), retry with `--admin` — I have bypass:
   ```
   gh pr merge <n> --rebase --delete-branch --admin
   ```
   If `gh` still refuses after `--admin`, **stop the loop** and report the error to me — don't force it.
3. **Mark merged + prune.** Set the task `status: merged` in the control file and **delete its `runtime` block** (keep the file from inflating). You own the `ready → merged` write.
4. **Close the task's window:** `tmux kill-window -t fs-<id>` (the `/fs-task` session there sees the PR merged and exits silently on its own; killing the window is the clean teardown).
5. **Notify** via `/notification` (title `fs-loop`, message `PR #<n> mergeado — <id> concluída.`, tone `info`).

Then stop this tick. The next trigger reads `NEXT_TASK` for whatever the merge just unblocked.

## Rules

- **One task at a time.** The guard returns `BUSY`/`WAIT` while a task is live, so you never open a second. Don't override that.
- **You never enter the PR to work comments.** Adjustments (`@agent:` that isn't a merge phrase, third-party reviews) belong to `/fs-task`'s post-ready watch. You read only the merge signal.
- **You write only `in_progress` (on open) and `merged` (on merge).** `/fs-task` writes `ready` + `pr`. No field has two writers.
- **You own window lifecycle**, scoped to your own tmux session — never touch a window you didn't open.
- **Notify only on open and merge.** `DONE`/`STALLED`/merge-failure stop-and-report in chat; no macOS notification.
