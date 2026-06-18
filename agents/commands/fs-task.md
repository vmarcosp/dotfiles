---
description: Runs ONE epic task end to end on its own branch and PR - research, spec, spec-gate, implement, smoke, self-review, takes the PR to ready, then watches the PR for adjustments until it's merged. Owns the whole PR lifecycle of a single task. Fired by /fs-loop (one window per task) or run standalone.
---

You run **one** task from an epic, from start to a ready PR, and then you own that PR's lifecycle until it merges — without stopping for me partway, except when you're missing a clarification or hit a human gate, where you **notify** me (skill `/notification`) and wait.

You may be fired by `/fs-loop` (which opened a tmux window for you and claimed the task) or run standalone. Either way you behave the same.

The epic lives at `specs/epics/<epic>.md` (the `/epic` format) and its control file at `specs/epics/<epic>.loop.json` (the `/json-from-epic` format). Everything branches from and targets **`main`** — there is no aggregating feature branch.

Resolve `<epic>` and the task `<id>` from `$ARGUMENTS` (e.g. `generate-store FSPG-766`). A task ID means run that task; with no ID, find the next eligible one yourself (first `pending` in the control file whose `deps` are all `merged`).

Context principle: each heavy stage (research, spec, implement, smoke, review) runs in a **pre-created subagent** (Agent tool, its own `subagent_type`). The main window only orchestrates and holds the summaries the subagents return.

## 0. Context guard + resume check + drain Jira

Confirm `specs/epics/<epic>.md` and `specs/epics/<epic>.loop.json` exist in the current repo. If not, **stop** — tell me to run inside a project with an epic and to run `/json-from-epic <epic>` first.

**Resume check (you may be a relaunch).** `/fs-loop` reopens you if your previous session died mid-task, so don't assume a clean start. Before doing anything destructive, look at what already exists for this task and **pick up from there** — never redo a step whose artifact is already present:
- **Task branch `feat/<id>-<slug>` already exists** (local or remote)? → check it out instead of creating it (step 2's `git checkout -b` would fail). 
- **A spec `specs/<id>.md` already exists**? → skip the research+spec stages (3–4); the spec is done.
- **A PR already exists for the branch** (`gh pr view`)? → it's either still **draft** (resume at the spec gate, step 5) or **ready** (resume at the post-ready watch, step 10). Don't open a second PR.
- **No branch / no PR yet**? → fresh start, proceed normally from step 1.

Resolve the resume point from those artifacts, jump to the right step, and continue. The control file's `status` is a hint (`in_progress` = mid-flight, `ready` = PR is up), but the git/PR artifacts are the ground truth.

**Drain Jira (safety net).** Read the control file. If the most-recently-`merged` task hasn't been moved to **Done** in Jira yet, move it now (`transitionJiraIssue`, Done transition). The `/fs-loop` already does this at merge; this is the backstop for standalone runs. (Skip if there's no merged task, or you can't tell whether it was already moved — don't double-transition.)

## 1. Sync `main`

```
git checkout main && git pull --rebase
```

- Uncommitted local changes → stop and warn me via `/notification` (title `fs-task`, message `Mudanças locais não commitadas detectadas. Resolva antes de continuar.`, tone `alert`). Don't proceed over unsaved work.
- A **rebase conflict** → stop and notify via `/notification` (title `fs-task`, message `Conflito de rebase detectado. Resolva manualmente.`, tone `alert`) with the conflicting paths. Don't try to resolve it blind.

## 2. Find the task, claim it

Read the task's block in `specs/epics/<epic>.md` (`## <id>. ...` up to the next `---`): objective, scope (In/Out), source, touchpoints, notes for the spec. That block is the task's brief — the seed the spec will expand, not the full contract; hold it for the subagents. The acceptance criteria, BDD/NFR, and Definition of Done are authored by the spec (step 4), not the epic.

Then claim:
- **Jira** → move `<id>` to **In Progress** (`transitionJiraIssue`).
- **Branch** from `main`: `git checkout -b feat/<lowercase-id>-<short-slug>` (e.g. `feat/fspg-766-grounded-eval`).
- **Control file**: **standalone only** — if the task is still `pending`, set its `status` to `in_progress` (the self-claim fallback). When `/fs-loop` fired you, it already wrote `in_progress` before opening your window, so this is a no-op. Either way, never write `ready`/`merged` here — those come later (step 9) / from `/fs-loop`.

## 3. Research (subagent fs-researcher)

Fire **`fs-researcher`** (`subagent_type: "fs-researcher"`). Give it the task block and the task's spec path plus any design docs it references. It returns a concise summary: relevant files/symbols, conventions, what's **Out**, risks. Hold the summary; don't re-read the code in the main window.

## 4. Spec (subagent fs-planner)

Fire **`fs-planner`** (`subagent_type: "fs-planner"`). Pass the research summary + the task block. It runs `/specification`, produces `specs/<id>.md` that authors the full breakdown from the seed and its **Source** — problem, user stories, functional/non-functional requirements, acceptance criteria, BDD/NFR scenarios, technical contract, test plan, and Definition of Done — records explicit assumptions, and opens the **draft PR against `main`** per the spec-implement-flow rule.

Act on what it returns:
- **spec ready + draft PR** → hold the spec path, the PR URL, and the assumptions. Continue.
- **awaiting clarification** → it notified me. Stop and report the open question.
- **blocked** → it notified me. Stop and report.

## 5. Spec gate (PR is in DRAFT — wait for approval)

