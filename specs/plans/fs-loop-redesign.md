# Plan — Epic loop orchestration (`/fs-loop`, `/json-from-epic`, `/fs-task`)

## Goal

Turn the manual `/fs-next-task` flow into an autonomous epic driver. Three pieces, disjoint responsibilities:

- **`/json-from-epic`** (skill) — parse an `/epic` markdown into a `.loop.json` control file. Idempotent.
- **`/fs-loop`** (command) — the **epic conductor**. One tmux window per task, one task at a time. Moves Jira, merges on approval, advances the queue. Lives *above* any PR's lifecycle.
- **`/fs-task`** (command, renamed from `/fs-next-task`) — owns **one task's whole PR lifecycle**: research → spec → spec-gate → implement → smoke → review → ready → post-ready adjustments, until the PR is merged out from under it.

All commands/skills live in `agents/*` here in dotfiles (symlinked into `~/.claude/*`). The `.loop.json` lives in the consuming repo at `specs/epics/<epic>.loop.json`.

## Vocabulary — the `@agent:` signals (disjoint by PR state)

| Signal | PR state | Owner | Effect |
|---|---|---|---|
| `@agent: spec approved` / `@agent: plan approved` | **draft** | `/fs-task` (spec gate) | release implementation |
| any other `@agent:` | **draft** | `/fs-task` | adjust the spec via `/pr-agent` |
| `@agent: lgtm` / `@agent: pr approved` | **ready** | `/fs-loop` (merge gate) | merge the PR |
| any other `@agent:` (owner) | **ready** | `/fs-task` (`/fs-pr-listen`) | work the comment (`/pr-agent`) |
| third-party review (inline, unresolved) | **ready** | `/fs-task` (`/fs-pr-listen`) | work the comment (`/pr-feedback`) |

The two approval channels are **disjoint by phrase**, so they can't collide regardless of PR state:
- **spec gate** — `^@agent:[[:space:]]*(spec|plan)[[:space:]]+approved` (case-insensitive). Only `spec approved` / `plan approved`.
- **merge gate** — `^@agent:[[:space:]]*((pr[[:space:]]+)?(approved|aprovad[oa])|lgtm)`. `lgtm` / `pr approved` / bare `approved` / `aprovado`.

A bare `@agent: approved` is **merge**, not spec — the spec gate requires the explicit `spec`/`plan` word, so there's no overlap. The two `MERGE_RE` copies (in `fs-loop-check.sh` and `fs-pr-listen-check.sh`) must stay byte-identical.

## State model (`.loop.json`)

```
pending → in_progress → ready → merged
```

- **pending** — not started.
- **in_progress** — `/fs-task` claimed it; PR not yet ready (still draft / mid-implementation).
- **ready** — PR out of draft, Jira *In Review*, waiting for merge approval. `pr` is set.
- **merged** — `/fs-loop` merged it; Jira *Done*.

`/fs-task` elects the next task as: first `pending` whose deps are **all `merged`** (never build on un-merged code). One task active at a time: if any task is `in_progress` or `ready`, nothing new is elected.

### File shape (`specs/epics/<epic>.loop.json`)

```jsonc
{
  "epic": "generate-store",
  "base": "main",
  "tasks": [
    { "id": "FSPG-764", "deps": [], "status": "merged", "pr": 12 },
    { "id": "FSPG-765", "deps": ["FSPG-764"], "status": "ready", "pr": 13,
      "runtime": {                                  // present only while the task is live
        "comments": { "<comment-id>": { "rounds": 2, "skip": null } }
      }
    },
    { "id": "FSPG-766", "deps": ["FSPG-765"], "status": "pending", "pr": null }
  ]
}
```

- `runtime` is the ephemeral per-comment state (anti-loop counter `rounds`, `skip` reason). **`/fs-loop` prunes `runtime` when it sets a task to `merged`** — so the file never inflates: at most one live task carries it. If extracting `runtime` to a sibling file is ever wanted, it's a localized change.
- `base` is always `main` (no aggregating `feat/<epic>` branch anymore).

## Files to create / change

### New: `agents/skills/json-from-epic/SKILL.md`
Skill that reads `specs/epics/<epic>.md`, parses the stream task lines, and writes/reconciles `specs/epics/<epic>.loop.json`.

