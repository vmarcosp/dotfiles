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
# Prints one of these verdicts on the FIRST line:
#   MERGED            PR was merged; the loop should stop.
#   CLOSED            PR was closed unmerged; the loop should stop.
#   NO_NEW            No unresolved @agent: comments and no third-party comments; nothing to do.
#   RESOLVE           There are @agent: comments from the owner; a JSON array follows on line 2.
#   FEEDBACK          There are unresolved comments from reviewers (not the owner); a JSON array follows on line 2.
#
# Priority: RESOLVE (agent-tagged) beats FEEDBACK (human review) — handle @agent: first.
#
# A comment counts as RESOLVE when its body starts with "@agent:" and:
#   - inline review thread: the thread is NOT resolved, OR
#   - general issue comment: any @agent: comment (the loop relies on
#     /pr-agent not re-treating what it already replied to).
#
# A comment counts as FEEDBACK when:
#   - the author is NOT the owner AND NOT a bot (login ending in [bot]),
#   - the thread is unresolved (for inline threads).

set -euo pipefail

PR="${1:-}"
AUTHOR_LOGIN="${FS_AGENT_LOGIN:-vmarcosp}"

if [[ -z "$PR" ]]; then
  PR="$(gh pr view --json number -q .number 2>/dev/null || true)"
fi

if [[ -z "$PR" ]]; then
  echo "NO_NEW"
  echo "# no PR for the current branch" >&2
  exit 0
fi

# 1. Terminal states stop the loop.
state="$(gh pr view "$PR" --json state -q .state 2>/dev/null || echo "")"
case "$state" in
  MERGED) echo "MERGED"; exit 0 ;;
  CLOSED) echo "CLOSED"; exit 0 ;;
esac

owner_repo="$(gh repo view --json owner,name -q '.owner.login + "/" + .name')"
owner="${owner_repo%/*}"
repo="${owner_repo#*/}"

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
  }' -F owner="$owner" -F repo="$repo" -F pr="$PR" --jq --arg me "$AUTHOR_LOGIN" '
    [ .data.repository.pullRequest.reviewThreads.nodes[]
      | select(.isResolved == false)
      | .comments.nodes[]
      | select(.author.login == $me and (.body | startswith("@agent:")))
      | { id: .databaseId, kind: "inline", path: .path, line: .line, body: .body } ]
  ' 2>/dev/null || echo "[]")"

# 3. General PR conversation comments starting with @agent: from the owner.
general_agent="$(gh api "repos/$owner/$repo/issues/$PR/comments" --jq --arg me "$AUTHOR_LOGIN" '
    [ .[]
      | select(.user.login == $me and (.body | startswith("@agent:")))
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

# 5. General PR conversation comments from third-party reviewers (not the owner, not bots).
general_feedback="$(gh api "repos/$owner/$repo/issues/$PR/comments" --jq --arg me "$AUTHOR_LOGIN" '
    [ .[]
      | select(
          .user.login != $me
          and (.user.login | endswith("[bot]") | not)
        )
      | { id: .id, kind: "general", path: null, line: null, body: .body, author: .user.login } ]
  ' 2>/dev/null || echo "[]")"

combined_feedback="$(jq -n --argjson a "$inline_feedback" --argjson b "$general_feedback" '$a + $b')"
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
