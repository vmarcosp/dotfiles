# Verb: `research` — primary-source notes for plan and grill

Investigate open **factual** questions against high-trust primary sources and capture each as a Markdown
note under `.koi/run/researches/`. Notes are context for `plan` and `grill`: not decisions, not a
phase plan, and not the same as **phase research** inside `next` (that step only opens the files a phase
already named).

**On demand.** Optional; run zero, one, or many times (batch or sequential). Does **not** advance
`.koi/run/BACKLOG.md › Next action`. Does not write `PLAN.md` or lock decisions into `CONTEXT.md`.

Chat like `references/chat.md`. Write each note as **reference** (claims only) per `references/docs.md`.

## Prerequisites

- Requires `.koi/run/BACKLOG.md` (a real `begin`). If missing, say so and stop: point at `/junji begin`.
  Do **not** scaffold the working folder from this verb.
- Does **not** require `PLAN.md`.

## Protocol

1. **Gather questions.**
   - Parse questions from the rest of `/junji research …` or a bullet/numbered list in the user message.
   - If the user already listed questions, do **not** ask for a separate confirm: research them.
   - If they only point at a source doc with no explicit questions, propose a short numbered list of open
     *factual* gaps and confirm before researching.
   - When `plan`/`grill` invoke this method for a frontier fact-gap, that gap **is** the question: no
     confirm.
   - Only primary-source gaps (APIs, docs, code behavior, specs). Never invent load-bearing *decisions*
     as research questions.

2. **Ensure `.koi/run/researches/`.** Create the folder on first use. Do not create it in `begin`.

3. **Investigate: primary sources only.** Official docs, source code, specs, first-party APIs: not a
   secondary write-up of them. Follow every claim back to the source that owns it.
   - Prefer a **sub-agent** (or one per question when researching several at once) when the host can spawn
     one, so the main window stays free. **Inline is allowed and equivalent**: same bar, same files.
   - For multiple questions in one invocation: parallel sub-agents when possible, else serialize.

4. **Write one note per question.** From `templates/research-note.template.md` →
   `.koi/run/researches/NN-<slug>.md` (`NN` = next zero-padded sequence in that folder; `<slug>` from the
   question). Fill Question, Findings, Sources (required citations), Open gaps if any.

5. **Stop.** First line: `Next action:` whatever BACKLOG already says (this verb does not move it). Then
   the paths written. Do not edit PLAN/CONTEXT, do not start `plan` or `grill` unless the user asked.

## Rules

- Finding *facts* is this verb's job; *decisions* belong to grilling.
- A missing `researches/` folder is normal until first use: `plan`/`grill` skip it without error.
- `consolidate` removes these notes with the rest of `.koi/run/`.
