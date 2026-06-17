#!/usr/bin/env bash
# Guard for the /fs-pr-listen loop. Cheap, no model.
# Decides whether the agent should wake up and do work on a PR.
#
# Usage: fs-pr-listen-check.sh [PR_NUMBER]
#   With no argument, resolves the PR from the current branch.
#
# The "owner" login (whose @agent: comments drive RESOLVE) is read from the
# FS_AGENT_LOGIN env var, falling back to "vmarcosp". owner/repo are resolved
# dynamically from the current repo, so this script is repo-agnostic.
#
# This guard runs while the PR is READY (the post-ready adjustment watch). It
# handles ADJUSTMENTS only — merge approval (@agent: lgtm / pr approved) belongs
# to /fs-loop's own guard (fs-loop-check.sh), NOT here, so those phrases are
# excluded from RESOLVE below.
#
# Prints one of these verdicts on the FIRST line:
#   MERGED            PR was merged; the loop should stop.
#   CLOSED            PR was closed unmerged; the loop should stop.
#   NO_NEW            No adjustment comments to work; nothing to do.
#   RESOLVE           There are @agent: adjustment comments from the owner; a JSON array follows on line 2.
#   FEEDBACK          There are unresolved inline comments from reviewers (not the owner); a JSON array follows on line 2.
#
# Priority: RESOLVE (agent-tagged) beats FEEDBACK (human review) — handle @agent: first.
#
# A comment counts as RESOLVE when its body starts with "@agent:", is NOT a
# merge-approval phrase (lgtm / pr approved — those are /fs-loop's), and:
#   - inline review thread: the thread is NOT resolved, OR
#   - general issue comment: any such @agent: comment (the loop relies on
#     /pr-agent not re-treating what it already replied to).
#
# A comment counts as FEEDBACK when:
#   - it is an INLINE review-thread comment (third-party root-conversation
#     comments are intentionally ignored — real review lands on the diff),
#   - the author is NOT the owner AND NOT a bot (login ending in [bot]),
#   - the thread is unresolved.

set -euo pipefail

PR="${1:-}"
AUTHOR_LOGIN="${FS_AGENT_LOGIN:-vmarcosp}"

# Merge-approval phrases belong to /fs-loop, not this adjustment watch. A body
# matching this (case-insensitive) is dropped from RESOLVE. MUST be byte-for-byte
# the same pattern as MERGE_RE in fs-loop-check.sh — both [[:space:]] (not a
# literal space) so tabs/multiple spaces match identically in grep-ERE and jq.
MERGE_RE='^@agent:[[:space:]]*((pr[[:space:]]+)?(approved|aprovad[oa])|lgtm)'

if [[ -z "$PR" ]]; then
  PR="$(gh pr view --json number -q .number 2>/dev/null || true)"
fi

if [[ -z "$PR" ]]; then
  echo "NO_NEW"
  echo "# no PR for the current branch" >&2
  exit 0
fi

# 1. Terminal states stop the loop. If gh fails (auth/network), $state is empty
#    — warn so a transient outage isn't silently read as "PR still open".
state="$(gh pr view "$PR" --json state -q .state 2>/dev/null || echo "")"
if [[ -z "$state" ]]; then
  echo "# WARNING: could not read PR #$PR state (gh failed?) — treating as live; will retry next tick." >&2
fi
case "$state" in
  MERGED) echo "MERGED"; exit 0 ;;
  CLOSED) echo "CLOSED"; exit 0 ;;
esac

owner_repo="$(gh repo view --json owner,name -q '.owner.login + "/" + .name')"
owner="${owner_repo%/*}"
repo="${owner_repo#*/}"

# #4 — the review-thread queries below fetch first:100 threads / first:50
# comments without paging. On a very long PR that silently drops comments,
# which would read as "nothing pending". Warn (stderr) if we're at the boundary
# so a missed comment isn't mistaken for a clean PR.
thread_total="$(gh api graphql -f query='
  query($owner:String!, $repo:String!, $pr:Int!) {
    repository(owner:$owner, name:$repo) {
      pullRequest(number:$pr) { reviewThreads { totalCount } }
    }
  }' -F owner="$owner" -F repo="$repo" -F pr="$PR" \
  --jq '.data.repository.pullRequest.reviewThreads.totalCount' 2>/dev/null || echo 0)"
