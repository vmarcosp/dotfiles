# {Scope Name} — Roadmap

> **Status**: {Draft | Active | Done}
> **Last updated**: {date}

## Goal

{One sentence, from the PRD: what the finished scope delivers.}

## Phases

| # | Phase | Goal (one sentence) | Depends on | Status |
|---|---|---|---|---|
| 1 | {Title} | {What changes when this ships} | {— or #N, #M} | {Pending \| Spec'd \| Done} |

## Dependency Graph

```mermaid
flowchart LR
    1[Phase 1] --> 2[Phase 2]
    1 --> 4[Phase 4]
```

## Streams

- **Critical path**: {N} phases ({#1 → #2 → #3})
- **Max parallelism**: {N} (widest wave: {#4, #5})

| Stream | Phases, in order |
|---|---|
| A | {#1, #2, #3} |
| B | {#4} |

## Carry-over Log

{Entries absorbed from phase fragments during Sync — omit until the first Sync.}

| Type | From | Affects | Note | Link |
|---|---|---|---|---|
| {Fact \| Dependency correction \| New scope} | {#N} | {#M / roadmap} | {one line} | {PR/commit} |

## Carry-over Paths (reserved)

{Where each phase's `/implement` writes its fragment — reserved, not yet written. Lives alongside this doc, same folder.}

| Phase | Path |
|---|---|
| #1 | `carryover-phase-1.md` |

## References

| Doc | Type | Why it matters here |
|---|---|---|
| {prd-slug, linked} | Reference | {What this roadmap took from it} |
| {tdd-slug, linked} | Reference | {Building Blocks used to cut phases} |
| {adr-NNNN, linked} | Binding | {Constraint that forced an order or a split} |

## Open Questions

{Genuinely unresolved — omit if none.}
