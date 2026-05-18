---
name: to-html
description: Generates a rich, self-contained HTML artifact from a prompt plus any referenced files (specs, RFCs, code, transcripts, data). Uses a small local framework (Tailwind config, Alpine components, th-* CSS) and pre-styled archetype starters so generated files stay small, declarative, and visually consistent. Use when the user wants a visual, interactive preview of context: implementation plans, code reviews, design explorations, explainers, status reports, or throwaway editors. Triggers on "/to-html", "make an HTML", "render this as HTML", "HTML artifact", "HTML preview".
user-invocable: true
---

You produce HTML files that make information read rather than skim. Markdown walls get ignored; rich HTML with visual hierarchy, embedded diagrams, and small interactions gets read.

The skill ships with a framework: a thin starter template, two local asset files (`to-html.js`, `to-html.css`), a set of pre-styled archetype starters, and a living gallery (`reference.html`). Generated artifacts pick an archetype, paste its body markup, and fill placeholders — they do **not** invent layout from scratch.

## When to activate

- The user types `/to-html` or `/to-html <some-prompt>`
- The user references files (`@specs/foo.md`, a path, a glob) and asks for "an HTML version", "a visual one", "make this readable"
- The user asks for an implementation plan, PR explainer, design exploration, concept explainer, status report, or throwaway editor that would feel cramped in markdown

If a two-paragraph answer would do, stay in chat. Do not produce an artifact for a small question.

## The framework

```
~/.claude/skills/to-html/
  SKILL.md
  template/
    template.html         ← copy this, fill the six header placeholders
    to-html.js            ← Alpine components
    to-html.css           ← th-* layout primitives + highlight.js theme
    reference.html        ← living gallery of every component
    archetypes/
      base.html           ← fallback body (one of every primitive)
      plan.html           ← Plan / RFC / spec (default for structured docs)
      flowchart.html      ← interactive annotated flowchart
      explainer.html      ← concept walkthrough with steps + tabs + FAQ
      code-review.html    ← PR / branch review with risk map + diffs
```

Generated artifacts load six things in `<head>`:

1. Tailwind Play CDN: utility classes
2. Inline `tailwind.config`: palette + tokens (must be after the CDN script)
3. `./to-html.css` (local, via `file://`): `.th-*` layout primitives + highlight.js theme
4. `./to-html.js` (local, via `file://`): Alpine components
5. Alpine.js + collapse plugin: declarative behavior
6. highlight.js: code block auto-highlighting

The order matters and is wired up correctly in `template.html`. Do not rearrange it.

## Palette

Six colors plus four grays. Names only; hex codes live in `to-html.js`. The palette is intentionally narrow — every extra color the model reaches for makes the artifact noisier.

- `text-ink` (primary ink), `bg-paper` (page background)
- `bg-pink`, `bg-pink-soft` (accent + tint — the only decorative accent)
- `bg-mint` (done / safe / good)
- `bg-butter` (warn / nit)
- `bg-blush` (error / blocking)
- `gray-100`, `gray-300`, `gray-500`, `gray-700`
- `font-serif` for titles, `font-sans` for body, `font-mono` for tags and code

Pastels carry semantics, not decoration. Use them on small surfaces (pills, badges, callout borders), never as section backgrounds.

## Typography scale

Set in `to-html.css` as `.th-h1` through `.th-h5`. Apply these classes on every heading. **Never** set Tailwind `text-*` utilities on headings directly — that's how hierarchy gets flattened across artifacts.

| Class | Size | Family | Use |
|---|---|---|---|
| `.th-h1` | 38px | serif | Page title (in `<header>`) |
| `.th-h2` | 26px | serif | Top-level section title (after `.th-sec-num`) |
| `.th-h3` | 19px | serif | Subsection title |
| `.th-h4` | 14px uppercase | sans | Eyebrow label |
| `.th-h5` | 11px uppercase | mono | Mono eyebrow / nav label |
| `.th-lede` | 15.5px | sans | One-sentence headline right under `.th-h1` |

## Section rhythm

