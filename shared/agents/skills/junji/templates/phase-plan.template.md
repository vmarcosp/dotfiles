# Phase NN — <title>

Status: see this phase's heading in `BACKLOG.md` (source of truth; do not mirror tags here).

> **How-to contract** for one slice: not an essay, not a tutorial. Write it in step 3 of `next`
> (skip if the file already exists), or during `iterate` before `next`/yokai runs. Fill **Outcome** in
> `next` step 6. When the driver runs Plan → Build → Seal, this plan is the **spec** the self-correction
> loop converges against (Plan is skipped when this file is already on disk). **Explicitly out** is the
> scope guard.

## Outcome

_(filled on completion: one paragraph: what shipped, the key findings, and the gate result. When this
phase runs unattended, make this self-contained: the next window may read only this.)_

## Goal & scope

**In scope:** <the specific slice this phase delivers>.

**Explicitly out:** <what this phase deliberately does NOT do — the list that stops scope creep. Push
adjacent ideas here as follow-ups instead of doing them.>

## Port from / change

<Exact source files + line refs to read and mirror. Be specific — this is the phase-research target.>

## Approach

Numbered recipe: one bounded action per step:

1. <Read / mirror which files>
2. <Change to make>
3. <Test that proves this slice>

## Risks & mitigations

- **<risk>** → <mitigation>.

## Tests & parity gate

<Which parts of CONTEXT › Verification bar prove this phase — which tiers, which fixtures/corpus entries.
What "passing" concretely means for this slice.>

## Acceptance checklist

- [ ] <maps 1:1 to a verification-bar command or a concrete deliverable>
- [ ] Full verification bar exits 0 (language gates + repo gates).
- [ ] Backlog compacted (this phase `[done]`; carry-forward updated); committed per standing overrides.
