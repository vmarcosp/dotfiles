---
name: my-voice
description: >-
  Writes Slack, documents, emails, PRs, and replies in Marcos's voice (pt-BR and
  en-US) by wrapping humanizer. Use when drafting or rewriting prose the user will
  send or ship; when they say /my-voice; when another skill needs voice.
user-invocable: true
argument-hint: '"your text" [--mode detect|rewrite|edit] [--voice casual|professional|technical|warm|blunt] [--file path/to/file.md] [--aggressive] [--iterate N] [--score] [--purpose essay|email|marketing|technical|general]'
allowed-tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - AskUserQuestion
---

# my-voice

Wrapper around [`../humanizer/SKILL.md`](../humanizer/SKILL.md). Same flags. The overlay is Marcos's **voice** — bilingual, workplace-warm, specific.

Arguments received: $ARGUMENTS

This skill does not restate humanizer's pattern catalog. Humanizer still does detect / rewrite / edit. **Voice** sits on top of `--voice` and `--purpose`.

## Step 1: Parse arguments

Parse `$ARGUMENTS` with the same flag contract as humanizer:

- **Text** — everything that is not a flag. If no text and no `--file`, ask for paste or `--file`.
- `--mode` `detect` | `rewrite` | `edit` — default `rewrite`
- `--voice` `casual` | `professional` | `technical` | `warm` | `blunt`
- `--file`, `--aggressive`, `--iterate N`, `--score`
- `--purpose` `essay` | `email` | `marketing` | `technical` | `general`

If `--voice` or `--purpose` is omitted, infer:

| Situation | `--voice` | `--purpose` |
|-----------|-----------|-------------|
| Slack, DM, thread reply | `casual` | `email` |
| RFC, PRD, design doc, README | `technical` | `technical` |
| Hiring / stakeholder update | `professional` | `email` if it will be sent; else `general` |
| Review, hard call | `blunt` | `general` |

**Language:** match the user's request and the source text. pt-BR and en-US are both in-voice. Keep English product names inside Portuguese (`FastCheckout`, `extension points`, `PR`). Do not mix languages in a sentence unless the source already does.

**Completion criterion:** every flag has a value (parsed or inferred); language is chosen; register is `slack` or `document`.

## Step 2: Load voice

Read [`VOICE.md`](VOICE.md) before any rewrite. Treat it as the voice overlay for this run (it replaces `humanizer-context.md` for `/my-voice`). Skip cwd `humanizer-context.md` unless the user named it.

Pick the **register** in VOICE.md that matches the situation (`slack` vs `document`) and the language from Step 1.

**Completion criterion:** VOICE.md is in context; the register + language pair you will write in is identified.

## Step 3: Run humanizer

Read [`../humanizer/SKILL.md`](../humanizer/SKILL.md) and execute it with the parsed flags.

While humanizer injects its generic `--voice` profile, apply VOICE.md as the identity layer: cadence, warmth, honesty, bilingual habits. Humanizer's catalog still kills chatbot tells.

**Completion criterion:** humanizer's chosen mode finished, and the output would pass VOICE.md's "who wrote this?" test for this register and language.

## Step 4: Voice check

Before showing the result:

1. A coworker who reads Marcos's Slack and RFCs would recognize this as him, not a generic humanizer profile.
2. Same language as Step 1. English drafts use the en-US equivalents in VOICE.md, not calques.
3. Workplace-warm: first names, `bora` / "shall we", honest takes. No crude slang, no in-jokes that only make sense in a private group.
4. Slack stays sendable (no leftover Markdown if `--purpose email`). Documents keep structure (glossary, CoS, non-goals, FAQ as real questions).

If `--mode detect`, report humanizer's pattern report, then one line on whether the sample already sits in-voice.

**Completion criterion:** all four checks pass, or `--mode detect` produced the report plus the in-voice line.
