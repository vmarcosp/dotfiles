Which model a subagent gets when Marcos does not name one. He may override any row; his choice wins.
Pass it as the Agent tool's `model` (`sonnet`, `opus`, `fable`).

| Work | Model |
|---|---|
| Implement, mechanical | Sonnet |
| Implement, needs judgment | Opus |
| Review of a large PR or of a run | Fable |
| Review of a small task | Opus |
| Second opinion on an orchestrator decision (`/second-opinion`) | Fable |
| Live QA (repo's QA skill, e.g. `studio-qa`) | Sonnet or Opus |
| Junji begin/plan/refine, RFC writer | one named Opus, kept alive across steps |

The PR loop (Sonnet implements → Opus reviews once → Sonnet fixes) is the `/pr-loop` skill.