- **Parse**: the stream section lines of the form
  `- [ ] FSPG-764 — <title> → <spec-path>  ·  depends_on: [FSPG-..., ...]`
  Extract `id`, `deps`. (`base` comes from a fixed default `main`; `epic` from the filename.)
- **Generate**: if no `.loop.json`, create one with every task `status: pending`, `pr: null`.
- **Reconcile** (idempotent re-run): if it exists, add new tasks, update `deps`, and **preserve** existing `status`/`pr`/`runtime`. Never downgrade a `merged`/`ready` task back to `pending`. Report a diff of what changed.
- Output a short summary (counts: total, pending, in_progress, ready, merged) so a re-run is auditable.
- A small parser script `agents/skills/json-from-epic/parse-epic.sh` (or inline jq/awk) does the deterministic parsing; the skill body orchestrates and reconciles.

### New: `agents/commands/fs-loop.md`
The epic conductor command, run inside tmux under `/loop`.

- **Preconditions**: inside tmux (`$TMUX`), inside a git repo with `gh` auth, `.loop.json` exists at `specs/epics/<epic>.loop.json`. If not inside tmux → stop and tell the user to start one (don't run outside; we open windows per task).
- **Each tick**: run `bash ~/.agents/commands/fs-loop-check.sh <epic>` → read the **first line** verdict:
  - `NEXT_TASK <id>` → **first** set the task `in_progress` in JSON (claim it atomically, before the window boots — closes the re-open race, see review item 7), **then** open a background tmux window `claude "/fs-task <epic> <id>"`, **then notify** (info) "Iniciando <id>". The next tick reads `BUSY <id>` and won't re-open.
  - `BUSY <id>` → a task is `in_progress` (a `/fs-task` session is running). Sleep.
  - `WAIT <id> pr=<n>` → task `ready`, no merge approval yet. Sleep.
  - `MERGE <id> pr=<n>` → saw `@agent: lgtm`/`pr approved` on the **ready** PR. Do the merge sequence (below), **notify** (info) "PR #<n> mergeado, <id> concluída".
  - `DONE` → queue empty, all merged. Stop the loop; report to chat (no notification).
  - `STALLED <detail>` → nothing eligible (deps blocked) or a merge failed irrecoverably. Stop the loop; report to chat with the detail (no notification — terminal/chat surfaces it).
- **Merge sequence** (on `MERGE`):
  1. Jira → **Done** via Atlassian MCP (`transitionJiraIssue`).
  2. `gh pr merge <n> --rebase --delete-branch`; if branch protection refuses, retry with `--admin` (owner has bypass).
  3. Set task `merged` in JSON, **prune its `runtime`**.
  4. Close the task's tmux window.
  5. Notify (info) the merge.
- **Cadence**: long ticks (default ~20–30 min via `/loop`), since merge approval is a human-paced signal. Don't poll every 30s.
- **Notifications**: only **merge done** and **new task started** (user's choice). `STALLED`/`DONE`/merge-failure stop-and-report in chat, no macOS notification.

### New: `agents/commands/fs-loop-check.sh`
Deterministic guard for `/fs-loop`. All I/O here; emits a one-line verdict so the model spends no tokens on parsing.

- Args: `<epic>`. Reads `specs/epics/<epic>.loop.json`.
- Logic:
  1. If any task `in_progress` → `BUSY <id>`.
  2. If a task is `ready` with a `pr`: check that PR. If **not draft** AND has an owner comment matching the **merge-approval** regex (`lgtm` / `pr approved`, normalized) → `MERGE <id> pr=<n>`; else → `WAIT <id> pr=<n>`. (A draft PR never triggers merge — that's the spec gate.)
  3. Else find the first `pending` whose deps are all `merged` → `NEXT_TASK <id>`.
  4. Else if all tasks `merged` → `DONE`.
  5. Else (pending exist but blocked on non-merged deps) → `STALLED blocked: <ids>`.
- Owner login from `FS_AGENT_LOGIN` (fallback `vmarcosp`), same convention as the existing script. owner/repo resolved dynamically via `gh`.
- The merge-approval regex lives **only** here (the merge channel); the adjustment regex lives only in `fs-pr-listen-check.sh`.

### Change: `agents/commands/fs-pr-listen-check.sh`
Adapt the existing guard to the new vocabulary and the FEEDBACK fix (#9):

- **RESOLVE** (owner `@agent:` adjustments): exclude the merge-approval phrases (`lgtm`/`pr approved`) — those belong to `/fs-loop`, not here. Keep inline-unresolved + general `@agent:` from the owner.
- **FEEDBACK** (third-party): **inline unresolved only**. Drop `general_feedback` (third-party root-conversation comments no longer trigger the watch — edge case; real review comes on the diff). (#9)
- Add **paginated** review-thread fetch (the current `first: 100` / `first: 50` silently drops comments on long PRs). At minimum, log a warning if a page boundary is hit. (#4)
- This script is used **only** while the PR is **ready** (the post-ready adjustment watch). The spec-gate signals (`@agent: spec`/`plan`) on a **draft** PR are handled by `/fs-task` inline (it's a single PR, one root-comment scan — cheap, no guard script needed). So this script never needs the spec vocabulary.

### Rename + rework: `agents/commands/fs-next-task.md` → `agents/commands/fs-task.md`
Rename the file and the skill `name`. Rework the body:

- **Step 0 — Drain Jira (safety net)**: on start, read `.loop.json`; if the most-recent `merged` task hasn't been moved to Jira *Done* yet, move it. (The `/fs-loop` already does this at merge; this is a backstop for manual runs.)
- **Step 1 — Sync**: `git checkout main && git pull --rebase`. Base is **always `main`** (no `feat/<epic>`). Handle a rebase conflict explicitly (stop + notify alert) on top of the existing dirty-tree guard. (#3, plus the rebase-conflict gap)
- **Step 2 — Claim**: Jira → *In Progress*; branch `feat/<lowercase-id>-<slug>` **from `main`**; JSON `status: in_progress`.
- **Step 4 — Spec (fs-planner)**: draft PR opened against **`main`** (not `feat/<epic>`).
- **Step 5 — Spec gate**: notify "comente `@agent: spec` pra liberar". Poll loop. Match approval with the **normalized spec-approval matcher** (`spec`/`plan` approved, pt-BR/en-US, case/accents/order tolerant). Non-approval `@agent:` → `/pr-agent` adjusts the spec. **Explicitly end this poll loop before continuing** (don't leave it auto-rescheduling). (#2)
- **Step 7 — Implement (fs-implementer)**: PR final against **`main`**.
- **Step 9 — Ready**: `/open-pr` → `gh pr edit` → `gh pr ready`; Jira → *In Review*; JSON `status: ready`, `pr: <n>`; Slack + notify (as today).
- **Step 10 — Post-ready (`/fs-pr-listen`)**: stays. Watches the **ready** PR for adjustments only. Ignores `@agent: lgtm`/`pr approved` (the merge channel — `/fs-loop`'s job). When it sees the PR **merged** (by `/fs-loop`), **encerra silenciosamente** (no notification — the loop already notified). (dupla-notif coordination)
- Remove the old step 3 ("move previous task to Done") — Jira Done is now the `/fs-loop`'s job at merge, with the step-0 drain as backstop.
- Remove the old step 12 wording that had `/fs-task` enter `/loop /fs-pr-listen` *as the epic driver* — `/fs-pr-listen` still runs, but as this task's own post-ready watch, not as the queue driver.

### Change: `agents/commands/fs-pr-listen.md`
- Add the **anti-loop counter (#5)**: per comment/thread, track `rounds` in the task's `runtime.comments[<id>]` in `.loop.json`. After **3** re-treatments of the same thread, stop insisting on it (record `skip` reason, notify once), and keep handling the rest of the PR. The watch stays alive until the PR closes/merges.
- Confirm it **ignores** the merge-approval phrases (delegates merge to `/fs-loop`).
- On seeing the PR merged → exit **silently**.

### Change: `agents/agents/fs-planner.md`
- Draft PR base: `main` (was "the epic's base branch `feat/<epic>`").

### Change: `agents/rules/spec-implement-flow.md`
- Base branch is `main` everywhere (drop the `feat/<epic>` aggregating-branch language).

## Open items folded in from the earlier review

- **#2** spec-gate: normalized approval matcher + explicit loop termination. ✅ (fs-task step 5)
- **#3** base always `main`, no `feat/<epic>`. ✅ (fs-task, fs-planner, rule)
- **#5** anti-loop counter (3 per comment), persisted in `runtime` in `.loop.json`. ✅ (fs-pr-listen)
- **#9** FEEDBACK inline-unresolved only; drop third-party general comments. ✅ (fs-pr-listen-check.sh)
- **#4** paginate the review-thread fetch (or warn at the boundary). ✅ (fs-pr-listen-check.sh)
- (Jira rollback / #1 — dropped per your call.)

## Adversarial review (self-check before implementing)

1. **Two watchers on one PR.** `/fs-loop` (merge channel) and `/fs-task`/`/fs-pr-listen` (adjustment channel) both read the same ready PR. Disjoint by regex: merge phrases only in `fs-loop-check.sh`, adjustment phrases only in `fs-pr-listen-check.sh`. No overlap → no double-handling. ✅
2. **Approval phrase collision (spec vs. merge).** Both are "approved". Disambiguated by PR draft/ready state, enforced in the guards (`fs-loop-check.sh` requires non-draft). ✅
3. **Last task's Jira Done.** `/fs-loop` moves Jira at merge — covers *every* task including the last, because the conductor merges them all. No "next run drains it" gap. ✅
4. **`runtime` inflation.** Pruned at merge; only the single live task carries it. ✅
5. **Optimistic deps.** `/fs-task` elects on deps `merged`, not `ready` — never builds on un-merged code. One task at a time also means no two PRs in flight. ✅
6. **Loop dying silently.** `STALLED`/`DONE`/merge-failure stop-and-report in chat. (You opted out of macOS notifications for these; they still surface in the loop's terminal output.) ✅
7. **Contract: who writes which status (race-free).** A naive "`/fs-task` writes `in_progress` on claim" loses a race: between `/fs-loop` opening the window and `/fs-task` booting + claiming, the next tick still sees `pending` and re-opens the task. Fix: **`/fs-loop` writes `in_progress` itself, atomically, *before* opening the window** (the conductor owns queue advancement). **`/fs-task` writes `ready` + `pr`** at `gh pr ready`. **`/fs-loop` writes `merged`** at merge (and prunes runtime). So: conductor owns `pending→in_progress` and `ready→merged`; `/fs-task` owns `in_progress→ready`. No field has two writers. `fs-loop-check.sh` only reads. A `/fs-task` run started **standalone** (no conductor) self-claims `in_progress` if it's still `pending` — the conductor's write is the fast path, the self-claim is the fallback.
8. **tmux window already exists / stale.** Reuse vedutta's guard: if a window for the task exists, kill the stale one before opening (the conductor owns window lifecycle, scoped to its own session).
9. **`/fs-task` run standalone (no `/fs-loop`).** Still works: it self-claims, opens PR, and its `/fs-pr-listen` watch runs. Merge is then manual (or a later `/fs-loop`). The step-0 Jira drain is the backstop. ✅

## Implementation order

1. `json-from-epic` skill + `parse-epic.sh` — produces the control file the rest depends on.
2. `fs-loop-check.sh` — deterministic verdict (testable standalone against a sample `.loop.json`).
3. `fs-loop.md` — the conductor consuming the verdict.
4. `fs-pr-listen-check.sh` edits (#9, #4, exclude merge phrases).
5. `fs-task.md` (rename + rework) and `fs-pr-listen.md` (#5, silent exit).
6. `fs-planner.md` + `spec-implement-flow.md` base→`main`.
7. Smoke each script standalone with a hand-written sample `.loop.json` before wiring the commands together.

## Verification

- `parse-epic.sh` against the real `generate-store.md` → correct `id`/`deps` for all 7 tasks (incl. `FSPG-770 depends_on: [FSPG-766]`).
- `json-from-epic` re-run on an existing file → preserves a hand-set `merged`/`ready` status, adds a synthetic new task.
- `fs-loop-check.sh` against sample files exercising each verdict: BUSY, WAIT, MERGE (ready+approved), MERGE-blocked-by-draft (→WAIT), NEXT_TASK, DONE, STALLED.
- Regex unit checks: merge matcher accepts `lgtm`/`pr approved`/`aprovado`, rejects `spec`/`plan`; spec matcher the inverse.
- `fs-pr-listen-check.sh`: FEEDBACK returns inline-unresolved only; third-party general comment does not trigger.
