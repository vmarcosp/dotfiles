# Junji — diagrams

Mermaid renderings of three views of junji: the method **as built**, a
**loop-engineering-native** variant, and the **Build** feedback/feedforward
self-correction loop. (An interactive HTML version can be generated separately
with the `richview` skill.)

**Node colour legend**: pink = new · butter = reshaped · white = unchanged ·
mint = terminal · blush = halt.
**Edge legend (diagram 3)**: gray = control flow · solid amber = feedback
(measured error → next lap) · dotted green = feedforward (injected ahead) ·
dotted red = non-convergence.

> Rendering: GitHub, VS Code (Mermaid extension), Obsidian, and
> <https://mermaid.live> all render these. Colours come from `classDef` /
> `linkStyle`; if a viewer ignores those, the structure and labels still read.

---

## 1. Junji today

A human runs `begin → (research*|design*) → plan → refine` (markdown only; research and design optional);
A human or thin driver repeats `next`, one phase at a time, until every phase is `[done]`. Then a
human **consolidates**, or **`iterate`s** (grill + N specs, no code) and `next` again. Optional `brief`
reads `.koi/run/` and reports in chat; it writes nothing. Everything else reads and writes `.koi/`.

```mermaid
flowchart TB
    subgraph planning["Human-driven planning — markdown only, no code"]
        begin["begin<br/>scaffold + survey · Skill scout · no decisions"]
        research["research<br/>optional primary-source notes"]
        design["design<br/>optional visual contract"]
        plan["plan<br/>reason · grill · define the bar"]
        grill["grill<br/>frontier rounds, any time"]
        brief["brief<br/>chat-only product briefing"]
        refine["refine<br/>→ ordered phase list"]
        iterate["iterate<br/>optional · grill + N specs · no code"]
    end

    subgraph driver["Autonomous driver ↺ — or a human: 'do the next task'"]
        next["next<br/>run ONE phase, end to end"]
        gate{"gate?<br/>.koi/sensors/*.sh"}
    end

    consolidate["consolidate<br/>collapse → one spec"]
    spec(["✓ deliverable spec"])
    halt["HALT → human<br/>gated · broken · stall · budget"]
    store[".koi/run/ — durable memory · git<br/>PLAN · CONTEXT · DESIGN? · METHOD · BACKLOG · phases/ · researches/ · designs/"]

    begin --> plan
    begin -.-> research
    begin -.-> design
    research -.-> plan
    research -.-> grill
    design -.-> plan
    design -.-> grill
    plan -.->|"may activate"| design
    plan <-->|"grill ↺"| grill
    grill -.->|"fact gap"| research
    plan --> refine
    refine --> next
    next --> gate
    gate -->|"pass · more [todo] → loop"| next
    gate -->|"all [done]"| iterate
    iterate -->|"append [todo]"| next
    iterate -->|"or skip"| consolidate
    gate -.->|"fail · [gated]"| halt
    consolidate --> spec
    store -.->|"rehydrated each window"| next
    store -.->|"read / write"| plan
    store -.->|"read / write"| iterate
    store -.->|"read only"| brief

    classDef nTerminal fill:#C8E6D0,stroke:#9CC4A8,color:#0A0A0A;
    classDef nHalt fill:#FCEDED,stroke:#F5C2C2,color:#0A0A0A;
    classDef nPlain fill:#FFFFFF,stroke:#D6D6D6,color:#0A0A0A;
    class spec nTerminal;
    class halt nHalt;
    class begin,research,design,plan,grill,brief,refine,iterate,next,gate,consolidate,store nPlain;
```

---

## 2. Loop-engineering fit

The finite project loop becomes one turn of a perpetual loop: a scheduled scan
files findings into an inbox; promoted findings enter the unchanged planning
core; phases fan out across parallel worktrees; each is verified by the gate
**and** an independent checker; a human acks a comprehension digest; connectors
ship it: and everything, completions and escalations alike, returns to the
inbox. The objective gate stays the sole arbiter.

