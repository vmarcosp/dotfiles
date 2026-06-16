---
alwaysApply: true
---

When using the `specification` or `implementing` skills — stay on the current branch and use a single draft PR that evolves from spec to implementation.

## `/specification`

1. Do not create a new branch — use whatever branch is currently checked out
2. After writing `specs/<feature-name>.md`, commit only that file
3. Open a **draft** PR against the base branch with:
   - Title: `spec: <feature-name>`
   - Body: minimal, temporary placeholder (one-line summary linking the spec) — full description comes later from `implementing`
4. Do not mark the PR ready for review

## `/implementing`

1. Do not create a new branch — use the current branch (the same one the spec PR is on)
2. Run the normal implementing loop (tests, code, commits)
3. When done, push to the existing branch and **update the existing PR** instead of opening a new one:
   - Run `/open-pr` to produce the final title and body — it handles Jira linking, conventional commit title, and the standard body template
   - Apply via `gh pr edit --title "..." --body "..."` (do NOT run `gh pr create`)
   - Mark it ready for review: `gh pr ready`
4. Update the spec status to `Done` as usual
