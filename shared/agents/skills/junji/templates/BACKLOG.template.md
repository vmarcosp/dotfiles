# Backlog

**Reference: position.** Next action, phase list, carry-forward. Compacted as phases complete.

**Next action:** `/junji plan`

See `.koi/run/CONTEXT.md` (facts / bar), `.koi/run/PLAN.md` (why), and `.koi/run/METHOD.md` (the
"do the next task" protocol).

Status tags (exactly one per heading): `[todo]` `[planning]` `[building]` `[sealing]` `[done]`.
Ordinary heading: `### [todo] P0 - Title`. Optional `[gated]` comes before status for destructive,
irreversible, or human-decision phases. Legacy strategy/tier annotations remain supported and must
be preserved when present; they are not required. Runtime execution choices belong to Yokai.

## Carry-forward decisions

_Non-obvious facts later phases depend on: populated as phases land. Keep this current; it is the memory a
fresh window inherits. Examples of what belongs here:_

- _Environment gotchas that cost real time (toolchain/PATH quirks, shell/CLI traps, where a tool writes its
  output)._
- _Architectural facts discovered mid-flight (asymmetries between the old and new paths, hidden coupling)._
- _Chosen versions / crates / library API quirks._
- _Standing overrides (also mirrored in CONTEXT)._

_(empty at begin)_

## Tasks

Empty after `begin`. `refine` writes the ordered phase list here: heading shape is in the refine verb.