Centralised vertical spacing. **Never set Tailwind margin utilities on a section wrapper** — wrap content in these classes instead.

- `.th-section { margin-bottom: 64px }` — every top-level section
- `.th-subsection { margin-bottom: 40px }` — every H3 block inside a section
- `.th-sec-intro` — gray 14.5px one-sentence orientation under the section title
- `.th-stack > * + * { margin-top: 16px }` — vertical stack of mixed children
- `.th-stack-tight` (8px) and `.th-stack-loose` (24px) variants

This is the single biggest source of inconsistent rhythm across artifacts. Use the primitives.

## Archetypes

Pick the closest archetype before composing. Copy its body file from `template/archetypes/`. Fill the placeholders. Do not invent layout.

| Archetype | When the artifact is… | Starter file |
|---|---|---|
| **Plan / RFC** | A spec, RFC, PRD, or ADR with structured sections | `archetypes/plan.html` |
| **Flowchart** | Primarily a diagram (pipeline, decision tree, request path) | `archetypes/flowchart.html` |
| **Explainer** | A concept walkthrough with steps, config, FAQ | `archetypes/explainer.html` |
| **Code review** | A PR, branch review, or diff walkthrough with risk-stratified comments | `archetypes/code-review.html` |
| **Base (fallback)** | None of the above fit | `archetypes/base.html` |

If a request fits two, prefer the more specific one. If nothing fits, use `base.html` and add archetype-specific content using the framework primitives.

## Workflow

### 1. Gather context

Read every referenced file in full before writing any HTML. If references span more than a few files, spawn an `Explore` agent in parallel to summarise each one, but keep the synthesis (archetype choice and outline) in this conversation.

### 2. Outline before writing tags

Write a brief outline in chat: archetype, top-level sections, the one or two interactive bits if any, and what the headline is. Under 10 lines. If the outline is boring, the HTML will be too.

### 2.5. Coverage map (specs, RFCs, plans)

When the input is a structured doc, do not skip this step. Compression without an explicit gap log is silent data loss: the artifact ends up looking complete when it is not.

List every top-level heading and meaningful subheading from the source as a flat checklist. Tag each one:

- **render**: appears as its own section, table, card grid, or collapsible list.
- **fold-into-X**: merged into another section. Name the target.
- **drop-with-reason**: intentionally omitted. One sentence why.

Anything not tagged must show up in the artifact. Two rules ride on top:

- **Every table in the source gets a visual element in the output.** A rendered table, a card grid, or a `<details>` list. Not prose.
- **Numbered lists (FRs, NFRs, invariants) stay numbered.** Do not scatter a 6-item FR list across goals and timeline bullets.

User-story acceptance criteria are *why*; a Scenarios table is *what*. Acceptance Criteria, Alternatives Considered, Integration Points, Invariants & Constraints, Data Models, and Observability commands are common silent drops. Watch for them by name.

### 3. Generate the file

Default output path: `.artifacts/html/<slug>-<YYYYMMDD-HHMM>.html` under the current working directory. Create the folder if missing. The slug comes from the prompt or the primary referenced file. If the user passed an explicit path, honor it.

1. Copy `~/.claude/skills/to-html/template/template.html` to the output path.
2. Fill the six header placeholders: `{{TITLE}}`, `{{EYEBROW}}`, `{{ONE_SENTENCE_HEADLINE}}`, `{{PROMPT_TEXT}}`, `{{SOURCE_FILES}}`, `{{DATE}}`.
3. Pick the archetype (see table above). Open `~/.claude/skills/to-html/template/archetypes/<name>.html`. Paste its body markup between the `<header>` and `<footer>` in your artifact.
4. Fill the archetype's placeholders with content from the source. Replace, expand, or delete sections as the source dictates — the starter is a scaffold, not a contract.
5. Use framework primitives for any layout the starter doesn't cover. New layout primitives go in `to-html.css`; do not inline CSS.

### 4. Open it

After writing the file, run `open <path>` on macOS so the user sees it immediately. Then print a short summary in chat:

