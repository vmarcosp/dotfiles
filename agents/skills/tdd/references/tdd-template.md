# {System, Subsystem, or Component Name}

> **Mode**: {As-Is | To-Be}
> **Last updated**: {date}

## Overview

{One paragraph: what the system does, who/what it serves, its boundary — what's inside vs outside this document's scope.}

## System Context

{How this system relates to actors and external systems. Mermaid `flowchart` or `C4Context`-style diagram.}

```mermaid
flowchart LR
    User -->|request| System[This System]
    System -->|calls| ExternalA[External Service A]
    System -->|reads/writes| DB[(Data Store)]
```

## Building Blocks

{Every component/service/module with a one-line responsibility. One row each — no prose padding.}

| Component | Responsibility | Owns |
|---|---|---|
| {Component} | {What it does, one line} | {Data/resource it owns, if any} |

```mermaid
flowchart TB
    subgraph System
        A[Component A] --> B[Component B]
        B --> C[Component C]
    end
```

## Key Flows

{One subsection per flow that matters — the ones a reader needs to understand the system, not every possible path.}

### {Flow Name}

{One-paragraph walkthrough, then the diagram.}

```mermaid
sequenceDiagram
    participant U as User
    participant A as Component A
    participant B as Component B
    U->>A: {action}
    A->>B: {call}
    B-->>A: {response}
    A-->>U: {result}
```

## Data Model

{Core entities and how they relate. Skip if the system has no meaningful data model of its own.}

```mermaid
erDiagram
    ENTITY_A ||--o{ ENTITY_B : has
```

## Interfaces

{APIs, events, or contracts this system exposes or consumes.}

| Interface | Direction | Contract |
|---|---|---|
| {Endpoint/event/queue} | {Exposes / Consumes} | {Shape, or link to schema} |

## Cross-Cutting Concerns

{Only what's actually relevant — deployment topology, scaling, security boundaries, observability. Omit a subsection entirely rather than writing "N/A".}

## References

{The anchor docs this design depends on — PRDs, ADRs, brainstorm convergence docs. Link, don't restate their content. If no written anchor exists and this design came from the user's own description, say so instead of leaving the table empty.}

| Doc | Why it matters here |
|---|---|
| {adr-NNNN / prd-slug / brainstorm-slug, linked} | {One line: what this design takes from it} |

## Open Questions

{Genuinely unresolved design questions only — omit this section if there are none.}
