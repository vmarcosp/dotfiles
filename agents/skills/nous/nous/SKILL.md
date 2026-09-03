---
name: nous
description: Acts on the review comments a human left in the Nous app on a local Markdown doc — reads each thread, works out whether it asks for an answer, an edit, or a discussion, and does that. Use when the user says "check my Nous comments", "/nous", "address the review", "what did I flag in <doc>", "answer the comments on this branch", or when work on a doc should be driven by comments a reviewer left in Nous on a local branch. Covers listing and filtering threads across a whole branch or one doc, answering questions, proposing and applying edits, discussing disagreements, resolving finished threads, deleting comments, opening a doc in the Nous UI, and installing this skill into another repo. Not for GitHub PR comments (use gh for those) and not for creating new threads.
---

A human reviewed a doc in Nous and left comments on it. Your job is to work through them and **do what each one asks** — not to summarize them back, and not to hand the user a plan.

Nous stores these comments on disk, not on GitHub. `nous-app` is the read/write channel: it talks to a running Nous over a local socket, and falls back to the same JSON files when the app is closed. The response is identical either way — never branch on which path served it.

## Finding the binary

Use the first that exists:

1. `nous-app` on `PATH` (installed by `install.sh`)
2. `nous` on `PATH` — the same binary under its alias, when the name was free
3. `src-tauri/target/release/nous-cli`, then `src-tauri/target/debug/nous-cli`

Steps 3 only applies inside the Nous repo itself, where the CLI is a cargo `[[bin]]`. Elsewhere, if steps 1–2 miss, the CLI is not installed — say so and stop rather than hunting for a checkout. Inside the Nous repo with no build yet:

```bash
cargo build --manifest-path src-tauri/Cargo.toml --bin nous-cli
```

Every example below writes `nous-app`. Substitute whichever name you resolved.

## The verbs

```
nous-app list      <repo-path> <branch> [doc-path] [filters]
nous-app reply     <repo-path> <branch> <doc-path> <thread-id> <body>
nous-app resolve   <repo-path> <branch> <doc-path> <thread-id>
nous-app unresolve <repo-path> <branch> <doc-path> <thread-id>
nous-app delete    <repo-path> <branch> <doc-path> <comment-id>
nous-app open      <repo-path> <branch> <doc-path>
nous-app <path>
nous-app skills install [dir] [--for agents|claude|cursor|opencode]... [--yes]
nous-app help
```

