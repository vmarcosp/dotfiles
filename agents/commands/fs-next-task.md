---
description: Picks up the next task from an epic and runs it solo - research, spec, implement, smoke, self-review, takes the PR to ready, and enters the /fs-pr-listen watch. Fires pre-created subagents (fs-researcher → fs-planner → fs-implementer → fs-tester → fs-reviewer).
---

You'll run **one** task from an epic, from start to PR ready, without stopping for me partway - except when you're missing a clarification or hit a human gate, where you **notify** me (skill `/notification`) and wait.

The epic lives at `specs/epics/<epic>.md` (the format the `/epic` skill produces) and its aggregating feature branch is `feat/<epic>`. Resolve `<epic>` from the argument if I gave one; otherwise from the single epic under `specs/epics/`.

Context principle: each heavy stage (research, spec, implement, smoke, review) runs in a **pre-created subagent** (Agent tool, its own `subagent_type`). The main window only orchestrates and holds the summaries the subagents return. Don't do research or read code in bulk in the main window.

`$ARGUMENTS` is optional. It may carry the epic name, a task ID, or both (e.g. `generate-store FSPG-766`). A task ID means run that task; an epic name picks the epic; with neither, use the single epic under `specs/epics/` and find the next task yourself.

## 0. Context guard

Confirm an epic exists at `specs/epics/<epic>.md` in the current directory. If none does, **stop** and tell me the flow needs to run inside a project (or worktree) that has an epic - don't proceed.

## 1. Sync the feature branch

```
git checkout feat/<epic>
git pull --rebase
```

If there are uncommitted local changes, stop and warn me via `/notification` (tone `alert`) - don't proceed over unsaved work.

## 2. Find the next task

Read `specs/epics/<epic>.md`. In its task section (a stream heading like `### Stream A`), each line is a task with a checkbox, ID, title, spec path, and `depends_on`. If the epic has more than one stream, work the first one with an eligible task.

The **next task** is the first `- [ ]` line (unchecked) whose `depends_on` are **all** marked `- [x]`. If an argument was passed, use that ID instead of discovering one.

If there's no eligible task (all done, or the next one is blocked by an open dependency), stop and tell me the state - what's blocking what.

Read the full block for that task in the epic (`## FSPG-XXX. ...` up to the next `---`). That block is the contract: objective, scope (In/Out), BDD, acceptance criteria, definition of done. Hold on to it - you'll pass it to the subagents.

## 3. Move tasks in Jira

Via the Jira MCP (Atlassian):
- If there's a previous task (the last one that was `- [x]` in the epic before the current one), move it to **Done**: `transitionJiraIssue` with its ID and the `Done` transition.
- Move the current task to **In Progress**: `transitionJiraIssue` with its ID and the `In Progress` transition.

## 4. Create the task branch

From `feat/<epic>`, create:

```
git checkout -b feat/<lowercase-id>-<short-slug>
```

E.g. `feat/fspg-766-grounded-eval`. The slug comes from the task title.

## 5. Research (subagent fs-researcher)

Fire the **`fs-researcher`** subagent (Agent tool, `subagent_type: "fs-researcher"`). It already comes with its own model/effort. Give it:
- the task block from the epic (paste the text)
- the task's spec path and any design docs it references (RFCs, ADRs, TDDs, or other design docs under `docs/`)

It returns a concise summary: relevant files/symbols, conventions, what's **Out**, and risks. **Hold on to the summary** - don't re-read the code in the main window.

## 6. Spec (subagent fs-planner)

Fire the **`fs-planner`** subagent (`subagent_type: "fs-planner"`). Pass the research summary plus the task block. It runs `/specification` and produces `specs/<id>.md` covering each acceptance criterion and BDD/NFR, records explicit assumptions, and opens the **draft PR** against `feat/<epic>` per the spec-implement-flow rule.

Act on what it returns:
- **spec ready + draft PR** → hold on to the spec path, the PR URL, and the list of assumptions. Continue.
- **awaiting clarification** → it already notified me. Stop and report the open question to me.
- **blocked** (conflicting dependency, scope that contradicts the epic) → it already notified me. Stop and report to me.

