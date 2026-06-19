#!/usr/bin/env bash
# Guard for the /fs-loop conductor. Cheap, no model. All I/O lives here so the
# loop spends no tokens parsing — it reads one verdict line and acts.
#
# Usage: fs-loop-check.sh <epic>
#   Reads specs/epics/<epic>.loop.json from the current repo.
#
# Owner login (whose @agent: lgtm / pr approved triggers a merge) comes from
# FS_AGENT_LOGIN, falling back to "vmarcosp". owner/repo are resolved from the
# current repo, so this is repo-agnostic.
#
# Verdict on the FIRST line:
#   BUSY <id>            A task is in_progress — a /fs-task session is running.
#   MERGE <id> pr=<n>    A ready (non-draft) PR has owner merge approval.
#   WAIT <id> pr=<n>     A ready PR, no merge approval yet.
#   NEXT_TASK <id>       No active task; this pending task has all deps merged.
#   DONE                 Every task is merged.
#   STALLED <detail>     Pending tasks remain but are blocked on non-merged deps.
#
# Merge approval = an owner comment matching the MERGE regex below, on a PR that
# is NOT a draft. A draft PR is the spec-gate's territory (/fs-task), never a
# merge trigger — so "lgtm" on a draft is ignored here by design.

set -euo pipefail

EPIC="${1:-}"
OWNER_LOGIN="${FS_AGENT_LOGIN:-vmarcosp}"

if [[ -z "$EPIC" ]]; then
  echo "STALLED no epic argument"
  exit 0
fi

JSON="specs/epics/$EPIC.loop.json"
if [[ ! -f "$JSON" ]]; then
  echo "STALLED control file not found: $JSON"
  exit 0
fi

# Merge-approval matcher. Normalized: case-insensitive, tolerant of spaces and
# punctuation. Accepts "lgtm", "pr approved", "pr aprovado", "aprovado",
# "approved" — the MERGE channel. Does NOT match the spec-gate words on its own
# ("spec"/"plan"), which live only in fs-pr-listen-check.sh.
#   body must start with @agent: and then carry one of the merge phrases.
MERGE_RE='^@agent:[[:space:]]*((pr[[:space:]]+)?(approved|aprovad[oa])|lgtm)'

# 1. Any task in_progress → a /fs-task session owns it.
busy="$(jq -r '[.tasks[] | select(.status=="in_progress")][0].id // empty' "$JSON")"
if [[ -n "$busy" ]]; then
  echo "BUSY $busy"
  exit 0
fi

# 2. A ready task with a PR → check for merge approval on a non-draft PR.
ready_id="$(jq -r '[.tasks[] | select(.status=="ready" and .pr!=null)][0].id // empty' "$JSON")"
ready_pr="$(jq -r '[.tasks[] | select(.status=="ready" and .pr!=null)][0].pr // empty' "$JSON")"
if [[ -n "$ready_id" && -n "$ready_pr" ]]; then
  # On gh failure default to "true" (draft) — the safe default: refuse to merge
  # on uncertainty. Warn so a transient outage isn't mistaken for "still draft".
  is_draft="$(gh pr view "$ready_pr" --json isDraft -q .isDraft 2>/dev/null || echo "ERR")"
  if [[ "$is_draft" == "ERR" ]]; then
    echo "# WARNING: could not read PR #$ready_pr draft state (gh failed?) — holding (WAIT) this tick." >&2
    is_draft="true"
  fi
  if [[ "$is_draft" == "false" ]]; then
    # Owner comments matching the merge regex — check all three sources.
    owner_repo="$(gh repo view --json owner,name -q '.owner.login + "/" + .name')"
    owner="${owner_repo%/*}"; repo="${owner_repo#*/}"
    # Source 1: root Conversation comments
    root_bodies="$(gh api "repos/$owner/$repo/issues/$ready_pr/comments" 2>/dev/null \
      | jq -r --arg me "$OWNER_LOGIN" '[ .[] | select(.user.login == $me) | .body ] | .[]' || true)"
    # Source 2: submitted review bodies
    review_bodies="$(gh api "repos/$owner/$repo/pulls/$ready_pr/reviews" 2>/dev/null \
      | jq -r --arg me "$OWNER_LOGIN" '[ .[] | select(.user.login == $me) | .body ] | .[]' || true)"
    approved="$(printf '%s\n' "$root_bodies" "$review_bodies" \
      | grep -iqE "$MERGE_RE" && echo yes || echo no)"
    if [[ "$approved" == "yes" ]]; then
      echo "MERGE $ready_id pr=$ready_pr"
      exit 0
    fi
  fi
  echo "WAIT $ready_id pr=$ready_pr"
  exit 0
fi

# 3. No active task → first pending whose deps are ALL merged.
next="$(jq -r '
  [ .tasks[] | select(.status=="merged") | .id ] as $merged
  | [ .tasks[]
      | select(.status=="pending")
      | select(.deps - $merged | length == 0) ][0].id // empty
' "$JSON")"
if [[ -n "$next" ]]; then
  echo "NEXT_TASK $next"
  exit 0
fi

# 4. Everything merged → done.
all_merged="$(jq -r '[.tasks[] | select(.status!="merged")] | length' "$JSON")"
if [[ "$all_merged" == "0" ]]; then
  echo "DONE"
  exit 0
fi

# 5. Pending tasks remain but none is eligible → blocked on deps.
blocked="$(jq -r '[.tasks[] | select(.status=="pending") | .id] | join(",")' "$JSON")"
echo "STALLED blocked: $blocked"
