---
name: prd
description: >-
  Writes or updates a Product Requirements Document (PRD) — a concise,
  best-practice description of what a system, feature, or subsystem does for
  its users, never how it's built. Takes its input from a /brainstorm
  convergence artifact, a /tdd document, or the user's own description of a
  feature. Use when the user wants a PRD, product requirements doc, or asks
  to turn a brainstorm or design into product requirements, or invokes /prd.
disable-model-invocation: true
license: MIT
metadata:
  author: Marcos Oliveira
  version: "1.2.0"
---

# PRD — Product Requirements Document

Describes what a system, feature, or subsystem does for the people who use it — never how it's built. States behavior: who it's for, what it lets them do, and what "done" looks like for each scenario. Mechanism — architecture, stack, data model, APIs — belongs in a TDD or ADR, never here. Invoke explicitly with /prd.

## When NOT to apply

- The ask is about **how the system is built** — components, data model, flows — that's a TDD.
- The ask is about **one already-settled technical decision** — that's an ADR.
- The idea is still **fuzzy and unexplored** — run a /brainstorm session first, then feed its artifact here.
- The ask wants **architecture and technical contract alongside** product requirements — that's the specification (SDD) skill, not this one.

## Step 1: Locate the input

Determine what feeds this PRD, in order of what the user provides:

- **A /brainstorm artifact** — the session's convergence output or handoff summary. Read it fully.
- **A /tdd document** — read it fully.
- **Neither** — treat the user's own message as the input directly.

**Completion criterion:** you can name the input's source (brainstorm artifact, TDD, or direct input) in one sentence.

## Step 2: Extract behavior, discard mechanism

Read the input for what a user or external system observes — not how it's produced:

- **From a brainstorm artifact:** keep the converged idea, the goals it serves, and any product-relevant open gap. Discard implementation slices, engineering trade-offs, and named prices that don't change what a user sees.
- **From a TDD:** for each Key Flow, ask "what does the user experience?" and keep only that answer — discard the components, calls, and data stores that produce it.
- **From direct input:** take the behavior as given; ask only about genuine gaps (Step 4).

**Completion criterion:** every fact you're about to write traces to the input and describes an observable behavior, not a mechanism.

## Step 3: Pick the output location

Search the repo for an existing PRD directory, in order: `docs/prds/`, `docs/prd/`, `prds/`, `docs/product/`, `docs/requirements/`.

- **Found** → use it.
- **Not found** → propose `docs/prds/` as the default location, and use the AskQuestion tool so the user can confirm it or name a different path. Do not create any file or directory before they answer.

Filename: `prd-<feature-slug>.md`, kebab-case.

Check for an existing PRD at that path first — a feature gets one PRD, not several. If found, read it fully and update in place; note what changed in Step 6's summary.

**Completion criterion:** a confirmed directory path that exists on disk (create it once approved), and known whether this is a create or an update.

## Step 4: Fill the gaps

Check the extracted behavior against the template's required sections (`references/template.md`). For each section still empty — problem, target users, a scenario's acceptance criteria, a success metric — ask one targeted question. Never invent a user story, a metric, or scope the input didn't establish; put genuinely unresolved items under Open Questions instead.

**Completion criterion:** every section is either filled from a traceable source or explicitly listed under Open Questions.

## Step 5: Write the document

Follow `references/template.md` structure exactly. Writing rules:

- **Behavior, not implementation.** "The user sees an error toast within 2 seconds" not "the backend returns a 429 handled by an interceptor."
- **Concise over exhaustive.** One scenario worth documenting beats three redundant ones. Every scenario needs acceptance criteria in given/when/then; skip scenarios that don't change the criteria.
- **No persuasion.** State what the feature does, not why it's a good idea — that argument, if it happened, lives in the brainstorm artifact this PRD may link to.
- **Short sentences, no filler.** If a sentence would work in a sales deck, cut it.

## Step 6: Save and present

Save the file, then summarize:

- Path written (or updated), and what changed if updating.
- Input source(s) used (brainstorm artifact, TDD, direct input) — linked under References.
- Sections left under Open Questions, and why.

## Rules

1. Behavior only — any sentence describing a component, a data store, an API shape, or a technical trade-off belongs in a TDD/ADR, not here.
2. One PRD per feature — update in place, don't duplicate.
3. Every user story or scenario carries acceptance criteria; no scenario ships without one.
4. Never invent goals, metrics, or scope — unresolved items go to Open Questions.
5. Write in the same language the user uses.
