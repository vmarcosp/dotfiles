Which model a subagent gets when Marcos does not name one. He may override any row; his choice wins.
Pass it as the Agent tool's `model` (`sonnet`, `opus`, `fable`).

| Work | Model |
|---|---|
| Implement, mechanical | Sonnet |
| Implement, needs judgment | Opus |
| Review of a large PR or of a run | Fable |
| Review of a small task | Opus |
| Outside opinion on an orchestrator decision (`/deliberate`) | Opus (quick), Fable (standard), Fable + Opus (council) |
| Live QA (the repo's QA skill) | Sonnet or Opus |
| Junji begin/plan/refine, RFC writer | one named Opus, kept alive across steps |

The PR loop is the `/forge` skill: its presets (`lite`, `standard`, `heavy`) and per-role overrides set
who plans, implements, reviews (and at which level), fixes and runs QA.
