---
name: tdd
description: >-
  Writes or updates a Technical Design Document (TDD) — a description of how
  a system, subsystem, or component is put together, either As-Is (current
  state) or To-Be (target design). Not a proposal: states the design rather
  than building a case for it, and references the ADRs and PRDs that justify
  it instead of restating them. Use when the user asks for a technical
  design document, architecture document, or system design doc, or wants a
  system's (or part of a system's) current or target architecture written
  down with diagrams.
disable-model-invocation: true
license: MIT
metadata:
  author: Marcos Oliveira
  version: "1.0.0"
---

# TDD — Technical Design Document

Describes how a system, subsystem, or component fits together — As-Is or To-Be — without building a case for it: states what the design *is* or *will be*, and links to the ADRs/PRDs that justify it instead of re-explaining them. Mentioning a rejected shape is fine when it clarifies why the current one looks the way it does; weighing options for someone to choose between is not — that's a proposal. Invoke explicitly: "TDD" collides with Test-Driven Development, so this skill never fires on its own.

## When NOT to apply

- The decision behind the design **isn't made yet** and still needs alignment — that's a proposal, write that instead.
- The point is to **justify why** a past decision was made — that's a decision record, not a TDD.
- The audience is **product/business stakeholders**, not engineers — that's a requirements doc.
- The ask is about **writing tests, test strategy, or red-green-refactor** — this skill's name collides with that on purpose, but has nothing to do with it.

## Step 1: Determine scope and mode

Name the boundary — the whole system, a subsystem, or a component — and the mode: **As-Is** (runs today) or **To-Be** (should be built). Ask if either is unclear.

**Completion criterion:** boundary and mode stated in one sentence.

## Step 2: Locate inputs

- Check whether a TDD already exists for this boundary (search the output directory from Step 3). If it does, read it fully and update in place — a system gets one TDD, not several. Re-check each building block and flow against the current sources, fix drift, leave sections that still hold untouched, and note what changed in Step 6's summary.
- **To-Be only:** search for the PRDs (`prds/`, `docs/prds/`) and ADRs (`docs/adrs/`, `docs/architecture/`) that anchor this design. These are inputs to reference, not content to duplicate.
- **As-Is:** no PRD/ADR search is required, but link any you find relevant for context.

**Completion criterion:** you know whether you're creating or updating, and which ADRs/PRDs (if any) this TDD will cite.

## Step 3: Pick the output location

1. If the repo has `docs/tdds/`, save there.
2. Else if it already has a convention for this kind of doc (`docs/design/`, `docs/designs/`, `architecture/`), use that instead of introducing a new one.
3. Else ask the user; default to `docs/tdds/` if they have no preference, and create the directory.

Filename: `tdd-<system-slug>.md`, kebab-case.

## Step 4: Gather the architecture

- **As-Is:** read the actual code — entry points, service/module boundaries, data stores, external calls. Ground every building block and flow in a file or config you actually opened.
- **To-Be:** read the PRD (goals, scope) and ADRs (decisions already settled) located in Step 2. Fill remaining gaps from the user's brief. If a needed decision isn't recorded anywhere, don't invent it — list it under Open Questions in the template instead.

**Completion criterion:** every component and flow you're about to write down has a traceable source — a file, an ADR, a PRD, or an explicit gap note.

## Step 5: Write the document

Read `references/tdd-template.md` and follow its structure. For each of System Context, Building Blocks, every Key Flow, and Data Model, attempt a mermaid diagram — skip one only when the section genuinely has nothing to diagram, and say so rather than leaving it silently out.

Writing rules:

- **Objective, not descriptive-adjective.** Replace claims with the fact behind them.

  | Vague | Objective |
  |---|---|
  | "Handles requests efficiently" | "Processes each request in one goroutine, writes to Postgres synchronously" |
  | "Modern microservices architecture" | "Three services communicate over gRPC; the catalog service owns the `products` table" |
  | "Data flows through several layers" | *(a sequence diagram, not a sentence)* |

- **Present tense for As-Is.** Declarative "will" / "must" for To-Be. Never switch tense within a section without a label.
- **No persuasion.** No "we recommend", no pros/cons table weighing options. A rejected shape can get a sentence of context inline; the full argument, if it happened, lives in an ADR you link to.
- **Short sentences, no filler.** If a sentence would work in a PRD's marketing copy, cut it.

## Step 6: Save and present

Save the file, then summarize:

- Path written (or updated).
- Sections thin on detail, and why (missing PRD/ADR, code not yet written for To-Be, etc.).
- Diagrams skipped, and why.
- ADRs/PRDs referenced, with links.