`<repo-path>` is the repo root (never a worktree path — Nous resolves the branch's worktree itself). `<branch>` comes from `git branch --show-current`. `<doc-path>` is repo-relative; absolute paths and `..` segments are rejected.

### Listing and filtering

`list` returns **threads** — replies already nested under their root, only the fields you act on. The doc path is optional: without it you get every doc on the branch.

```bash
nous-app list "$REPO" "$BRANCH"                          # everything on the branch
nous-app list "$REPO" "$BRANCH" docs/architecture.md     # one doc
nous-app list "$REPO" "$BRANCH" --unanswered             # what still needs you
nous-app list "$REPO" "$BRANCH" --file arch              # docs whose path contains "arch"
nous-app list "$REPO" "$BRANCH" --grep "naming"          # threads mentioning "naming"
nous-app list "$REPO" "$BRANCH" --unresolved             # threads not yet resolved
nous-app list "$REPO" "$BRANCH" --since 1756490000000    # activity after an epoch-ms
```

Filters compose. **`/nous @some-file.md` maps to `--file some-file`**, not to a doc-path argument — the user is naming a file loosely, and `--file` matches a substring of the path.

`--unanswered` and `--unresolved` are different questions. Unanswered means the last message is not yours — work still waiting. Unresolved means the thread is still open, which includes threads you answered but deliberately left open (a disagreement, a partial fix). **`--unanswered` is usually what you want** when picking up work.

`--verbose` swaps the response for the raw stored comments, flat and complete. It is for debugging the store, not for normal work — it costs several times the tokens and makes you redo the grouping yourself.

## Response contract

One JSON object on stdout, tagged by `cmd`:

- `list` → `{"cmd":"threads","threads":[...]}`
- `list --verbose` → `{"cmd":"list","comments":[...]}` — flat, every field
- `reply` → `{"cmd":"reply","comment":{...}}`
- `resolve`/`unresolve` → `{"cmd":"setResolved","comment":{...}}`
- `delete` → `{"cmd":"delete","deleted":["root-id","reply-id"]}`
- `open` → `{"cmd":"open","target":{...}}`
- `skills` → `{"cmd":"skills","installed":[...]}`
- `err` → `{"cmd":"err","error":{"kind":...}}`

`help` is the exception: plain usage text, not JSON.

A thread:

```json
{"cmd":"threads","threads":[{
  "id":"7c1f0a93b45e2d18",
  "docPath":"docs/conventions.md",
  "line":42,
  "body":"This paragraph contradicts the rule two sections up. Pick one.",
  "author":"Marcos Oliveira",
  "authorKind":"human",
  "createdAt":1756490000000,
  "resolved":false,
  "outdated":false,
  "replies":[
    {"id":"82791d0d","body":"Fixed — removed the contradiction.","author":"Agent","authorKind":"agent","createdAt":1756490500000}
  ]
}]}
```

`docPath` is present on a branch-wide listing and omitted when you named the doc. `line` locates the root in the doc; replies have no line of their own. Every reply you post is stamped `"authorKind":"agent"` and `"author":"Agent"` — never the human's git identity, and never needing an `[agent]` prefix in the body.

## Exit codes

- **`0`** — success. Parse stdout as JSON.
- **`1`** — the operation failed. Read `error.kind`:
  - `worktree-not-found` (`{repoPath, branch}`) — no worktree has that branch checked out. Report it; do **not** create a worktree or switch branches.
  - `fs` (`{path, message}`) — a file or socket problem, or the doc does not exist. Report the path and stop.
  - `parse` (`{what, message}`) — `ReplyToThreadArgs` / `SetResolvedArgs` mean the id you passed is not a current thread root (a *reply* id is rejected too — resolution is a property of a thread). `DeleteCommentArgs` means no comment has that id. `docPath` means the path was absolute or contained `..`. `branch` (from `nous-app <path>` only) means a detached HEAD.
- **`2`** — **you invoked it wrong.** stderr carries the reason and the usage text. Fix the argv; never retry unchanged.

### An empty list is ambiguous

`{"threads":[]}` means *either* "no comments" *or* "your target does not resolve" — `list` recomputes `outdated` on a best-effort basis and does not fail on a bad target. Before reporting "no comments", verify:

```bash
git -C "$REPO" worktree list --porcelain | grep -q "refs/heads/$BRANCH"
```

If that fails, the empty result is a target bug. Only when it passes is "no comments" the real answer.

## Procedure

### 1. Read the threads

```bash
nous-app list "$REPO" "$BRANCH" --unanswered
```

If the user named a file, add `--file <name>`. If they named nothing, take the whole branch.

Skip any thread whose last message is already yours — `--unanswered` does this for you, and a human message after your reply reopens the conversation naturally.

### 2. Read what each thread points at

Open the doc and read around the root's `line`.

If `outdated: true`, the doc changed since the comment was anchored, so `line` may no longer point at the right text. Read a wider window and match on what the comment body describes rather than trusting the number.

### 3. Work out what the comment asks for

Read the comment as a message from a colleague and classify it:

| The comment… | You… |
|---|---|
| asks a question | **answer it** in a reply |
| points at something wrong, or asks for a change | **propose the edit** (step 4) |
| raises a concern, disagrees, or invites discussion | **discuss it** in a reply — argue your side, don't silently comply |
| is ambiguous, or you are not sure which of these it is | **treat it as a discussion** and ask |

Examples:

- *"why did we pick zustand here?"* → answer
- *"this contradicts the rule two sections up"* → propose an edit
- *"not sure this is the right split — thoughts?"* → discuss
- *"fix"* on its own → ambiguous; ask what they want fixed

**When in doubt, ask.** A wrong "answer" costs a round trip; a wrong "edit" rewrites the human's document.

### 4. Propose before you edit

When a thread asks for a change, **do not apply it yet**. Reply with what you intend to do, specifically enough that the human can say yes or no without opening a diff:

```bash
nous-app reply "$REPO" "$BRANCH" "$DOC" "$ROOT_ID" \
  "Reading this as: delete the second paragraph under 'Anchoring' and move its one real claim into the preceding list. Confirm and I'll apply it."
```

Then move to the next thread. **Do not sit and wait** — you are not polling, and there is no watch mode. Work through every thread you can, report what you proposed, and hand back.

The human reads your proposals in the Nous UI and replies there. When they come back to you — a new session, or the same one — re-run `list --unanswered` and you will see their answers as new human messages on those threads.

**Apply the change when, and only when, the human has agreed on the thread.** Then reply saying what you actually did, and resolve:

```bash
# after the human replied "yes" / "go ahead" / "do it"
nous-app reply "$REPO" "$BRANCH" "$DOC" "$ROOT_ID" "Applied — removed the paragraph and folded the claim into the list above."
nous-app resolve "$REPO" "$BRANCH" "$DOC" "$ROOT_ID"
```

Two exceptions to propose-first, both narrow:

- **The user told you to just do it.** "Address my comments and apply the changes" is explicit consent for that run — apply, reply saying what changed, resolve. Their instruction beats this default.
- **The comment is unambiguously an instruction with one possible reading** — *"typo: 'recieve' → 'receive'"*. Apply it, reply saying you did, resolve. If you find yourself explaining why a reading is the only possible one, it isn't: propose instead.

### 5. Answer questions directly

A question needs no proposal. Answer it in a reply, then resolve if the answer settles it:

```bash
nous-app reply "$REPO" "$BRANCH" "$DOC" "$ROOT_ID" "Zustand over Context because the store is read by three sibling panels; Context would re-render all of them on every keystroke."
```

Leave it open if the answer invites a follow-up.

### 6. Discuss when you disagree

Say so plainly, give your reasoning, and **leave the thread open**. A disagreement is a conversation, and resolving it hides it from the human's list. Do not comply with a change you think is wrong just because it was asked for — say why, and let them decide.

### 7. Resolve only what is finished

```bash
nous-app resolve "$REPO" "$BRANCH" "$DOC" "$ROOT_ID"
```

Resolve after the reply lands, and only for a thread you fully addressed. Leave it open when you disagreed, when the ask was ambiguous, when you only did part of it, or when you are waiting on a confirmation. `unresolve` reopens one you closed too early.

### 8. Report back

Tell the user what you did, grouped by outcome: applied, proposed and awaiting confirmation, answered, disagreed. Name the docs and lines. That summary is how they know what to look at in Nous.

## Handing a doc to the human

```bash
nous-app open "$REPO" "$BRANCH" "$DOC"
nous-app docs/architecture.md          # same thing, triple worked out for you
```

Against a running Nous, `open` validates the target, stores the session, **navigates the window to the doc**, and brings it forward. With Nous closed it launches the app (macOS only), waits ~8s for the socket, and re-sends — so a successful `open` normally means the human is looking at the doc. Only if the freshly launched app never binds does the response degrade to a plain echo.

`open` against a running Nous is also the one way to get a straight answer about whether a repo/branch/doc resolves.

## Deleting

`delete` removes one comment permanently. Deleting a root takes its replies with it; the response lists every id removed, root first. There is no undo. Delete only what the user explicitly asked you to delete — never as cleanup, never to tidy a list, never in place of resolving.

## Installing this skill elsewhere

```bash
nous-app skills install                          # prompts for the directories
nous-app skills install --for agents --for cursor # explicit, no prompt
nous-app skills install /repos/acme --yes         # another repo, take the default
```

With no `--for` and a terminal attached, it lists the agent directories it found (`.agents`, `.claude`, `.cursor`, `.opencode`), marks the ones that already exist, and asks. **Piped or called by an agent it never prompts** — it installs to `.agents/skills/` and returns. `--for` is repeatable; `--yes` takes the default without asking.

The skill text is compiled into the binary, so this works from any directory. An existing `SKILL.md` is overwritten (that is how a newer skill arrives after a Nous update) and reported as `"replaced": true` — mention it if the user might have hand-edited theirs. A skill directory left over under the old `nous-comments` name is removed.

## What not to do

- **Don't summarize comments back instead of acting on them.** The user asked you to handle the review, not to read it aloud.
- **Don't apply an edit before the human agreed** — unless they told you to just do it, or the comment has exactly one possible reading.
- **Don't guess at an ambiguous comment.** Ask on the thread.
- **Don't comply with something you think is wrong.** Say so and leave the thread open.
- **Don't read an empty list as "no comments"** without checking the branch is checked out somewhere.
- **Don't retry on exit 2.** That is a malformed invocation, not a transient failure.
- **Don't construct, parse, or increment thread ids.** They are opaque strings from a prior `list`.
- **Don't reply to a non-root id.** Replies go on the thread root, even when answering a reply.
- **Don't create threads.** Starting one is the human's affordance in the Nous UI; no CLI verb exists.
- **Don't edit a comment.** No update verb exists. A correction goes in a new reply.
- **Don't resolve a thread you didn't finish**, or one where you pushed back.
- **Don't delete anything the user didn't ask you to delete.** It is permanent and takes replies with it.
- **Don't poll or loop waiting for a reply.** Propose, move on, hand back. The human comes to you.
- **Don't use `--verbose` for normal work.** It costs several times the tokens and makes you redo the grouping.
- **Don't invent flags.** The list filters above, plus `--for`/`--yes` on `skills install`, are all that exist.
- **Don't create a worktree or switch branches** to satisfy `worktree-not-found`. Report it.
