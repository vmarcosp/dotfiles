#!/usr/bin/env bash
# Parse an /epic markdown into the task queue for a .loop.json control file.
#
# Reads the epic's stream section — lines of the form:
#   - [ ] FSPG-764 — <title> → <spec-path>  ·  depends_on: [FSPG-..., ...]
# and emits a JSON array of { id, deps } on stdout. The skill body wraps this
# into the full .loop.json (adding status/pr) and reconciles against any
# existing file.
#
# Usage: parse-epic.sh <path-to-epic.md>
# Output (stdout): JSON array, e.g. [{"id":"FSPG-764","deps":[]}, ...]

set -euo pipefail

EPIC="${1:-}"
if [[ -z "$EPIC" || ! -f "$EPIC" ]]; then
  echo "usage: parse-epic.sh <path-to-epic.md>" >&2
  exit 1
fi

# A task line starts with a checkbox and carries an ID and a depends_on clause.
# We accept both unchecked "[ ]" and checked "[x]" so a re-parse of a partly
# done epic still lists every task. The ID is the first token after the box;
# deps come from the bracketed list after "depends_on:".
#
# grep pulls candidate lines; the awk/sed pipeline extracts id + deps and emits
# one compact JSON object per line; jq -s slurps them into an array.

# Checkbox accepts any whitespace inside the brackets ("[ ]", "[  ]", "[x]").
grep -E '^[[:space:]]*-[[:space:]]*\[[[:space:]xX]*\][[:space:]]+[A-Za-z]+-[0-9]+' "$EPIC" | while IFS= read -r line; do
  # ID: first <LETTERS>-<DIGITS> token on the line.
  id="$(printf '%s\n' "$line" | grep -oE '[A-Za-z]+-[0-9]+' | head -1)"

  # deps: contents of the [...] right after "depends_on:". Empty list → [].
  # Use [[:space:]] (not \s) — BSD sed/grep on macOS doesn't grok \s.
  deps_raw="$(printf '%s\n' "$line" | sed -nE 's/.*depends_on:[[:space:]]*\[([^]]*)\].*/\1/p')"

  if [[ -z "$deps_raw" ]]; then
    deps_json="[]"
  else
    # Split on commas, trim, keep only ID-shaped tokens, re-emit as JSON array.
    deps_json="$(printf '%s\n' "$deps_raw" \
      | tr ',' '\n' \
      | grep -oE '[A-Za-z]+-[0-9]+' \
      | jq -R . | jq -s .)"
  fi

  jq -nc --arg id "$id" --argjson deps "$deps_json" '{id:$id, deps:$deps}'
done | jq -s .
