# Phase assessment

Assess execution difficulty and useful parallelism, not duration or priority.
Read BACKLOG phase scope, dependencies, CONTEXT's verification bar, relevant plans
and repository code. Use phase IDs as keys. Existing assignments are user choices:
retain them unless a concrete scope change justifies a reviewed revision.

## Weight: tier

- `low`: mechanical, locally specified changes with established patterns and clear checks.
- `medium`: a bounded implementation requiring ordinary design and debugging.
- `high`: cross-module changes, subtle invariants, substantial uncertainty or difficult validation.
- `ultra`: the hardest unsplittable reasoning task; explain why high is insufficient.

Do not infer difficulty from file count, title length or a desire to use the most
expensive model. State a short concrete reason tied to the phase. Suggest splitting
oversized work to the user; assessment does not rewrite the Junji backlog.

## Mode: strategy

Default `plain`. Select `swarm` only when the phase contains independently mergeable
items, with separable file ownership and the same verification bar. Shared mutable
state, tightly coupled design, sequential dependencies or integration-heavy work
favor plain. Global `swarm.enabled` must also be true and token savings off to run
workers; explain when a proposed swarm would currently execute as plain.

## Output and review

Keep runtime choices outside Markdown:

```yaml
# .koi/run/yokai.yml — preserve all unrelated overrides
phases:
  P2:
    tier: high
    strategy: plain
    reason: Changes shared session lifetime and recovery invariants.
```

Assess unfinished phases only, including human-gated phases without approving them.
Never create IDs absent from BACKLOG. Report orphaned mapping entries for explicit
cleanup; do not silently reassign them to another phase after renumbering.
Show the mapping for review before saving. After human approval through this skill,
save tier, strategy and reason; the YAML mapping is authoritative. Do not create
`reviewed_sha256` fields or send the user through another CLI approval step.
Existing legacy fingerprints are ignored by Yokai. Reconsider choices when scope
changes justify revisions, preserving existing choices otherwise. Headless execution
accepts complete mappings and stops on missing or incomplete entries, not receipt
or scope-hash mismatches. Never treat assessment as approval to run gated work.

Junji remains independent of these settings. Do not add tier/strategy tags to
headings or phase plans. Assessment neither approves gated actions nor edits
verification criteria.
