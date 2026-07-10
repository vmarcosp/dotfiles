---
name: adr
description: >-
  Creates one Architecture Decision Record (ADR) — a short, objective record of
  a decision already made, its context, and its consequences. Use when the
  user wants to document a technical decision, mentions ADR, architecture
  decision record, or invokes /adr.
license: MIT
metadata:
  author: Marcos Oliveira
  version: "1.1.0"
---

# ADR — Architecture Decision Record

Records one decision that has already been made — its context and its consequences, not a case for making it. If the decision is still open, that belongs in a discussion or proposal; write the ADR once it settles.

## Step 1: Find the ADR home

Search the repo for an existing ADR directory, in order: `docs/adrs/`, `docs/adr/`, `doc/adrs/`, `decisions/`, `docs/architecture/decisions/`.

- **Found** → use it.
- **Not found** → propose `docs/adrs/` as the default location, and use the AskQuestion tool so the user can confirm it or name a different path. Do not create any file or directory before they answer.

**Completion criterion:** a confirmed directory path that exists on disk (create it once approved).

## Step 2: Gather the decision

Use what the conversation already established. For any of these still missing, ask — one question per gap, no more:

- **Title**: the decision in a few words.
- **Context**: the problem or forces that made a decision necessary.
- **Decision**: what was decided, stated as fact.
- **Consequences**: what becomes easier and what becomes harder as a result.

Skip alternatives entirely unless the user names a rejected option — an ADR states the decision, it doesn't weigh options for the reader.

**Completion criterion:** Title, Context, Decision, and Consequences all hold real content — no placeholders.

## Step 3: Number and name the file

List the ADR directory for files matching `adr-NNNN-*.md`; take the highest number and add one (`0001` if the directory is empty). Slugify the title into kebab-case.

Filename: `adr-NNNN-<title-in-kebab-case>.md` (e.g. `adr-0007-use-postgres-for-orders.md`).

**Completion criterion:** filename decided, no collision with an existing file.

## Step 4: Write the file

Follow `references/template.md` exactly — no extra sections. Status defaults to `Accepted` unless the user says otherwise (`Proposed`, `Rejected`, `Deprecated`, `Superseded by <link>`). Write in the same language the user used in the conversation.

If this ADR supersedes an earlier one, update that file's Status line to `Superseded by [adr-NNNN](adr-NNNN-slug.md)`.

## Step 5: Report

Tell the user the path written and its status.

## Rules

1. One decision per ADR — a request bundling several becomes one file per decision, numbered in sequence.
2. Never write a file before Step 1's directory is confirmed.
3. Template sections only — no alternatives-weighing prose, no restating the discussion that led here.
