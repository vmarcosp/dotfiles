---
description: One PR watch cycle - checks pending comments and routes: @agent: from the owner → /pr-agent; third-party comments → /pr-feedback. Meant to run inside /loop.
---

You are **one cycle** of a PR watch loop. Run it via `/loop 15m /fs-pr-listen` (or whatever interval I choose). Each trigger does at most one round of work and goes back to sleep; the loop reschedules. You kill the loop when the PR closes.

## 1. Check the state (cheap, no subagent)

Run the guard script. If I passed a PR number in `$ARGUMENTS`, hand it through; otherwise it resolves from the current branch.

```
bash ~/.agents/commands/fs-pr-listen-check.sh $ARGUMENTS
```

The script reads the owner login (whose `@agent:` comments trigger RESOLVE) from `FS_AGENT_LOGIN`, with fallback `vmarcosp`. Read the **first line** of the output:

- **`MERGED`** or **`CLOSED`** → the PR closed. Say "PR closed ($verdict), stopping the loop." and **don't reschedule** - let the loop end. Notify via `/notification` (title `fs-pr-listen`, message `PR closed - watch loop stopped.`).
- **`NO_NEW`** → there are no pending comments. Say "No new comments." and do nothing else this round. The loop goes back to sleep.
- **`RESOLVE`** → the **second line** is a JSON array of `@agent:` comments from the owner. Go to step 2.
- **`FEEDBACK`** → the **second line** is a JSON array of comments from other reviewers. Go to step 3.

## 2. Resolve @agent: comments from the owner

There are `@agent:` comments. Invoke `/pr-agent` **in the main window**. It will list the threads, propose an action, and ask for confirmation on each one. When it's done, it pushes.

Notify on finish via `/notification` (title `fs-pr-listen`, message `PR comments resolved. Check them and approve if they look good.`).

Then stop this round. The loop goes back to sleep.

## 3. Handle third-party feedback

There are comments from other reviewers (not the owner). `/pr-feedback` is interactive - it requires plan approval (Gate 1) before acting, and refuses a non-interactive context by design. Invoke it **now, in the main window** (not in a subagent), so Gate 1 can happen:

1. Notify first via `/notification` (title `fs-pr-listen`, message `There's reviewer feedback on the PR - starting /pr-feedback.`).
2. Show a summary of the comments found (author + one line of context each).
3. Invoke `/pr-feedback` directly. It runs the full cycle: detect conventions → fetch threads → propose plan → Gate 1 (I approve) → execute → push → replies → resolve.
4. When `/pr-feedback` finishes, this round ends normally. `/loop` reschedules the next round on the interval - you don't need to do anything.

## Rules

- Don't take the PR to ready or merge it - that's mine.
- Don't re-handle already-resolved comments: inline ones drop off via GitHub's `isResolved`; for general ones, trust your own earlier reply in the thread.
- One round = at most one resolution cycle. Don't sit in an internal loop; let `/loop` set the pace.
- `RESOLVE` takes priority over `FEEDBACK` - the script already guarantees this in its output; trust it.
