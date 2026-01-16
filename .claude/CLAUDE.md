## CRITICAL INSTRUCTION:
You are an expert engineering consultant.
- Before answering, assess your confidence level (0-100%) based on your training data and the provided context.
- If Confidence < 80%: Do NOT guess. State clearly: "I am not confident in this answer because [reason]." Ask clarifying questions or suggest where I should look.
- If Confidence >= 80%: Provide the solution directly.

---

## Workflow

### Feature Development Flow

```
/planner → Designer? → Implementer → /qa → /review → Resolver → Merge
              │                        │       │          │
              │ (if UI)                │       │          │
              └────────────────────────┘       │          │
                                               │          │
                       fix issues ◄────────────┘          │
                                                          │
                       re-review (if 🔴 critical) ◄───────┘
```

**Sequence:**
1. `/planner` - Creates `plan.md` with requirements, tasks, QA scenarios
2. **Designer** - (Optional, agent) Adds wireframes if UI changes needed
3. **Implementer** - (Agent) Writes code, creates commits
4. `/qa` - Tests manually, creates `qa-report.md`
5. `/review` - Reviews code, creates `.review-*.md`
6. **Resolver** - (Agent) Addresses review feedback, re-requests review if 🔴 critical fixes

### Bug Fix Flows

**Complex bugs:**
```
/bug → Bug Analyzer → /planner → (feature flow)
```

**Trivial bugs** (typos, obvious errors):
```
/fix → Commit
```

### Artifact Locations

All artifacts live in `plans/<feature-name>/`:

```
plans/
  <feature-name>/
    plan.md          # /planner creates
    qa-report.md     # /qa creates
    .review-1.md     # /review creates (numbered)
    .review-2.md     # /review creates (re-review)
    .analysis.md     # Bug Analyzer creates (bug fixes only)

BUGS.md              # /bug maintains (project root)
```

### Skills & Commands

Skills are auto-discovered by Claude. Commands (`/cmd`) invoke them manually.

| Command | Skill | Model | Purpose |
|---------|-------|-------|---------|
| `/qa` | qa | sonnet | Manual testing, creates qa-report.md |
| `/review` | review | opus | Code review, creates .review-*.md |
| `/bug` | bug | haiku | Documents bugs in BUGS.md |
| `/fix` | fix | haiku | Trivial bug fixes (typos, obvious errors) |
| `/commit` | commit | haiku | Stage, commit (conventional), push |

### Agents (part of flow)

| Agent | Model | Purpose |
|-------|-------|---------|
| Designer | sonnet | Adds UI wireframes/specs |
| Implementer | opus | Writes code following plans |
| Resolver | opus | Addresses review feedback |
| Bug Analyzer | sonnet | Investigates bug root causes |

### Severity Levels

Used consistently across `/qa`, `/review`, Resolver:
- 🔴 **Critical** - Blocks functionality, security issues, data loss
- 🟡 **Medium** - Partial functionality, poor UX, edge cases
- 🔵 **Low** - Minor issues, style, nice-to-haves

### When to Use Designer

Use Designer after `/planner` if:
- New UI screens or pages
- Significant layout changes
- Complex form layouts
- New interactive components

Skip Designer for:
- Backend-only changes
- Minor UI tweaks
- Bug fixes without layout changes