```mermaid
flowchart TB
    subgraph discover["① Discover — new"]
        schedule(["⏰ schedule · cron"])
        triage["discover + triage<br/>repo · CI · deps · flaky · TODO"]
        inbox["triage inbox<br/>findings queue · empty runs archived"]
    end

    subgraph planz["② Plan — unchanged"]
        plancore["planning core<br/>begin → (research*|design*) → plan → refine · markdown"]
    end

    subgraph exec["③ Execute in parallel — reshaped"]
        scheduler["phase scheduler<br/>fan out independent phases"]
        workers["parallel workers · git worktrees<br/>each runs next in isolation"]
    end

    subgraph verify["④ Verify — objective + advisory"]
        gate{"sensors/<br/>verification bar"}
        checker["verifier sub-agent<br/>diff model · audits coverage"]
    end

    subgraph deliver["⑤ Comprehend + deliver — new"]
        comprehend["comprehension checkpoint<br/>a human acks the diff digest"]
        connectors["connectors · MCP<br/>PR · ticket · Slack · merge on CI green"]
    end

    consolidate["consolidate<br/>collapse → one spec"]
    spec(["✓ spec + comprehension digest"])
    escalate["halt / escalate<br/>red · veto · stall · budget"]
    store["durable state · on disk<br/>.koi/ + triage inbox + ledger → dashboard"]

    schedule --> triage
    triage --> inbox
    inbox -->|"human promotes ✦"| plancore
    plancore -->|"phases"| scheduler
    scheduler -->|"fan out"| workers
    workers -->|"verify"| gate
    gate -->|"green"| checker
    checker -->|"advisory ✓"| comprehend
    comprehend --> connectors
    connectors -->|"continuous loop ↺ · re-scan"| inbox
    connectors -->|"all [done] · complete"| consolidate
    consolidate --> spec
    gate -.->|"red"| escalate
    checker -.->|"veto"| escalate
    escalate -.->|"re-file as finding"| inbox
    store -.->|"read / write"| plancore
    store -.->|"read / write"| workers

    classDef nNew fill:#FDE7EE,stroke:#F8C8D8,color:#0A0A0A;
    classDef nChanged fill:#FCF3D6,stroke:#E9CE84,color:#0A0A0A;
    classDef nTerminal fill:#C8E6D0,stroke:#9CC4A8,color:#0A0A0A;
    classDef nHalt fill:#FCEDED,stroke:#F5C2C2,color:#0A0A0A;
    classDef nPlain fill:#FFFFFF,stroke:#D6D6D6,color:#0A0A0A;
    class schedule,triage,inbox,checker,comprehend,connectors nNew;
    class scheduler,workers nChanged;
    class spec nTerminal;
    class escalate nHalt;
    class plancore,gate,consolidate,store nPlain;

    linkStyle 9 stroke:#9CC4A8,stroke-width:2px;
    linkStyle 12,13,14 stroke:#C84B4B,stroke-width:1.5px;
```

---

## 3. Build — the feedback / feedforward loop inside a phase

The 3-act path (Plan → Build → Seal) the driver runs per phase. Act 2 is
a closed control loop. **Feedback** (amber): gate-red and judge-veto findings go
to `FEEDBACK.md` and feed the next lap. **Feedforward** (dotted green): the phase
plan (setpoint) and the recovery guide are injected *ahead* of the coder. The
gate is the authoritative sensor (grants convergence); the judge is advisory (can
veto, never grant).

```mermaid
flowchart TB
    subgraph act1["Act 1 · Plan — fresh window"]
        planAct["Plan<br/>steps 1–3 · write phase plan, stop"]
        phasePlan["phase-NN.md<br/>the setpoint"]
    end

    subgraph act2["Act 2 · Build — converges · steps 4–5"]
        coder["coder turn<br/>implement this phase"]
        gate{"gate<br/>authoritative"}
        judge["judge<br/>advisory · read-only review"]
        feedback["FEEDBACK.md<br/>discrepancies → next lap"]
        guide["triage guide<br/>recovery · diagnosis"]
        haltN["halt before Seal<br/>FEEDBACK.md left for a human"]
    end

    subgraph act3["Act 3 · Seal — fresh window"]
        seal["Seal<br/>steps 6–7 · compact + commit"]
        committed(["✓ phase [done] · one commit"])
    end

    planAct -->|"writes"| phasePlan
    phasePlan -.->|"feedforward · setpoint"| coder
    guide -.->|"feedforward · guide"| coder
    coder -->|"output"| gate
    gate -->|"green → review"| judge
    gate -->|"gate red"| feedback
    judge -->|"judge veto"| feedback
    judge -->|"green ∧ no veto → converged"| seal
    feedback -->|"feedback ↺ re-run coder"| coder
    feedback -.->|"triage reads · opt-in"| guide
    feedback -.->|"budget spent / can't converge"| haltN
    seal --> committed

    classDef nTerminal fill:#C8E6D0,stroke:#9CC4A8,color:#0A0A0A;
    classDef nHalt fill:#FCEDED,stroke:#F5C2C2,color:#0A0A0A;
    classDef nPlain fill:#FFFFFF,stroke:#D6D6D6,color:#0A0A0A;
    class committed nTerminal;
    class haltN nHalt;
    class planAct,phasePlan,coder,gate,judge,feedback,guide,seal nPlain;

    linkStyle 1,2 stroke:#4E9C86,stroke-width:1.6px;
    linkStyle 5,6,8 stroke:#C7A14B,stroke-width:1.6px;
    linkStyle 9 stroke:#C7A14B,stroke-width:1.4px;
    linkStyle 10 stroke:#C84B4B,stroke-width:1.5px;
```

---

*Sources: `skills/junji/SKILL.md`, [the Junji guide](https://github.com/getkoi/site/blob/main/src/content/docs/junji/guide.mdx),
`skills/junji/references/autonomous-driver.md`, and Addy Osmani's "Loop
engineering" (addyosmani.com/blog/loop-engineering).*
