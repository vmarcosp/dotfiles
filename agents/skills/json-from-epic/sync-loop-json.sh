#!/usr/bin/env bash
# Generate or reconcile a .loop.json control file from an /epic markdown.
#
# Idempotent: a first run creates the file with every task pending; a re-run
# adds new tasks, refreshes deps, and PRESERVES existing status/pr/runtime.
# A task already merged/ready/in_progress is never downgraded to pending.
#
# Usage: sync-loop-json.sh <path-to-epic.md>
#   The control file is written beside the epic: <epic-dir>/<epic-stem>.loop.json
#   On success, prints a one-line summary of the resulting status counts.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EPIC="${1:-}"
if [[ -z "$EPIC" || ! -f "$EPIC" ]]; then
  echo "usage: sync-loop-json.sh <path-to-epic.md>" >&2
  exit 1
fi

epic_dir="$(cd "$(dirname "$EPIC")" && pwd)"
epic_stem="$(basename "$EPIC" .md)"
out="$epic_dir/$epic_stem.loop.json"

# Parsed queue from the epic: [{id, deps}, ...].
parsed="$(bash "$HERE/parse-epic.sh" "$EPIC")"

# Task IDs present before this run (empty if the file is new) — used to report
# tasks the epic dropped, which may have carried state.
prev_ids="$(jq -r '[.tasks[]?.id] // [] | join(",")' "$out" 2>/dev/null || echo "")"

if [[ ! -f "$out" ]]; then
  # Fresh file: every task pending, no PR.
  jq -n --arg epic "$epic_stem" --argjson parsed "$parsed" '
    { epic: $epic, base: "main",
      tasks: ($parsed | map({ id, deps, status: "pending", pr: null })) }
  ' > "$out"
else
  # Reconcile against the existing file. For each parsed task, keep its prior
  # status/pr/runtime if present; otherwise seed it as pending. Tasks dropped
  # from the epic are dropped here too (the epic is the source of truth for
  # which tasks exist), but their absence is reported by the skill body.
  jq -n \
    --arg epic "$epic_stem" \
    --argjson parsed "$parsed" \
    --slurpfile prev "$out" '
    ($prev[0].tasks // []) as $old
    | { epic: $epic,
        base: ($prev[0].base // "main"),
        tasks: ($parsed | map(
          . as $p
          | ($old[] | select(.id == $p.id)) // {} as $o
          | { id: $p.id,
              deps: $p.deps,
              status: ($o.status // "pending"),
              pr: ($o.pr // null) }
            + (if $o.runtime then { runtime: $o.runtime } else {} end)
        )) }
  ' > "$out.tmp" && mv "$out.tmp" "$out"
fi

# Audit: warn about tasks the epic dropped (present before, gone now — may have
# carried state) and about deps that reference a non-existent task (would block
# the queue forever, silently).
now_ids="$(jq -r '[.tasks[].id] | join(",")' "$out")"
if [[ -n "$prev_ids" ]]; then
  dropped="$(comm -23 <(echo "$prev_ids" | tr ',' '\n' | sort) \
                       <(echo "$now_ids" | tr ',' '\n' | sort) | paste -sd, -)"
  if [[ -n "$dropped" ]]; then
    echo "# WARNING: tasks removed from the epic (state lost): $dropped" >&2
  fi
fi

missing_deps="$(jq -rn --slurpfile cur "$out" '
  [ $cur[0].tasks[].id ] as $ids
  | [ $cur[0].tasks[]
      | .id as $tid | .deps[]
      | select(. as $d | $ids | index($d) | not)
      | "\($tid)→\(.)" ] | join(", ")' 2>/dev/null || echo "")"
if [[ -n "$missing_deps" ]]; then
  echo "# WARNING: deps referencing non-existent tasks (these block forever): $missing_deps" >&2
fi

# One-line audit summary.
jq -r --arg out "$out" '
  .tasks as $t
  | "\($t | length) tasks → "
    + ([ "pending","in_progress","ready","merged" ]
       | map(. as $s | "\($s)=\([ $t[] | select(.status==$s) ] | length)")
       | join(" "))
    + "  ·  \($out)"
' "$out"
