---
name: tdd
description: >-
  Writes or updates a Technical Design Document (TDD) — a description of how
  a system, subsystem, or component is put together. Not a proposal: states
  the design rather than building a case for it, and references the ADRs,
  PRDs, or brainstorm docs that justify it instead of restating them. Grounds
  every part in the most reliable source available — code where it's built,
  anchor docs where it isn't yet — and flags unbuilt pieces inline instead of
  labeling the whole document. Use when the user asks for a technical design
  document, architecture document, or system design doc, or wants a system's
  (or part of a system's) architecture written down with diagrams.
disable-model-invocation: true
license: MIT
metadata:
  author: Marcos Oliveira
  version: "2.0.0"
---

# TDD — Technical Design Document

Describes how a system, subsystem, or component fits together, without building a case for it: states what the design *is*, and links to the anchor docs that justify it instead of re-explaining them. An anchor doc is whatever settled the decisions this design rests on — a PRD, an ADR, a brainstorm's convergence doc — or, when none exists, the user's own description in conversation. Mentioning a rejected shape is fine when it clarifies why the current one looks the way it does; weighing options for someone to choose between is not — that's a proposal. Invoke explicitly: "TDD" collides with Test-Driven Development, so this skill never fires on its own.

There's no As-Is/To-Be mode to pick. A doc labeled "To-Be" goes stale the day the system gets built and nobody remembers to relabel it. Instead, every building block and flow is grounded in whichever source is more reliable right now — code if it exists, an anchor doc if it doesn't — and any piece that isn't built yet gets a `(planned, not yet implemented)` note inline rather than a mode tag on the whole document.

## When NOT to apply

- The decision behind the design **isn't made yet** and still needs alignment — that's a proposal, write that instead.
- The point is to **justify why** a past decision was made — that's a decision record, not a TDD.
- The audience is **product/business stakeholders**, not engineers — that's a requirements doc.
- The ask is about **writing tests, test strategy, or red-green-refactor** — this skill's name collides with that on purpose, but has nothing to do with it.

## Step 1: Determine scope

Name the boundary — the whole system, a subsystem, or a component. Ask if it's unclear.

**Completion criterion:** boundary stated in one sentence.

## Step 2: Locate inputs

- Check whether a TDD already exists for this boundary (search the output directory from Step 3). If it does, read it fully and update in place — a system gets one TDD, not several. Re-check each building block and flow against the current sources, fix drift, leave sections that still hold untouched, and note what changed in Step 6's summary.
- Look for code that implements this boundary — entry points, service/module boundaries, data stores, external calls. Whatever is actually built is the ground truth for those parts.
- Search for anchor docs regardless of how much is built, in this order — PRDs (`docs/prds/`, `docs/prd/`, `prds/`), ADRs (`docs/adrs/`, `docs/adr/`, `decisions/`), brainstorm convergence docs (`docs/brainstorms/`, or a `brainstorm-*.md` at the repo root for older sessions). These are inputs to reference, not content to duplicate, and they're what cover any part that isn't built yet.
- **Nothing found, or the user already gave the design as a summary in chat** (e.g. a brainstorm handoff with no file, or an ad-hoc description): that's a valid case — treat the conversation itself as the anchor and say so in Step 6 instead of citing a doc that doesn't exist.

**Completion criterion:** you know whether you're creating or updating, which parts have code to ground them, and which anchor docs — or lack thereof — cover the rest.

## Step 3: Pick the output location

Search the repo for an existing TDD directory, in order: `docs/tdds/`, `docs/tdd/`, `docs/design/`, `docs/designs/`, `docs/architecture/`, `architecture/`.

- **Found** → use it.
- **Not found** → propose `docs/tdds/` as the default location, and use the AskQuestion tool so the user can confirm it or name a different path. Do not create any file or directory before they answer.

Filename: `tdd-<system-slug>.md`, kebab-case.

**Completion criterion:** a confirmed directory path that exists on disk (create it once approved).

## Step 4: Gather the architecture

- For parts that are built: read the actual code you found in Step 2 — entry points, service/module boundaries, data stores, external calls. Ground every such building block and flow in a file or config you actually opened.
- For parts that aren't built yet: read the anchor docs located in Step 2 — the PRD for goals and scope, ADRs and the brainstorm doc for decisions already settled. Fill remaining gaps from the user's own input in conversation. If a needed decision isn't recorded anywhere, don't invent it — list it under Open Questions in the template instead.
- Mark each unbuilt component, flow, or interface with `(planned, not yet implemented)` right where it's introduced, so the reader knows without needing a document-wide label.

**Completion criterion:** every component and flow you're about to write down has a traceable source — a file, an anchor doc, or an explicit note that it came from the user's own input — and every unbuilt one is flagged inline.

## Step 5: Write the document

Read `references/tdd-template.md` and follow its structure. For each of System Context, Building Blocks, every Key Flow, and Data Model, attempt a mermaid diagram — skip one only when the section genuinely has nothing to diagram, and say so rather than leaving it silently out.

Writing rules:

- **Objective, not descriptive-adjective.** Replace claims with the fact behind them.

  | Vague | Objective |
  |---|---|
  | "Handles requests efficiently" | "Processes each request in one goroutine, writes to Postgres synchronously" |
  | "Modern microservices architecture" | "Three services communicate over gRPC; the catalog service owns the `products` table" |
  | "Data flows through several layers" | *(a sequence diagram, not a sentence)* |

- **Present tense throughout.** Describe the design as it stands, built or not. For a planned piece, keep the sentence in present tense and let the `(planned, not yet implemented)` tag carry the distinction — don't switch the whole section to "will"/"must".
- **No persuasion.** No "we recommend", no pros/cons table weighing options. A rejected shape can get a sentence of context inline; the full argument, if it happened, lives in an ADR you link to.
- **Short sentences, no filler.** If a sentence would work in a PRD's marketing copy, cut it.

## Step 6: Save and present

Save the file, then summarize:

- Path written (or updated).
- Sections thin on detail, and why (missing anchor doc, code not yet written, etc.).
- Diagrams skipped, and why.
- Anchor docs referenced, with links — or, if there were none, a note that the design came from the user's own input instead of a written source.

