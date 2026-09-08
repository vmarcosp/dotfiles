# {Change Title}

> **Status**: {Draft | Done}
> **Last updated**: {date}

## Goal

{One sentence: what's different once this ships.}

## Success Criteria

{3–6 verifiable statements: what must be true when this ships, each traced to the section that demands it. Every criterion is covered by at least one Step and exercised in Verification.}

| # | Criterion | Traces to |
|---|---|---|
| C1 | {Observable outcome, checkable} | {doc, heading path — or roadmap phase Source} |

## Recon

{Findings grounded in files/commands actually inspected — not assumptions.}

| Area | Finding |
|---|---|
| {File / module / test} | {What exists today, relevant constraint or pattern to match} |

## Approach

{Short paragraph: the chosen technical approach. A rejected alternative gets one sentence only if it explains a non-obvious Step below.}

## Steps

{Ordered, each one small enough to fail independently and to verify before the next depends on it.}

1. **{Step title}** — {what changes, in which file(s)}.
   **Verify:** {exact test/command/manual check that proves this step is done}
2. **{Step title}** — {what changes, in which file(s)}.
   **Verify:** {exact test/command/manual check that proves this step is done}

## Verification

{How the whole change is confirmed done end-to-end, beyond the per-Step checks: one check per success criterion, plus the full test suite.}

- **C1** — {exact test/command/manual walkthrough that exercises this criterion}

## Risks & Open Questions

{What could break, or a genuinely unresolved decision — omit this section if there are none.}

## References

{Docs this plan depends on — linked, not restated. ADRs are binding constraints on the Approach; PRDs/TDDs are context only. Omit if none.}

| Doc | Type | Why it matters here |
|---|---|---|
| {adr-NNNN, linked} | Binding (ADR) | {The specific constraint the Approach complies with} |
| {prd-slug / tdd-slug, linked} | Reference | {What this plan takes from it} |
| {roadmap, linked} | Roadmap (Phase #{N}) | {Required when this change is a roadmap phase — /implement reads the phase number and carry-over path from here} |
