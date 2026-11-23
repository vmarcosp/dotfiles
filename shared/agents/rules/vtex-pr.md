Pull requests in VTEX repositories (vtex, vtex-apps, vtex-prototypes and the like). Apply when pushing,
reviewing or fixing a PR there.

## Checks and bots

- **DK Review.** First round: address every finding. After that, fix only blockers (RESTRICT). A
  blocker that contradicts the repo's policy or an approved decision is contested in its thread with the
  reason, not "fixed".
- **Arnica.** "jwt.decode" on a `.decode()` of a `TextDecoder` or a parser is a false positive. Package
  reputation alerts on internal packages (and transitive deps you cannot change in that repo) are not
  fixable in the PR: say so in the PR, do not add workarounds.
- **CodeRabbit.** Fix the comment or answer it; never leave it silent.
- **SDD / Component checks.** Marcos marks them, or the agent with his explicit ok for that PR.

## Pushing

- After every push: `gh pr view <n> --json mergeable,mergeStateStatus`. A conflict with the base stops
  the PR's CI without any error (GitHub does not run the workflow).
- Force push only with Marcos's explicit ok for that push, as `git push --force-with-lease`, after a
  backup tag `backup/<pr>-pre-rebase` in that repo. One ok covers one push.
- Integrate with rebase when the repo says so; no merge commits there.