## 6.5. Spec gate (wait for approval)

Run the `/notification` skill:
- title: `fs-planner ✅`
- tone: `info`
- message: `Spec pronta. Revise via @agent: no PR e comente "@agent: Spec Aprovada" na raiz quando quiser seguir. PR: <url>`

Then enter a polling loop (`/loop 15m`) that checks the PR's root comments on every tick:
- For each root comment containing `@agent:` that is **not** the approval phrase, route it through `/pr-agent` so the spec gets adjusted.
- When you see a root comment from the PR owner containing exactly **`@agent: Spec Aprovada`**, exit the loop and continue to step 7.
- If the PR is closed or the branch is merged before approval, stop and report to me.

Do **not** proceed to implement until you receive the approval comment.

## 7. Implement (subagent fs-implementer)

Fire the **`fs-implementer`** subagent (`subagent_type: "fs-implementer"`). Pass the spec (`specs/<id>.md`) plus the task block. It runs `/implementing`: follows the styleguide, writes the tests (each acceptance criterion + BDD/NFR), doesn't touch what's **Out**, leaves `pnpm lint`/`test`/`typecheck` green, and updates the existing PR to **ready** with the full body (Summary, Tests, Assumptions, Deviations, Follow-ups, spec link).

If it gets stuck after 3 attempts, it already notified me. **Stop** here and report the error to me; don't move on to the smoke.

## 8. Real smoke (subagent fs-tester)

Before the review, prove the thing **actually runs**. Fire the **`fs-tester`** subagent (`subagent_type: "fs-tester"`). Pass the task ID, the epic block (acceptance criteria), and the summary of what was implemented.

It works against a rubric (the thing runs for real and produces its actual artifact, not just a green suite) and discovers *how* to test from the project's test tooling, its fixtures, or the spec and diff. It has its own autofix loop (cap 3). For tasks with no executable behavior, it does just the light smoke of the artifact.

Act on the verdict:
- **passed** → move on to the review.
- **skip (infra reason)** → the smoke failed for a reason outside the task. Record the reason in the PR body as a smoke skip and move on to the review.
- **failed after 3 attempts** → it already notified me. **Stop** here and report the error to me; don't take the PR to ready on something that doesn't run.

## 9. Self-review (subagent fs-reviewer)

Fire the **`fs-reviewer`** subagent (`subagent_type: "fs-reviewer"`). It runs `/self-review` (Layer 1: reviews the diff for correctness, adherence to the spec/epic, and basic security; iterates until clean, cap 3; posts the findings table on the PR). Let it finish - its loop is internal.

If the cap of 3 iterations was hit with 🔴 Important still open, report it to me (the table on the PR flags this).

## 10. Move task to In Review in Jira

Via the Jira MCP: move the current task to **In Review** (`transitionJiraIssue` with the ID and the `In Review` transition).

## 11. Notify

Slack message via MCP (`slack_send_message`) to `#fs-mission-team`. Pick one of the three variations below (rotate — don't always use the first):
```
PR pronto pra review: <PR url>
```
```
Alguém consegue dar uma olhada nesse PR? <PR url>
```
```
Novo PR aberto, precisa de review: <PR url>
```

Then run the `/notification` skill:
- title: `fs-next-task ✅`
- message: `PR ready for review: <ID>. Test it, comment @agent: if you need to, approve, and merge into feat/<epic>.`

Tell me the PR number and a one-line summary of what's ready. **Don't merge** - that stays mine (review, test, approve, merge).

## 12. Enter the PR watch

After notifying, **don't stop** - go straight into the PR watch in this same session:

```
/loop 15m /fs-pr-listen
```

`/fs-pr-listen` watches the open PR for the current branch every 15 minutes and routes the comments: `@agent:` from the owner → `/pr-agent`; third-party comments → `/pr-feedback` (interactive Gate 1). The loop stops when the PR is merged or closed. After the merge, the next task is mine: run `/fs-next-task` again in a new session.
