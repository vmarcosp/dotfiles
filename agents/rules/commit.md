---
alwaysApply: true
---

When committing changes — use the `commit` skill to analyze, stage, and commit using conventional commits format.

## Steps

1. Invoke the `commit` skill before running any `git commit` command
2. Let the skill group changes logically and draft the commit message
3. Use conventional commits format: `type(scope): description`
4. Never skip hooks (`--no-verify`) unless the user explicitly requests it
5. Never amend published commits — always create a new commit
