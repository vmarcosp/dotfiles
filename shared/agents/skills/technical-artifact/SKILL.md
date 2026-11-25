---
name: technical-artifact
description: Turn a technical document (RFC, TDD, ADR, design doc) into a visual, interactive summary page published with the Artifact tool, which Marcos reads instead of the document. Minimal black-white-gray page with a few pastels, a clickable architecture, step-through flows, UI mockups and every decision with its origin and reason; drops code and run phases. Use when asked for "artefato da RFC", "resumo visual", "technical artifact", "/technical-artifact <path>", or after an RFC, TDD or ADR is written and debated for Marcos to read (Modo B, step 2).
---

The page is the document **easier to read, not shallower**. Marcos reads it instead of the document,
then answers the open questions one by one. A page that lists only user-visible behavior has failed:
it must show the components, who talks to whom, the new states and contracts, the main flows and
every decision with its reason.

It is also **simple, beautiful and pleasant to read**: minimal black, white and gray with a few
pastels, more visual than the document and a little playful. Where the design has UI, the page shows
a mockup of it. The main diagrams are interactive, not static.

- `references/structure.md`: the page skeleton, section by section.
- `references/components.md`: the tokens, type and the interactive patterns. Start from these snippets;
  add classes when a mockup needs them, using the same tokens. Do not restyle. Two runs must produce
  pages that look like siblings.

## Inputs

1. **The document path** (argument or the one just written in this session). Required.
2. **The sources it pins** (PRD, handoff, prototype), at the pinned commit. Read only to check claims
   the page makes; never add content from them that the document does not state.
3. **The decision log**, if any: the epic's Brain note (`~/projects/brain/Agent/<Project>/<Epic>/`,
   `State.md` or `Runs/* — decisions.md`), or a "Decided before this RFC" section.

No document path, or two candidates: ask Marcos with numbered options.

Done when the document is read in full and its word count is known (`wc -w`).

## Read the document

1. Read the whole document. List its design sections (for an RFC, each `###` under `## Design`).
2. For each section, extract:
   - the components it adds or changes, and the process or layer each lives in (main, renderer,
     preload, domain, engine/agent, gateway, external service);
   - the calls and events between them;
   - each new type, state or contract, as a shape: name, fields and meaning;
   - the flow or state machine, if one exists;
   - the UI it adds or changes: surfaces, the strings it quotes, and the states of each surface;
   - the reason the document gives, or note that it gives none.
3. Extract the **explicit decisions** only: numbered ones, ones the document attributes to someone,
   and the ones in the decision log. Give each its origin from this list:
   - `Marcos`;
   - `regra (fonte, linha)`, for example `regra (PRD L764)`;
   - `orquestrador (revisável)`, a decision the orchestrator took by rule, which Marcos may reverse;
   - `revisor (Fable)` or `revisor (Opus)`;
   - `autor`, only when the document says the author chose it.
   A decision with two origins is one row with both listed, such as `Marcos + orquestrador (revisável)`.
   Never split it into extra rows. For the filter, `data-kind` is the first origin.
   A decision with no reason in the document gets "—" as its reason and joins the report of document
   gaps. Never paraphrase a nearby fact as the reason.
   A design choice with no decision behind it is not a decision: it stays in its section.
4. Extract the problem, non-goals, known limits, follow-ups, open questions, acceptance criteria and
   divergences from the sources.

Done when every design section maps to components, shapes, flows, UI (if any) and a reason or a
noted gap.

## Structure the page

Write in pt-BR. Code names (types, functions, files, events, UI strings quoted from the handoff) stay
exactly as in the document, in `<code>`. Source anchors such as "handoff L507" or "PRD L764" appear
only in the decisions' origin column and in the Divergências table, never in prose.

For an RFC, TDD or design doc, in this order:

1. **Header.** The document's name and one line: "o que muda". Under it, a muted line with the ticket,
   the document path and branch. No hero.
2. **Por que existe.** Two to four bullets from the Problem section.
3. **Table of contents.** One short row of links.
4. **Escolhas centrais.** The 3–5 choices the design rests on, one or two lines each.
5. **Fluxo do usuário** (optional). When the document has a user-facing flow: a step-through
   (components §3), or the state-machine explorer (§4) when the flow is a set of states.
   A major flow has branches or three or more steps. A single rule or an on/off lifecycle is not
   one: it gets a table.
