---
name: agent-dispatch
description: Dispatches resumable Cursor or Claude workers through detached windows in the orchestrator's tmux session and reads their file-backed responses. Use when delegating work to another local agent, coordinating parallel repository work, resuming a worker, or monitoring a dispatched task without injecting keystrokes into the user's pane.
---

# Agent Dispatch

Use `agent-dispatch` on `PATH`. It treats tmux as a process supervisor and files as the communication channel.
Never use `tmux send-keys` for agent communication.

The dispatcher creates a detached window in the caller's current tmux session. If the caller is outside tmux, pass
`--tmux-session NAME`. It never switches the active window.

## Dispatch

```bash
agent-dispatch send \
  --engine cursor \
  --model claude-sonnet-5-5-high \
  --cwd /absolute/repository/path \
  --name short-task-name \
  --force \
  -- "Complete the task and verify it."
```

Use `--engine claude` for Claude Code. Model names are engine-specific.

`--force` grants mutation permission. Use it only when the user authorized implementation or external writes.
Without it, the worker runs with automatic safe permissions and reports operations that need approval.

For a long prompt, pass `--prompt-file`. The command prints the job ID. Retain it.

Completion criterion: `agent-dispatch status <job-id>` reports `queued` or `running`.

## Receive the response

Do not poll pane scrollback.

```bash
agent-dispatch status <job-id>
agent-dispatch wait <job-id> --timeout 1800
agent-dispatch read <job-id>
```

The dispatcher sends a desktop notification on completion or failure. If the job fails, read:

```bash
agent-dispatch log <job-id>
```

Completion criterion: read the response and verify its claims against the repository or external system before
acting on them.

## Reply

After the worker finishes, resume the same Cursor or Claude conversation:

```bash
agent-dispatch reply <job-id> -- "Address the review findings and rerun the gates."
```

`reply` refuses while a turn is active. Wait for the notification instead of writing into its tmux session.

## Control

```bash
agent-dispatch list
agent-dispatch stop <job-id>
```

State lives under `${XDG_STATE_HOME:-~/.local/state}/agent-dispatch/jobs/<job-id>/`. Each turn stores its prompt,
response and stderr log. A worker uses a detached window in the orchestrator's session, so dispatch and replies
never alter the user's active window or partially typed input.
