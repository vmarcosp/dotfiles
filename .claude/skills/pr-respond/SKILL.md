---
name: pr-respond
description: Responds to review comments and addresses feedback on PRs. Reads pending comments, categorizes them, helps write responses in the user's voice, makes code/doc changes when needed, and posts via gh CLI. Works with code PRs and document PRs (RFCs, ADRs). Usage - /pr-respond <pr-url-or-number>
user-invocable: true
---

# PR Respond

Skill for responding to review comments and addressing feedback on the user's PRs. Works with code PRs and document PRs (RFCs, ADRs).

## Voice

All responses MUST follow the style defined in the `my-voice` skill (`.claude/skills/my-voice/SKILL.md`).
Read and apply all tone, phrasing, and language rules defined there.

## Invocation

```
/pr-respond <pr-url-or-number>
```

- Accepts a full GitHub URL or `owner/repo#number`.
- If not provided, ask for it.

## Execution context

The skill is ALWAYS called from within the PR's repository, on the PR's branch. This means:
- The code is available locally. Read files directly with Read.
- No need to clone, checkout, or switch branches.

## Workflow

### Step 1: Fetch PR context

Fetch metadata and all pending comments:

```bash
# PR metadata
gh pr view <number> --json title,body,baseRefName,number,url,state,headRefName

# Inline review comments (with threads)
gh api repos/{owner}/{repo}/pulls/{number}/comments --paginate

# General PR comments (conversation tab)
gh api repos/{owner}/{repo}/issues/{number}/comments --paginate

# Reviews (summaries)
gh api repos/{owner}/{repo}/pulls/{number}/reviews --paginate
```

Collect: all review comments, discussion threads, inline comments.

### Step 2: Categorize comments

For each comment/thread, classify:

| Tag | Description | Expected action |
|-----|-------------|-----------------|
| `[CODE]` | Code change request | Change code + respond |
| `[DOC]` | Document change request (RFC/ADR/README) | Change doc + respond |
| `[DISCUSS]` | Point that needs a response/discussion | Respond with reasoning |
| `[QUESTION]` | Question that needs an answer | Respond directly |
| `[NIT]` | Style, formatting, minor | Quick fix + "Done" |

Ignore:
- Comments already responded to by the user
- Already resolved threads
- Comments from the user themselves

### Step 3: Present triage to the user

```
PR #{number} - {title}

Pending comments:

[CODE] 1. @reviewer in file.ts:42
       "I'd suggest using X instead of Y"
       -> Action: change code

[DISCUSS] 2. @reviewer in file.ts:10
          "I don't understand the motivation..."
          -> Action: respond with explanation

[NIT] 3. @reviewer in styles.css:5
      "Missing semicolon"
      -> Action: quick fix

How do you want to proceed? (all / list of numbers / skip)
```

Wait for user response.

### Step 4: Address each selected item

For each item, in order:

**`[CODE]` and `[DOC]`**: File changes
1. Read the full file locally with Read
2. Understand the context around the requested change
3. Make the change
4. Draft a brief response confirming the change
5. Show the draft to the user

**`[DISCUSS]` and `[QUESTION]`**: Text responses
1. Read the full thread context
2. If it's about code, read the relevant file
3. Draft the response in the user's voice
4. Show the draft for the user to approve/edit before posting

**`[NIT]`**: Quick fixes
1. Make the fix
2. Automatic response: "Done" or "Fixed"

### Step 5: Post responses

For each addressed item, reply in the specific thread:

```bash
# Reply to inline review comment thread
gh api repos/{owner}/{repo}/pulls/{number}/comments/{comment_id}/replies \
  --method POST \
  -f body="{response}"

# Reply to general PR comment
gh api repos/{owner}/{repo}/issues/{number}/comments \
  --method POST \
  -f body="{response}"
```

Never post `[DISCUSS]` or `[QUESTION]` responses without explicit user approval.

### Step 6: Commit and push

If code/doc changes were made:
1. Show the user the changed files
2. Ask if they want to commit and push now
3. If yes, use the commit flow (stage, commit with descriptive message, push)

### Step 7: Summary

```
PR #{number} updated:
- {N} code/doc changes made
- {N} responses posted
- {N} items skipped

Link: {pr_url}
```

## Response patterns for PRs

Complement the general `my-voice` rules with patterns specific to responding to feedback:

### Agreeing with feedback
- "Makes sense, fixed."
- "Good call, changed."
- "Agreed, done."

### Partially agreeing
- "I see the point, but [reason]. I fixed [part that makes sense] and kept [part] because [reason]."
- "Makes sense for [case X], fixed. For [case Y] I preferred to keep it because [reason]."

### Pushback (respectfully disagreeing)
- "I thought about that, but [reason for the current choice]. What do you think?"
- "In this case I'd prefer to keep it because [reason]. But if you insist I'll change it."
- "I understand the concern, but [context the reviewer might not have]. Does that make sense?"

### Oversight (reviewer caught something that slipped)
- "Good catch, fixed."
- "Slipped through, thanks. Fixed."
- "Good one, hadn't noticed. Done."

### Nits
- "Done."
- "Fixed."

### For RFCs and ADRs
Responses tend to be longer with more reasoning:
- "Good point. The motivation was [X]. An alternative would be [Y], but I discarded it because [Z]. Does that make sense or do you see something I'm missing?"
- "Agreed that [reviewer's observation]. Updated section [X] to reflect that."
- "That's a conscious trade-off. [Explanation]. If you want I can document it better in the trade-offs section."

## Error handling

- If `gh` is not authenticated, inform the user.
- If a comment thread is not found (deleted/outdated), skip and report.
- If there are conflicts with recent changes, warn the user.
- Never post a discussion response without user approval.