6. **Arquitetura.** The interactive architecture (components §2), hand-built HTML and SVG:
   - one band per process or layer, colored by its role; one box per component (name plus at most a
     short second line);
   - every call or event is one line in the edge list, which the wires are drawn from;
   - new components carry the `is-new` mark ("novo");
   - a click on a box highlights its connections and opens its panel: what changes in it (one to
     three bullets) and the numbers of the decisions that touch it.
   Over ~20 boxes: show the layers and main components here, and give the busiest layer its own
   architecture block inside its section.
7. **One section per design piece**, in the document's order. Each has:
   - **O que muda:** two to five bullets.
   - **The UI mockup** (components §5) when the piece adds or changes UI. See "UI mockups".
   - **One interactive element** for its main flow, when it is a major flow (branches or three or
     more steps): the step-through for who calls whom over time, the state-machine explorer for
     states. A single rule or an on/off lifecycle gets the table below instead. A small branch or a secondary flow may be a static
     Mermaid diagram instead.
   - **One compact table** for states, rules, precedence or the fields of a shape (field, meaning).
     Merge small tables into one. Tag cells for states with their tone (`.tag[data-tone]`).
   - **Por quê:** one line, in the `.why` callout, only when the document gives a reason. No reason
     in the document: no line. Never invent one or write filler such as "a RFC não dá razão".
8. **Decisões.** The expandable list (components §6): number, decision and origin visible, the reason
   on expand ("—" when the document gives none), a filter by origin kind. Only the explicit decisions
   from step 3.
   **Divergências** (optional, right after Decisões): a compact table with the columns source, what it
   says and what the document does. Omit it when the document has no divergence from its sources.
9. **Critérios de aceite.** A short bullet list.
10. **Limites e fora do escopo.** Non-goals, known limits, follow-ups and open questions (marked as
    open), as bullets.

Omit the success metrics section.

For an ADR, shrink to: header, context (two to four bullets), the decision, consequences (good and
bad), a diagram if one helps, and the alternatives rejected with the reason.

Combine sections only when two design pieces are one mechanism. Never drop one.

**Size:** about 60% of the document's visible words or less (markup, CSS and JS do not count),
scannable in about 10 minutes.

## What to omit

- Code blocks and exact signatures. Name the type and describe its fields in a table instead.
- Run phases, task order, file-by-file change lists and effort estimates. They belong to the Junji
  plan, not the design.
- Test strategy detail. One muted line at the end is enough, when the document has one.
- Success metrics.
- Anything the document does not say. No invented components, arrows, reasons or origins.

## Visual language

The page is calm and a little playful. Color codes meaning; it never decorates.

- **Palette.** Near-black ink on off-white paper, three grays (line, muted, soft text) and five
  pastels with fixed roles. Exact values and the dark theme are in components §1.
  - Architecture: main process = blue, renderer and preload = lilac, domain = mint, engine or agent =
    peach, gateway, external service and shared code = no fill and a dashed gray border.
  - States: ready or ok = mint, active or generating = blue, waiting or idle = gray,
    partial or incomplete = peach, failed = rose. Rose appears only for failure.
  - Links, the `.why` border and focus rings are ink or gray, never a pastel.
- **Type.** Newsreader for `h1` and `h2`, Inter for the text, JetBrains Mono for code names. Body 16px
  with line height 1.65.
- **Space.** One reading column of 780px; diagrams and mockups may widen to 1040px (`.wide`). About
  88px between sections. No cards around text: sections are separated by space, a table by thin row
  lines. The architecture bands and the mockup frame are the only filled or framed areas.
- **Mermaid** stays allowed for small secondary flows: `<pre class="mermaid">`, the library pinned to
  an exact version, Mermaid's own neutral theme, no `style`, `classDef` or fill colors.
- No hero, gradients, shadows, emoji, icons in text, or card grids of big numbers.
- Follow the Artifact tool's page contract (title, theme tokens, dark mode, viewport, gutters,
  allowed CDNs). Do not restate it; apply it. Where the generic design guidance and this section
  differ on taste, this section wins.

## Interactivity

Interaction helps the reader see structure. It is never a show.

- **How much.** One interactive architecture, one interactive element per major flow, the mockups and
  the decision list. Nothing else moves.
- **Complete at rest.** Without a click, the page shows every component, every connection (the edge
  list), every step, every state and transition, and every decision with its origin. An interaction
  may only filter, highlight, or open the elaboration of something visible: a component's panel, a
  decision's reason, another state of a mockup whose states the section's table also lists.
- **Motion.** Only short opacity and color transitions (150ms). All of it is off under
  `prefers-reduced-motion`.
