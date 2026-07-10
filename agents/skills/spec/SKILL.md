---
name: spec
description: >-
  Writes or updates an implementation plan — a concise, actionable
  breakdown of how one change will be made: what recon (and any binding
  ADRs) found, the chosen approach, an ordered list of steps, and how
  each step (and the change as a whole) is verified done. Scoped to a
  single change, not a system (that's a TDD) and not user-facing behavior
  (that's a PRD) — the plan is the handoff artifact between deciding what
  to build and building it. Use when the user wants an implementation
  plan, asks to plan a feature, bugfix, or refactor before coding it, or
  invokes /spec.
disable-model-invocation: true
license: MIT
metadata:
  author: Marcos Oliveira
  version: "1.1.0"
---

# Spec — Implementation Plan

Turns a change — feature, bugfix, or refactor — into an ordered list of Steps, each grounded in recon and each carrying its own Verify: the check that proves the step is actually done. The plan is deliberately scoped to one change, not a system or a product surface, and it stays actionable rather than descriptive — closer to what a coding agent hands off before executing than to a design document. Invoke explicitly with /spec.

## When NOT to apply

- The ask is about **what users experience**, not how the change is built — that's a PRD.
- The ask is about **how a whole system fits together**, beyond this one change — that's a TDD.
- The ask is about **justifying one already-settled technical decision** — that's an ADR.
- The change is **trivial and unambiguous** (one file, no real decision to record) — just make it, planning adds no value.

## Step 1: Frame the change

State the change in one sentence: what's different once it ships. Name the boundary — which repo, which part of the codebase — so recon in Step 2 knows where to look. If either is unclear, ask via the AskQuestion tool — don't infer a boundary or a goal you're not confident about.

**Completion criterion:** the change and its boundary are stated in one sentence each, either from the user directly or confirmed by them after asking.

## Step 2: Recon

Read the actual code relevant to the change — the files, functions, tests, and conventions it will touch or must match. Every finding that shapes the Approach or the Steps must trace to a file you actually opened; don't guess at existing behavior.

**Completion criterion:** every finding you're about to rely on has a file or command behind it.

## Step 3: Gather anchor docs

Search the repo for ADRs, PRDs, and TDDs that touch this change's boundary — ADRs in `docs/adrs/`, `docs/adr/`, or `decisions/`; PRDs in `docs/prds/`, `docs/prd/`, or `prds/`; TDDs in `docs/tdds/`, `docs/tdd/`, `docs/design/`, `docs/designs/`, or `docs/architecture/`. Read anything relevant in full — these are inputs, not content to duplicate.

The two kinds carry different weight:

- **ADR — binding.** Its decision is a contract on the Approach, not a suggestion. If the change would contradict an Accepted ADR, that's a conflict: surface it now, and ask the user explicitly via AskQuestion how to resolve it (amend the approach, or flag that the ADR itself needs revisiting) — never quietly work around it and never quietly follow it without telling the user the tension exists.
- **PRD / TDD — reference.** They inform the Goal and Recon (intended behavior, current architecture) but don't constrain the Approach the way an ADR does.

**Completion criterion:** every ADR touching this boundary is either satisfied by the Approach or flagged as a conflict the user has resolved; PRDs/TDDs found are noted as context.

## Step 4: Decide the approach

Pick the technical approach in a short paragraph. It must comply with every ADR from Step 3 — if compliance is impossible, that conflict should already be resolved with the user, not decided here unilaterally. Mention a rejected alternative only if it explains a non-obvious choice in the Steps that follow — one line, not a pros/cons table; the plan states the decision, it doesn't build a case for it.

**Completion criterion:** the approach is stated, complies with every binding ADR (or documents why it can't, per Step 3), and any surviving trade-off is one sentence, not a debate.

## Step 5: Pick the output location

Search the repo for an existing plan directory, in order: `docs/plans/`, `docs/plan/`, `plans/`, `docs/tasks/`.

- **Found** → use it.
- **Not found** → propose `docs/plans/` as the default location, and use the AskQuestion tool so the user can confirm it or name a different path. Do not create any file or directory before they answer.

Filename: `plan-<change-slug>.md`, kebab-case.

Check for an existing plan at that path first — a change gets one plan, not several. If found, read it fully and update in place; note what changed in the final summary.

**Completion criterion:** a confirmed directory path that exists on disk, and known whether this is a create or an update.

## Step 6: Write the Steps

Break the approach into an ordered list. Each Step:

- Names the file(s) or area it touches and what changes there — concrete enough that whoever executes it doesn't have to re-derive the approach.
- Ends on a **Verify** line: the exact test, command, or manual check that turns "I think this is done" into "this is done." A Step without a Verify that can actually be run is not finished — sharpen it or split it.
- Is small enough to fail independently — if a Step's Verify can't isolate what broke, split it.

Order Steps so each one can be verified before the next depends on it — no forward references to a Step not yet done.

**Completion criterion:** every Step has a concrete target and a Verify that names a real, runnable check.

## Step 7: Write the document

Follow `references/template.md` structure exactly.

Writing rules:

- **Concrete over descriptive.** "Add a `retries` field to `Config` in `config.go`, default 3" not "improve configuration handling."
- **No persuasion.** State the approach and the Steps, don't sell them — the case for a decision, if it needed one, lives in an ADR this plan may link to.
- **Short sentences, no filler.** If a sentence doesn't change what gets built or how it's checked, cut it.

## Step 8: Save and present

Save the file, then summarize:

- Path written (or updated), and what changed if updating.
- Number of Steps and what each Verify checks, at a glance.
- ADRs found and how the Approach complies with each; PRDs/TDDs used as reference.
- Anything left under Open Questions, and why.

There's no separate approval step here — running `/implement` against this plan is itself the go-ahead.

## Lifecycle

| Status | Meaning | Trigger |
|---|---|---|
| `Draft` | Written, still being refined | Plan generated |
| `Done` | Every Step verified done | /implement completes |

## Rules

1. Every Step ends on a Verify that names a real, runnable check — no Step ships without one.
2. One plan per change — update in place, don't duplicate.
3. Ground every recon finding in a file or command actually inspected — never assume existing behavior.
4. An ADR is a contract — the Approach complies with every one found, or the conflict was resolved with the user, never silently.
5. Ask explicitly via AskQuestion whenever a required piece — the Goal, the boundary, the Approach, an ADR conflict, a Step's Verify — can't be filled with confidence. Open Questions is for what's still unresolved after asking, not a substitute for asking.
6. Write in the same language the user uses.
