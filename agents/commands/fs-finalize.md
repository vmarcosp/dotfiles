---
description: Cleans up a finished faststore roadmap, updates ADRs/RFCs if invalidated, and rewrites the feature PR for review.
argument-hint: "[roadmap-path] [feature-branch] [root-branch]"
model: opus
---

# Roadmap finalizer

Run once, after every task in the roadmap at `$0` has been executed and merged into `$1` (the
feature branch). This does not touch main — the feature branch's PR into `$2` (root branch, e.g.
`main`; opened when the roadmap started) is long-running and already exists.

## 1. Inventory

Diff `origin/$2...$1` for the full file list touched across the roadmap. Read the roadmap file,
every carry-over doc it references, and every spec under `specs/` that a task in this roadmap
created.

List every per-task PR merged into `$1`:
`gh pr list --base $1 --state merged --json number,title,url,mergedAt,body`, sorted by `mergedAt`
ascending. This is the source of truth for task order and per-task detail — don't reconstruct it
from memory or from the roadmap file, since either can drift from what actually merged.

Each such PR's body ends with a `Task: <taskId>` / `Spec: <specPath>` pair (written by
`fs-implementer` on delivery) — grep for that exact pattern to map PR → task → spec. A PR missing
this pair predates the convention or was delivered outside this workflow; note it as a gap rather
than guessing its task from the title.

## 2. Disposable vs. durable

Disposable (delete once folded into step 3): the roadmap file itself, all its carry-over docs, and
every task spec generated for it. These were working memory for the roadmap, not documentation.

Durable (never delete): anything under `docs/**/adr-*.md` or `docs/**/rfc-*.md`.

## 3. Reconcile durable docs

Spawn a `general-purpose` agent (model `opus`) with the full diff, the roadmap, and every spec from
step 1. Ask it to identify existing ADRs/RFCs whose content the roadmap's changes contradict or
made stale — not to draft new ones. For each, propose the specific edit. Apply only edits you'd
confidently defend to a reviewer; when genuinely unsure whether a doc is stale, leave it and flag it
as a follow-up in the PR instead of guessing.

## 4. Clean up

Delete the disposable docs from step 2. Commit as `chore(roadmap): clean up <roadmap-name> working docs`.
If step 3 produced doc edits, commit those separately (`docs(adr): ...` / `docs(rfc): ...`) — never
bundle a durable-doc edit into the same commit as a deletion.

## 5. Rewrite the PR

Rewrite the existing `$1` → `$2` PR's description (`gh pr edit --body`, find it via
`gh pr list --head $1 --base $2`) so a reviewer can work from it alone:
- Summary of what the roadmap delivered, by task.
- Which docs to read first (updated ADRs/RFCs from step 3, plus any still-open follow-up from step 3).
- How to review: the meaningful commits/diff ranges, not "see all commits."
- How to test end-to-end: concrete steps to run the result locally, not "run the test suite."
- A "Task PRs" section: the per-task PRs from step 1, in merge order, each as `#<number> — <title>`
  linking to its URL — so a reviewer can open any task in isolation instead of only the squashed
  diff.

## 6. Richview + artifact

Run `/richview` against the PR (diff, description, and the docs from step 5) to produce a visual
summary. It lands in `.artifacts/` per its own convention — zip that output there too, so it's ready
for you to attach as a PR comment upload yourself. Do not post it to GitHub; that upload is manual.

## Never

Never merge or approve the PR yourself, never delete an ADR/RFC (edit or leave, don't remove), never
guess a durable-doc edit you're not confident in — flag it instead.