- **Access.** Every control is a `<button>` or `<summary>` with a visible focus ring, `aria-pressed`
  or `aria-selected` where it toggles, and Escape clears a selection.
- **Phone.** It works at 360px wide: bands wrap, wires redraw on resize, tables scroll inside `.tw`,
  and taps do everything hovers would.
- **Code.** Vanilla JS, inline, from components.md. A library from the allowed CDNs only if a
  pattern there truly cannot do the job, pinned to an exact version. No storage and no runtime
  capabilities.

## UI mockups

When the document adds or changes UI, the section shows a lightweight HTML and CSS mockup of it.

- Neutral and close to the product: the gray scale, the state dots, plain buttons and inputs from
  components §5. Not a pixel copy and not a new visual style.
- Use the strings the document quotes, exactly. Do not invent labels: a part the document does not
  name stays a gray placeholder bar.
- The mockup has one tab per scenario of the screen (for example "gerando", "falhou", "edição"),
  not one per row state. When one list mixes states, the states are rows inside a scenario, and the
  section's table lists them.
- The caption carries the `ilustrativo` tag and, when the document pins one, the source: "fonte:
  handoff" or "fonte: protótipo", with the link when the document gives one.
- Draw only surfaces the document describes. No mockup for a design without UI.

## Publish

1. New page: call the Artifact tool with `action: "quickstart"`, `intent: "other"`, and follow what it
   returns. An update to a page from this session skips it.
2. Write the HTML to the scratchpad, named after the document (for example `rfc4-resumo.html`). Keep
   the same path for every later version so the URL stays the same. For a page from an earlier
   session, pass its `url` and read it first, as the Artifact tool requires.
3. Run the checklist below. Fix every miss before publishing.
4. Publish with `file_path`, a short generic `icon` (for example `diagram`) and a one-sentence
   `description` in pt-BR.
5. When the epic has a `handoff.md` in the Brain, add one line under "Locais":
   `- Artefato <doc>: <url> (<date>)`. Write only under `Agent/` (see the `brain` skill).
6. Report in one line: the URL, the open questions count, and each design section whose reason the
   document does not give, as a gap in the document. Do not repeat the content in chat.

When the document changes after a debate, edit the same file and publish again to the same URL.

## Checklist before publishing

- [ ] Every design section of the document appears, by name or merged with its twin.
- [ ] The architecture diagram shows every component the document adds or changes, in its layer.
- [ ] The decisions list holds only explicit decisions, each with an origin from the list (both origins
      in one row when there are two) and a reason, or "—" when the document gives none.
- [ ] Each "Por quê" traces to a reason in the document; sections and decisions with none have no
      line (or "—") and are listed as gaps in the report.
- [ ] No code block, no exact signature, no run phase, no success metrics.
- [ ] Source anchors appear only in the origin column and the Divergências table, never in prose.
- [ ] No Mermaid fill, `style` or `classDef` color.
- [ ] The tokens, fonts and classes are the ones in components.md; pastels follow their roles and rose
      appears only for failure.
- [ ] The architecture is the interactive pattern: every component in a band of its layer, every
      new one marked, every connection in the edge list, and each box's panel names what changes and
      which decisions touch it.
- [ ] Each major flow (branches or three or more steps) has one step-through or state explorer, and
      its steps match the document. A single rule or on/off lifecycle has a table.
- [ ] Each piece that adds or changes UI has a mockup tagged `ilustrativo`, with the document's
      strings, one tab per scenario of the screen, and its source when one is pinned.
- [ ] At rest, with no click, every component, connection, step, state and decision is visible.
- [ ] Every control works by keyboard and by tap; Escape clears a selection; motion stops under
      `prefers-reduced-motion`.
- [ ] No storage, no runtime capability, no unpinned or off-list script.
- [ ] Code names match the document character for character.
- [ ] Nothing is invented: each claim traces to a line of the document.
- [ ] Each diagram matches the text next to it (same names, same order, same branches).
- [ ] The page is about 60% of the document's visible words or less.
- [ ] The Artifact page contract holds: both themes readable, no horizontal page scroll at 360px.
- [ ] The page was opened in a browser (Playwright, when available) in both themes and at 360px, each
      interaction was clicked once, and the console has no error.

## Done when

- The page is published and the report line is sent.
- The checklist passes.
- A reader who knows the codebase can say, from the page alone, which components change, who talks to
  whom, which states and contracts are new, how the main flows run, what the new UI looks like, and
  why each decision was taken.
- The URL is in the epic's `handoff.md`, when one exists.
