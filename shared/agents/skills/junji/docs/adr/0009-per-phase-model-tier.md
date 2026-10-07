# Per-phase model tier

Status: amended by [framework ADR-0007](https://github.com/getkoi/koi/blob/main/docs/adr/0007-independent-junji-and-yokai-setup.md): fresh method headings no longer require tiers; legacy tags remain supported. Driver pairing: yokai ADR-0049. Amends refine / iterate heading
contract (ADR-0005) and the BACKLOG grammar.

`refine` and `iterate` write exactly one **tier** tag on every phase heading:
`[low]`, `[medium]`, `[high]`, or `[ultra]`, after the strategy tag and before
status. The tag names how demanding the phase is, not which Agent or Model to
run. Missing tag is `[medium]`. Interactive `/junji next` keeps the tag when
rewriting status and does not switch the human's Agent or Model — yokai honors
the band.

Default **medium**. Do not tag ultra unless the phase is the hardest work in the
plan and cannot be split. Do not tag low unless it is mechanical.

- **[low]** — mechanical or file-heavy, little design: scaffolds, boilerplate,
  rename/move, copy a known pattern, fill an obvious template. Short, local.
- **[medium]** — ordinary implementation: one feature or module, tests, a normal
  bugfix, scripts, typical tool use. When unsure, stay here.
- **[high]** — sustained hard engineering in one phase: large refactor,
  cross-module invariants, long Build, vision-heavy or computer-use work. Step
  up from medium only when that bar is clearly met.
- **[ultra]** — rare. Hours of autonomous work that must finish as one phase:
  deep research carried to a finished artifact, or the single hardest
  design/implementation slice. Prefer splitting over tagging ultra.
