# One skill, progressive verb disclosure

junji stays **one model-invoked skill with nine verbs**, not nine skills. Verb bodies live under `verbs/`;
scaffolds under `templates/`; `references/` stays thin (today: `autonomous-driver.md` only). Grilling SSOT
is `verbs/grill.md` (shared by `plan`, `design`, `iterate`, and the `grill` verb). Research SSOT is `verbs/research.md`.
Design SSOT is `verbs/design.md` (method ADR-0003). Skill scout / `CONTEXT.md › Skills` is method
ADR-0006. Iterate SSOT is `verbs/iterate.md` (method ADR-0005). Begin copies METHOD/BACKLOG
and authors CONTEXT only (method ADR-0007).

**Rejected: one skill per verb** — each verb as its own skill would multiply always-on descriptions, fragment
`/junji` / Next-action dispatch, and break the method as one pipeline. **Rejected: monolith SKILL.md** —
loading every verb on every invocation wasted context. Progressive disclosure by branch keeps shared
contract + dispatch in `SKILL.md` and loads only the active verb.