- **Archetype + path**: one line.
- **What to look at first**: one sentence.
- **Source coverage** (when step 2.5 ran): one line of the form `X rendered, Y folded into Z, W dropped (reason: …)`. If anything was folded or dropped, name it.

### 5. Iterate

Edit the file in place when the user asks for changes; do not generate a fresh timestamped copy. If they ask for a variant (a B option), create a sibling file with `-v2` in the name.

## Flowcharts

Hand-authored SVG only. Use the `archetypes/flowchart.html` starter or compose inline with `.th-diagram` wrapping a `<svg>`. Define arrow markers in `<defs>`. Place nodes by hand. Use solid lines for the happy path and `stroke-dasharray="5 4"` with a different marker color for failure / alternate edges.

**Make it click-to-explore.** The flowchart archetype is wired through the `interactiveNodes` Alpine component: each `<g class="th-node" data-th-node="key">` becomes clickable and the side panel renders one `<template x-if="is('key')">` block per node. This means a reader can click any step to see what runs, how long it takes, and what the YAML/config looks like. A flowchart with eight nodes and no detail is a sketch — the per-node panel is what makes it an artifact. Pre-activate the most-asked-about node via `interactiveNodes('key')` so the panel never starts empty.

If a diagram is genuinely impractical to hand-author (a dense state machine, a 20+ node auto-layout graph), say so and reconsider whether the artifact needs that diagram at all — the framework no longer ships a Mermaid runtime.

## Code blocks

Wrap every code block in a `.th-code-wrap` with `x-data="codeBlock"`. Inside, put the optional `.th-code-label`, the `pre.th-code` with a `<code class="language-X">` (X = ts, js, sql, yaml, etc.), and a copy button. highlight.js auto-detects the language on init and applies token classes; the palette-matched theme lives in `to-html.css`.

```html
<div class="th-code-wrap" x-data="codeBlock">
  <div class="th-code-label">example.ts</div>
  <pre class="th-code"><code class="language-ts">…</code></pre>
  <button class="th-copy-btn" @click="copy()" x-text="copied ? 'Copied' : 'Copy'">Copy</button>
</div>
```

For an inline error code or identifier mentioned in running prose, use `<span class="th-code-em">CODE</span>` (subdued blush tint), not a full `.th-tag` pill. Pills inside paragraphs break baseline rhythm.

## Component reference

Open `template/reference.html` in a browser to see every component live with its source. Quick index:

