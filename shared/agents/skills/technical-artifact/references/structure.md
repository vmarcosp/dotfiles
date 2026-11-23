# Page skeleton

The order of an RFC, TDD or design doc page. Headings are in pt-BR as on the page. Each table shows
one example row. Placeholders are in `<angle brackets>`. "§n" points to `components.md`.

## Header

- `<h1>`: `<Document name>`
- `.lede`: `<o que muda, in one sentence>`
- `.meta`: `<ticket> · <document path> · <branch>`
- One row of layer tags as the legend: `Main process · Renderer · Domínio · Engine · Externo`, each
  `.tag` in its band color. No hero.

## Por que existe

- `<problem bullet, 2 to 4>`

## Índice

`Escolhas centrais · Fluxo · Arquitetura · <one link per design piece> · Decisões · Critérios · Limites`
(add `Divergências` after `Decisões` when the section exists)

## Escolhas centrais

1. **`<choice>`.** `<one or two lines>`

## Fluxo do usuário (optional)

Step-through (§3) of the document's user-facing flow, or the state explorer (§4) when it is a set of
states.

## Arquitetura

Interactive architecture (§2), `.wide`:

- one `.band[data-layer]` per layer: `main`, `renderer`, `preload`, `domain`, `engine`, `external`;
- one `.node` per component, `is-new` when the document adds it;
- `.edges`: one `<li>` per call or event, `<b>A</b> → <b>B</b>: <what flows>`;
- one `<template data-for>` per component: what changes (1 to 3 bullets) and `Decisões: <n, n>`.

Over ~20 boxes: layers and main components here, the busiest layer again inside its section.

## `<Design piece>` (one per design section)

**O que muda**

- `<2 to 5 bullets>`

Mockup (§5), when the piece adds or changes UI: caption `ilustrativo · fonte: <handoff | protótipo>`,
one tab per scenario of the screen (for example `gerando`, `falhou`, `edição`), not per row state,
strings quoted from the document.

One interactive element for the main flow when it is a major one (branches or three or more steps):
step-through (§3) or state explorer (§4). A single rule or an on/off lifecycle gets the table only.
A secondary flow may be a static `<pre class="mermaid">` with no colors.

| Campo / Estado / Regra | Significado |
|---|---|
| `failed` (`.tag[data-tone=fail]`) | `a página do FailedPage; só em memória` |

**Por quê:** `<one line in .why, only when the document gives a reason>`

## Decisões

Decision list (§6): one `<details data-kind>` per decision.

| # | Decisão | Origem | Razão (on expand) |
|---|---|---|---|
| 1 | `<decision>` | `regra (PRD L764)` | `<reason>` |

Origins: `Marcos`, `regra (fonte, linha)`, `orquestrador (revisável)`, `revisor (Fable)`,
`revisor (Opus)`, `autor` (only when the document says so). `data-kind` is the first word:
`Marcos`, `regra`, `orquestrador`, `revisor`, `autor`.

Two origins are one row with both listed, such as `Marcos + orquestrador (revisável)`; `data-kind` is
the first. No reason in the document: the reason is "—" and the gap goes in the report. Never
paraphrase a nearby fact as the reason.

## Divergências (optional)

Only when the document diverges from its sources. Omit the section otherwise. Source anchors may
appear here.

| Fonte | O que diz | O que o doc faz |
|---|---|---|
| `handoff L388` | `<what the source says>` | `<what the document does instead>` |

## Critérios de aceite

- `<short bullet>`

## Limites e fora do escopo

- `<non-goal, known limit, follow-up>`
- `<open question>` with `.tag` `em aberto`

`.meta` line, when the document has a test strategy: `Testes: <one line>`.

## ADR variant

Header · Contexto (2 to 4 bullets) · Decisão · Consequências (boas e ruins) · a small interactive
architecture or one step-through only if it helps · Alternativas rejeitadas (alternative, reason).
Same tokens and type.