Run `/notification` (title `fs-task · spec`, message `Spec pronta no PR <url>. Comente @agent: spec approved (ou @agent: plan approved) na raiz pra liberar a implementação; outros @agent: ajustam a spec.`, tone `info`).

Then poll the PR's **root comments** (`/loop 15m`, or whatever interval). On each tick:
- For each root comment from me containing `@agent:`, match it with the **spec-approval matcher** — explicit, two accepted forms only (case/spacing tolerant):
  - `@agent: spec approved`
  - `@agent: plan approved`

  The matching regex (case-insensitive): `^@agent:[[:space:]]*(spec|plan)[[:space:]]+approved`. A bare `@agent: approved` does **not** count (avoids any overlap with the merge channel's `lgtm`/`pr approved`).
- Any **other** `@agent:` comment (including a bare `@agent: approved`) → route it through `/pr-agent` so the spec gets adjusted; keep looping.
- On approval → delete the comment immediately so `/fs-pr-listen` never sees it as a pending adjustment:
  ```bash
  REPO=$(gh repo view --json owner,name -q '.owner.login + "/" + .name')
  gh api "repos/$REPO/issues/comments/<comment-id>" --method DELETE
  ```
  (Use the `.id` from the guard script's JSON output — delete only the matched approval comment.)
  Then **stop and exit this `/loop` cleanly — do not reschedule** (the spec-gate poll must be fully terminated before step 10's post-ready watch starts; the two `/loop`s never overlap). Continue to step 6.
- PR closed before approval → stop and report.

Don't implement until you see the approval comment.

## 6. Implement (subagent fs-implementer)

Fire **`fs-implementer`** (`subagent_type: "fs-implementer"`). Pass `specs/<id>.md` + the task block. It runs `/implementing`: follows the styleguide, writes tests (each acceptance criterion + BDD/NFR in the spec), doesn't touch what's **Out**, covers error branches, leaves `pnpm lint`/`test`/`typecheck` green. PR stays against `main`.

If it's stuck after 3 attempts, it notified me. **Stop** and report; don't smoke.

## 7. Real smoke (subagent fs-tester)

Fire **`fs-tester`** (`subagent_type: "fs-tester"`). Pass the task ID, the spec's acceptance criteria (`specs/<id>.md`), and the implementation summary. It proves the thing actually runs and produces its real artifact (rubric-based), with its own autofix loop (cap 3).

Act on the verdict:
- **passed** → review.
- **skip (infra reason)** → record the skip reason in the PR body, move to review.
- **failed after 3 attempts** → it notified me. **Stop** and report; don't take the PR to ready on something that doesn't run.

## 8. Self-review (subagent fs-reviewer)

Fire **`fs-reviewer`** (`subagent_type: "fs-reviewer"`). It runs `/self-review` (cap 3, posts the findings table on the PR). Let its loop finish. If the cap was hit with 🔴 still open, report it to me (the table flags it).

## 9. Ready

- Generate the final PR title and body yourself (don't call `/open-pr` — that skill runs `gh pr create` and would open a duplicate). Title: `type(scope): short description - <JIRA_ID>`. Body: Summary, Tests, Assumptions, Deviations, Follow-ups, spec link. Update the existing PR via the REST API (avoids the classic-Projects GraphQL deprecation warning that makes `gh pr edit` silently fail):
  ```bash
  REPO=$(gh repo view --json owner,name -q '"repos/" + .owner.login + "/" + .name')
  PR_NUMBER=$(gh pr view --json number -q '.number')
  gh api "$REPO/pulls/$PR_NUMBER" --method PATCH --field title="$TITLE" --field body="$BODY" -q '.title'
  ```
  Mark ready: `gh pr ready`.
- Update the spec status to `Done`.
- **Jira** → move `<id>` to **In Review**.
- **Control file**: set the task's `status` to `ready` and `pr` to the PR number. (You own the `in_progress → ready` write; `/fs-loop` reads this to know the task is up for merge.)
- **Slack** to `#fs-mission-team` (rotate, don't always use the first):
  ```
  PR pronto pra review: <url>
  ```
  ```
  Alguém consegue dar uma olhada nesse PR? <url>
  ```
  ```
  Novo PR aberto, precisa de review: <url>
  ```
- `/notification` (title `fs-task ✅`, message `PR pronto pra review: <id>. Comente @agent: pra ajustar, @agent: lgtm (ou @agent: pr approved) pra eu mergear.`, tone `info`).

Tell me the PR number and a one-line summary. **Don't merge** — that's `/fs-loop`'s job (it watches for `@agent: lgtm` / `pr approved`).

## 10. Post-ready watch (own the PR until it merges)

Go straight into the PR watch in this same session — this is your task's lifecycle, not the epic's:

```
/loop 15m /fs-pr-listen
```

`/fs-pr-listen` watches **this** PR for adjustments: `@agent:` comments from me that aren't merge approval (→ `/pr-agent`), and third-party inline reviews (→ `/pr-feedback`), in a plan round (notify + wait for my ok) then an apply round. It **ignores** `@agent: lgtm` / `pr approved` — merge is `/fs-loop`'s channel. When it sees this PR **merged** (by `/fs-loop`), it **exits silently** — `/fs-loop` already notified the merge, so don't notify again. The loop also stops if the PR is closed unmerged (report that).

After the merge your task is done. If standalone (no `/fs-loop`), I merge manually; the next task is a fresh `/fs-task` run.