if [[ "$thread_total" -gt 100 ]]; then
  echo "# WARNING: $thread_total review threads — only the first 100 are scanned; some comments may be missed." >&2
fi

# 2. Unresolved inline review-thread comments starting with @agent: from the owner.
inline_agent="$(gh api graphql -f query='
  query($owner:String!, $repo:String!, $pr:Int!) {
    repository(owner:$owner, name:$repo) {
      pullRequest(number:$pr) {
        reviewThreads(first:100) {
          nodes {
            isResolved
            comments(first:50) {
              nodes { databaseId path line body author { login } }
            }
          }
        }
      }
    }
  }' -F owner="$owner" -F repo="$repo" -F pr="$PR" --jq --arg me "$AUTHOR_LOGIN" --arg merge "$MERGE_RE" '
    [ .data.repository.pullRequest.reviewThreads.nodes[]
      | select(.isResolved == false)
      | .comments.nodes[]
      | select(.author.login == $me and (.body | startswith("@agent:")))
      | select(.body | test($merge; "i") | not)
      | { id: .databaseId, kind: "inline", path: .path, line: .line, body: .body } ]
  ' 2>/dev/null || echo "[]")"

# 3. General PR conversation comments starting with @agent: from the owner,
#    excluding merge-approval phrases (those drive /fs-loop, not this watch).
general_agent="$(gh api "repos/$owner/$repo/issues/$PR/comments" --jq --arg me "$AUTHOR_LOGIN" --arg merge "$MERGE_RE" '
    [ .[]
      | select(.user.login == $me and (.body | startswith("@agent:")))
      | select(.body | test($merge; "i") | not)
      | { id: .id, kind: "general", path: null, line: null, body: .body } ]
  ' 2>/dev/null || echo "[]")"

combined_agent="$(jq -n --argjson a "$inline_agent" --argjson b "$general_agent" '$a + $b')"
agent_count="$(jq 'length' <<<"$combined_agent")"

# 4. Unresolved inline review-thread comments from third-party reviewers (not the owner, not bots).
inline_feedback="$(gh api graphql -f query='
  query($owner:String!, $repo:String!, $pr:Int!) {
    repository(owner:$owner, name:$repo) {
      pullRequest(number:$pr) {
        reviewThreads(first:100) {
          nodes {
            isResolved
            comments(first:50) {
              nodes { databaseId path line body author { login } }
            }
          }
        }
      }
    }
  }' -F owner="$owner" -F repo="$repo" -F pr="$PR" --jq --arg me "$AUTHOR_LOGIN" '
    [ .data.repository.pullRequest.reviewThreads.nodes[]
      | select(.isResolved == false)
      | .comments.nodes[]
      | select(
          .author.login != $me
          and (.author.login | endswith("[bot]") | not)
        )
      | { id: .databaseId, kind: "inline", path: .path, line: .line, body: .body, author: .author.login } ]
  ' 2>/dev/null || echo "[]")"

# 5. (Intentionally no general third-party comments.) Root-conversation comments
#    from reviewers don't trigger the watch — real review lands on the diff as
#    inline threads. Only inline_feedback (unresolved) counts.
combined_feedback="$inline_feedback"
feedback_count="$(jq 'length' <<<"$combined_feedback")"

# Priority: @agent: (RESOLVE) first, then third-party review (FEEDBACK).
if [[ "$agent_count" -gt 0 ]]; then
  echo "RESOLVE"
  echo "$combined_agent"
  exit 0
fi

if [[ "$feedback_count" -gt 0 ]]; then
  echo "FEEDBACK"
  echo "$combined_feedback"
  exit 0
fi

echo "NO_NEW"