| Component | What it is | Markup hint |
|---|---|---|
| Header (eyebrow + h1 + lede + promptBox) | Required page header. `promptBox` auto-collapses prompts over 200 chars. | `<div x-data="promptBox">` |
| Summary strip | 4-cell key-value row. Use `.th-v-accent` (color) instead of `.th-accent` (underline) for single-digit metrics. | `.th-summary > .th-cell` with `.th-k` / `.th-v` |
| Section number | Mono pink-soft pill + serif H2 | `.th-sec-head > .th-sec-num + h2.th-h2` |
| Milestone timeline | Vertical timeline. Three-column variant requires `.th-when + .th-dot-col + .th-milestone-body`. For undated steps use `.th-milestone-simple` (two-column). | `.th-milestone`, `.th-dot`, `.th-dot-done`, `.th-dot-todo` |
| Callout | Left-bordered semantic note | `.th-callout-info`, `-warn`, `-error`, `-good` |
| Term list | Definition list — grid variant for short labels, stacked variant for code/table content | `.th-term-list` or `.th-term-list-stacked` |
| Tag pills | Semantic pastel pills (5 variants only) | `.th-tag`, `.th-tag-happy`, `-warn`, `-error`, `-mute` |
| Label row | Tag + identifier on one baseline | `<div class="th-label-row"><span class="th-tag">…</span><code>…</code></div>` |
| Tag-prefixed list | Aligned tag column so all tag right-edges line up | `<ul class="th-tag-list">` |
| Inline code emphasis | Error codes / identifiers in prose | `<span class="th-code-em">` |
| Diagram wrapper | Border + padding + min-height for hand-authored SVG | `<div class="th-diagram">` |
| Table | Styled table with hover rows | `<div class="th-table-wrap"><table class="th-table">` |
| Diff block | Mint / blush line highlights with line numbers | `.th-diff-line`, `.th-diff-add`, `.th-diff-rem`, `.ln` |
| Code block with Copy | Wrapper + copy button + highlight.js auto | `<div class="th-code-wrap" x-data="codeBlock">` |
| Configurable contract | Two-way bound config inputs + templated copy | `<div x-data="configBlock({...})">` |
| Scenario row | Collapsible `<details>` with 3-column body | `details.th-scenario`, `.th-scenario-body` |
| Tabs | Active-tab tracker over `[data-th-tab]` children | `<div x-data="tabs('initial')">` |
| Interactive nodes | Click-to-explore SVG diagrams. Active-key tracker over `[data-th-node]` children with `.th-node-active` highlight, optional `.th-node-ok` / `.th-node-bad` tint variants. Side-panel content lives in `<template x-if="is('key')">` blocks. | `<section x-data="interactiveNodes('push')">` |
| Jump flash | Anchor highlighter: flashes a soft pink ring on the target card when a descendant `<a data-th-jump>` is clicked. Use on risk maps, summary chips, and ToCs. | `<div x-data="jumpFlash">` |
| Checklist | Native checkbox list with mint accent + strikethrough on check. Use for "suggested next steps" and actionable follow-ups. | `<ul class="th-checklist">` |
| Open-question card | Boxed callout for unresolved decisions | `<div class="th-q">` with `.th-q-title`, `.th-q-body`, `.th-q-owner` |
| `$clipboard` magic | One-shot copy from any scope | `$clipboard('text')` |
| Provenance footer | Required citation line | `.th-provenance` |

If a component you need does not exist, write it into `to-html.css` (layout) or `to-html.js` (behavior). Then add a section for it in `reference.html`. Do not inline it inside the artifact.

## Anti-patterns

- **Tailwind utilities for layout primitives.** `mb-14`, `mb-8`, `mb-6` scattered across sections. Use `.th-section` / `.th-subsection` / `.th-stack` instead.
- **Tailwind `text-*` on headings.** Use `.th-h1` through `.th-h5` so the type scale stays consistent across artifacts.
- **Reaching for a runtime diagram library.** Hand-authored SVG only — the framework no longer ships Mermaid or any other diagram runtime.
- **Pills inside running prose.** Use `.th-code-em` for inline error codes; reserve `.th-tag` for standalone labels (table cells, card headers, list-item prefixes).
- **Silent compression.** Folding a Scenarios table, Alternatives Considered table, FR/NFR list, or Invariants list into prose without listing it in the chat summary. The coverage line is the only signal.
- **AC blurbs as a substitute for a Scenarios table.** User-story acceptance criteria say *why*; scenarios say *what*. Render both shapes if both exist.
- **Decorative interactivity.** A slider that does nothing, tabs where only one panel is filled, a toggle that just hides text. Either deliver or remove.
- **Markdown-shaped HTML.** Long prose, no visuals. If the only thing the file adds over the input is `<style>`, tell the user the markdown is already fine.
- **Inflated artifacts.** A 200-line spec does not need 12 sections.
- **Em dashes as connectors.** Use colons or periods.
- **Re-implementing components.** Use the framework component; extend it in `to-html.js` if it falls short.
- **Inlining CSS that belongs in `to-html.css`.** New layout primitives go in the framework, not in the artifact.

## Quality bar

A good artifact:

- Loads in under 1 second.
- Reads cleanly on a phone (375px) and on a 1440px monitor.
- Has as many interactions as earn their place and no decorative ones. An interaction earns its place when it lets the reader produce something they would otherwise copy-paste by hand, lets them compare two states, or collapses a long repetitive list.
- Could be printed and still tell the story (the framework's `@media print` block handles this).
- Cites its inputs. The provenance footer names the source files and date.
- Cites its source coverage. The end-of-task chat summary names every spec section as rendered, folded, or dropped.
- Earns its existence. If a markdown file would do, do not make HTML.
