# claude-agent

A lightweight local agent runner that executes Claude Code workflows on a schedule.

## Concept

Workflows are defined as JSON files. A scheduler picks them up, runs Claude Code with the appropriate prompt and context, and logs the output. A TUI provides a live view of running workflows and their logs.

## Workflows

The first workflows:

- **pr-review**: Monitors configured repos for PRs requesting your review and runs an autonomous review
- **pr-respond**: Monitors PRs you authored for new comments and responds on your behalf

## Design principles

- No magic: workflows are plain JSON, runner is a plain script
- Cheap by default: use `gh` CLI to filter before calling Claude, so tokens are spent only when there is real work
- Local-first: runs on your machine using your existing `gh` and Claude Code authentication
- Minimal surface: add a workflow by dropping a JSON file, remove it by deleting the file
