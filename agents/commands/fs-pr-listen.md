---
description: One PR watch cycle - checks pending comments and relaunches the fs-implementer subagent to fix them (it drives /pr-agent for owner @agent: comments, /pr-feedback for third-party). Plan round notifies and waits for my ok; apply round runs after. Meant to run inside /loop.
---

You are **one cycle** of a PR watch loop, owned by `/fs-task` for a single task's PR. Run it via `/loop 15m /fs-pr-listen` (or whatever interval I choose). Each trigger does at most one round of work and goes back to sleep; the loop reschedules. You kill the loop when the PR closes.

You handle **adjustments only**. Merge is **not** yours — `/fs-loop` watches for `@agent: lgtm` / `@agent: pr approved` and merges. The guard script already excludes those phrases from what it hands you, so you never act on a merge approval.

## 1. Check the state (cheap, no subagent)

Run the guard script. If I passed a PR number in `$ARGUMENTS`, hand it through; otherwise it resolves from the current branch.

```
bash ~/.agents/commands/fs-pr-listen-check.sh $ARGUMENTS
```

The script reads the owner login (whose `@agent:` comments trigger RESOLVE) from `FS_AGENT_LOGIN`, with fallback `vmarcosp`. Read the **first line** of the output:

- **`MERGED`** → `/fs-loop` merged the PR (the task is done). Say "PR merged, stopping the loop." and **don't reschedule** — let the loop end. **Exit silently — do NOT notify**: `/fs-loop` already notified the merge, and a second notification would be noise.
- **`CLOSED`** → the PR was closed unmerged. Say "PR closed unmerged, stopping the loop." and **don't reschedule**. Notify via `/notification` (title `fs-pr-listen`, tone `alert`, message `PR fechado sem merge - watch encerrado.`) — this one is unexpected and worth flagging.
- **`NO_NEW`** → there are no pending comments. Say "No new comments." and do nothing else this round. The loop goes back to sleep.
- **`RESOLVE`** → the **second line** is a JSON array of `@agent:` comments from the owner. The implementer drives `/pr-agent`. Go to step 2.
- **`FEEDBACK`** → the **second line** is a JSON array of comments from other reviewers. The implementer drives `/pr-feedback`. Go to step 2.

Both `RESOLVE` and `FEEDBACK` are handled the same way: relaunch the **`fs-implementer`** subagent to work the comments. You don't invoke `/pr-agent` or `/pr-feedback` yourself in the main window — the implementer does, inside its **Fix reviews** section. Your job here is to route, inject, gate, and relaunch.

The fix runs in **two rounds**, with your approval in the middle. Hold the JSON array from the script's second line — that's what you inject.

## 1.5. Anti-loop filter (cap 3 per comment)

Before working the comments, guard against insisting forever on a comment you can't satisfy. The counter lives in the task's `runtime.comments[<comment-id>]` in the control file.

**Locate the control file + task first.** You're on the task branch `feat/<id>-<slug>`, which has no epic name in it. Resolve it:
1. Extract the task `<id>` from the current branch: `git branch --show-current` → take the `feat/` segment up to the slug (e.g. `feat/fspg-766-grounded-eval` → `fspg-766`), uppercased to the Jira form (`FSPG-766`).
2. Find the control file that owns it: scan `specs/epics/*.loop.json` for the one whose `tasks[]` contains that `id`. That file is `<epic>.loop.json`; the matching task entry is where `runtime.comments` lives.

If you can't resolve it (no matching control file — e.g. a standalone run with no `.loop.json`), **skip the counter entirely** and just work the comments. The cap is a safety net, not a hard requirement.

With the task entry located, for each comment in the JSON array from the script:
- If it already has `skip` set → **drop it** from this round's list (you gave up on it; don't re-treat).
- Else read `rounds` (0 if absent). If `rounds >= 3` → set `skip` to a short reason ("não resolvido em 3 rounds"), notify me once via `/notification` (tone `alert`, naming the comment), and **drop it** from the list.
- Else this comment proceeds; you'll bump its `rounds` by 1 in the apply round (step 3).

If every comment got dropped, treat the round as `NO_NEW` — nothing left to do; the loop sleeps. Otherwise continue with the surviving comments. The watch stays alive regardless — capping a single comment never kills the loop.

## 2. Round 1 - plan (subagent fs-implementer, plan mode)

Fire the **`fs-implementer`** subagent (`subagent_type: "fs-implementer"`) in **plan mode**, with the surviving comments. Inject:
- the verdict (`RESOLVE` or `FEEDBACK`) and the JSON array of comments from the script
- which skill it should drive: `RESOLVE` → `/pr-agent` (owner `@agent:` comments); `FEEDBACK` → `/pr-feedback` (third-party reviewers)
- the spec path (`specs/<id>.md`) and task block, for scope

In plan mode the implementer fetches the items via that skill, builds a fix plan, **applies nothing**, notifies me via `/notification`, and returns the plan to you. Show me the plan and **stop this round** — wait for my ok. Don't relaunch on your own; the next trigger of the loop won't apply anything either, because the comments are still pending. The apply only happens once I say ok in the session.

## 3. Round 2 - apply (subagent fs-implementer, apply mode)

Once I reply ok to the plan, fire the **`fs-implementer`** subagent again in **apply mode**, injecting the approved plan plus the same comment JSON and skill. It applies the fix, commits, pushes, and lets the skill resolve/reply on the threads.

**Bump the counter.** For each comment worked this round, increment its `runtime.comments[<id>].rounds` in the control file (so a comment that keeps coming back trips the cap at step 1.5 on a later round).

Notify on finish via `/notification` (title `fs-pr-listen`, message `PR comments resolved. Check them and approve if they look good.`).

Then stop this round. The loop goes back to sleep.

## Rules

- Don't take the PR to ready or merge it — merge is `/fs-loop`'s (`@agent: lgtm` / `pr approved`); the guard excludes those phrases from your list.
- Don't apply a fix without my ok on the plan first - plan round notifies and stops; apply round only runs after I say ok.
- Don't re-handle already-resolved comments: inline ones drop off via GitHub's `isResolved`; for general ones, trust the skill's own earlier reply in the thread.
- Don't insist past the cap: a comment with `skip` set, or `rounds >= 3`, is dropped (step 1.5). Capping a comment never kills the watch.
- One round = at most one subagent launch (plan OR apply). Don't sit in an internal loop; let `/loop` set the pace.
- `RESOLVE` takes priority over `FEEDBACK` - the script already guarantees this in its output; trust it.
