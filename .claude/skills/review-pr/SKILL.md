---
name: review
description: Code review skill that analyzes PRs and generates an issues list for triage. Supports three review levels (low, mid, high). Triggers when the user wants to review a PR, says "/review", or asks for code review. Usage - /review [low|mid|high] <pr-url-or-number>
---

# Code Review

Code review skill that thinks like the user. Functional programming, type-safety, simplicity, and comments that are direct and to the point.

## Invocation

```
/review [low|mid|high] <pr-url-or-number>
```

- If the level is not specified, default to `mid`.
- If the URL/number is not provided, ask for it.
- The argument can be a full GitHub URL or `owner/repo#number`.

## Review Levels

### low: Bug fixes and small PRs
- Focus on bugs, logic errors, typos, obvious regressions.
- Don't comment on style, organization, or naming.
- Max ~5 issues. Be fast and pragmatic.

### mid: Quality + speed (default)
- Everything from `low` +
- Type-safety: usage of `any`, bad castings, `interface` where `type` would suffice.
- Simplicity: imperative code that could be functional, unnecessary mutability.
- Colocation: types in separate files without need, unnecessary imports.
- Tests: missing coverage, tests that could be more efficient.
- Don't rush, but don't be a perfectionist. Use good judgment.

### high: Maximum quality
- Everything from `mid` +
- Architecture: coupling, responsibility, module organization.
- Performance: unnecessary loops, Promise.all vs allSettled, allocations inside loops.
- Security: path traversal, input validation at boundaries.
- Documentation: README vs ADR vs JSDoc, docs that age poorly.
- Exhaustive checks with `never` in switches.
- Suggestions for lightweight libraries if they solve the problem better.
- Edge case coverage in tests.

## Execution context

The skill is ALWAYS called from within the PR's repository, on the branch being reviewed. This means:
- The code is available locally. Read files directly with Read instead of relying only on the diff.
- No need to clone, checkout, or switch branches.
- This allows deeper analysis: understanding the context around changed code, verifying that types exist, checking if project conventions are being followed, etc.

## Workflow

### Step 1: Fetch PR metadata and identify changes

Use `gh` CLI to fetch metadata and list of changed files:

```bash
# PR metadata (title, description, base branch)
gh pr view --json title,body,baseRefName,number,url

# List of changed files with status (added/modified/removed)
gh pr diff --name-only

# Full diff to map changed lines
gh pr diff
```

Extract: title, description, changed files, full diff.

### Step 2: Read and analyze changed files

For each changed file:
1. **Read the full file locally** with Read, not just the diff. This gives context of the surrounding code.
2. **Read the file's diff** to focus on the lines that changed.
3. **Analyze applying the checklist** for the selected level.

Reading the local file allows:
- Verifying that referenced types/imports actually exist
- Understanding the project's pattern (existing conventions, style)
- Checking for duplicate code that could be reused (or vice-versa)
- Evaluating the full context of changed functions

#### Universal checklist (all levels)

- [ ] Bugs, logic errors, off-by-one, unhandled null/undefined
- [ ] Obvious regressions

#### mid+ checklist

- [ ] `interface` used where `type` would suffice. Prefer `type` ALWAYS, except for interface augmentation
- [ ] `any` or bad castings (`as unknown as X`, etc.)
- [ ] Imperative code that would be cleaner as functional (map/filter/reduce vs for loops)
- [ ] Unnecessary mutability (let where const suffices, push on array that could be map)
- [ ] Types in separate file without need. Colocation is better
- [ ] Missing tests for new code
- [ ] Tests that call the same function N times when one call + N expects would suffice

#### high checklist

- [ ] Switch without exhaustive check (`default: { const _exhaustive: never = x; }`)
- [ ] Overly broad typing (string where union type would suffice)
- [ ] Promise.all where Promise.allSettled would make more sense
- [ ] Path traversal or unvalidated input at system boundaries
- [ ] Object instantiation inside loops (TextDecoder, RegExp, etc.)
- [ ] README with information that gets stale fast. Suggest ADR or JSDoc
- [ ] Technical decision docs that should be an ADR
- [ ] Unnecessary coupling, sometimes duplicating is better than coupling
- [ ] Lightweight library that would solve the problem without reinventing

### Step 3: Generate issues list

Generate a `.md` file with the issues found, formatted for triage:

```markdown
# Code Review: PR #{number}: {title}

**Level**: {low|mid|high}
**Files analyzed**: {count}

## Issues

### 1. [file:line]: Short issue title
**Severity**: critical | important | suggestion | question
**Comment**:
> {comment in the user's style}

**Code suggestion** (if applicable):
\`\`\`typescript
// suggested code
\`\`\`

---

### 2. [file:line]: ...

---

## Summary
- {N} issues found
- {N} critical, {N} important, {N} suggestions, {N} questions
```

Save the file as `review-pr-{number}.md` in the current directory.

At the end, display a summary and ask if the user wants to edit/remove any issues before submitting with `/review-submit`.

## Comment writing style

Follow EXACTLY the style defined in the `my-voice` skill (`.claude/skills/my-voice/SKILL.md`).
Read and apply all tone, phrasing, and language rules defined there.

## Reviewer principles

These are the technical values that guide the review:

1. **FP > OO/Imperative**: Prefer map/filter/reduce, immutability, function composition. Avoid classes, imperative loops, mutation.
2. **Type-safety**: `type` > `interface`. Exhaustive checks. Avoid `any`. Precise typing (union types > string).
3. **Simplicity**: Code should be easy to read. Break up large functions. Colocate types.
4. **Duplicate > Couple**: When it makes sense, duplicating is better than premature abstraction.
5. **Lightweight libraries**: If a light library solves the problem without bloating the bundle, adopt it.
6. **Project conventions**: Follow what the project already does. Don't impose external style.
7. **Efficient tests**: One call + N expects > N redundant calls.
8. **Documentation that lasts**: JSDoc > README for APIs. ADR for decisions. Avoid docs that age poorly.
9. **Security at boundaries**: Validate at system boundaries, not in internal code.
