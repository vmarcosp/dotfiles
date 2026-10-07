# Chat contract and document types

## Status

Accepted

## Context

Junji told the human too much and mixed purposes in the files it wrote. Chat opened with preamble,
recapped work the reader had just watched, and buried the next action. Working-folder markdown mixed
rationale into CONTEXT, execution recipes into PLAN, and essay into the phase-plan Approach. Two
external skills named the gap: action-first unbloated chat, and one purpose per document
(explanation / how-to / reference). The method already had the PLAN/CONTEXT split; it did not enforce
it, and it had no chat contract.

## Decision

1. **Chat contract** — SSOT `references/chat.md`. Always-on summary in `SKILL.md › Chat`. `next`
   windows that only read METHOD follow its **Report** subsection (same contract). Lead with
   position + next action; number steps; show the win; tangents last; errors are cause + fix; no
   preamble/recap/pleasantries; time estimates only when a human is waiting. Grill stays
   whole-frontier; if a round would exceed ~5 questions, ask ADR-worthy ones first (hard to reverse,
   surprising, real trade-off). Overrides: full explain when asked; confirm destructive work; halt on
   a red gate; harness wins; do not collapse grill to one question.
2. **Document types** — SSOT `references/docs.md`. Types are **fixed by the method**, not negotiated
   per project. PLAN = explanation; CONTEXT / BACKLOG / DESIGN / notes = reference; METHOD and
   the phase plan = how-to; consolidate follows the host outline (narrative default = explanation +
   locked facts, not a changelog). No tutorials. No outline-approval step — grill already settles
   content. CONTEXT locked decisions are **fact-only**; rationale stays in PLAN. Phase-plan Approach
   is a numbered recipe; the file stays a contract, not a tutorial.
3. **Progressive disclosure** — `references/` gains `chat.md` and `docs.md` beside
   `autonomous-driver.md`. They are writing SSOTs, not verbs. ADR-0001 is unchanged: one skill, verb
   bodies under `verbs/`, shared contract in `SKILL.md`.

## Consequences

- Every user-facing verb points at the two SSOTs. `next` keeps abbreviated seven steps and reports
  per METHOD › Report so yokai windows comply without loading the skill.
- Method glossary gains **Chat contract** and **Document type**.
- Existing `.koi/run/METHOD.md` copies are not rewritten (`begin` never edits that file). New
  begins pick up Report.

## Rejected

- **ADHD branding / session persistence / "stop adhd mode"** — the contract is how junji chats, not a
  mode.
- **Hard cap of 5 questions per grill round** — whole-frontier stays; ADR-worthy ranking splits a
  crowded round.
- **Outline-approval workflow before writing PLAN/CONTEXT** — duplicates grill.
- **One `references/writing.md` mixing chat and docs** — chat and disk have different readers.
- **`verbs/chat.md`** — chat is not a verb.
- **SKILL.md-only chat rules** — yokai `next` windows never load the skill.
- **Reshape template headings to Diátaxis names** — section structure stays; purpose lines and
  writing rules change.
- **Yokai skill, yokai crate, or site docs in this change** — junji method only.
- **Amend ADR-0001** — the one-skill rule did not change; this ADR records the two new reference
  files.
