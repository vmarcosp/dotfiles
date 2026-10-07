# Optional research verb and frontier grilling

## Status

Accepted

## Context

`plan` and `grill` often need durable primary-source facts (APIs, docs, specs, foreign code) before locking
decisions. Until now the method had no place to park that legwork, and grilling asked **one question at a
time**, which made large design trees slow. Inspiration: mattpocock's `research` skill (cited notes from
primary sources) and `batch-grill-me` (frontier rounds).

## Decision

1. **Add an optional on-demand `research` verb** — seventh verb under the same progressive-disclosure
   skill. Writes one cited Markdown **research note** per question under `.koi/run/researches/NN-<slug>.md`.
   Does not advance Next action. Prefer sub-agents when available; inline is equivalent.
2. **`plan` and `grill` consume notes when present** — read all notes before reasoning/grilling; missing
   folder is fine. Mid-grill fact gaps may invoke the research method without blocking the rest of the
   frontier round.
3. **Rename `next` step 2 to phase research** in docs — behavior unchanged; keep the verb name `research`.
4. **Replace one-question-at-a-time grilling with frontier rounds** — ask every decision whose
   prerequisites are settled in one round (numbered + recommended answers), wait, recompute; keep
   with-docs crystallization.

## Consequences

- Verb count is seven; ADR-0001's progressive-disclosure rationale still holds (one skill, verb bodies under
  `verbs/`).
- Pipeline narrative: `begin → (research*) → plan → refine → next … → consolidate`, with `research` and
  `grill` on demand.
- Glossary must distinguish **research** (verb / notes) from **phase research** (`next` step 2).

## Rejected

- **Required research step in the Next-action pipeline** — fights optional; forces empty work.
- **Single rolling `RESEARCH.md`** — hard to cite; fights multiple questions at once.
- **Scaffold `researches/` in `begin`** — folder should appear on first use only.
- **Keep one-question-at-a-time as default / dual mode** — splits the grilling SSOT.
- **Rename the verb to avoid clashing with `next`'s old "research" step** — `research` is the user-facing
  word; clarify with **phase research** instead.
