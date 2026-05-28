<!-- context7 -->
Use Context7 MCP to fetch current documentation whenever the user asks about a library, framework, SDK, API, CLI tool, or cloud service -- even well-known ones like React, Next.js, Prisma, Express, Tailwind, Django, or Spring Boot. This includes API syntax, configuration, version migration, library-specific debugging, setup instructions, and CLI tool usage. Use even when you think you know the answer -- your training data may not reflect recent changes. Prefer this over web search for library docs.

Do not use for: refactoring, writing scripts from scratch, debugging business logic, code review, or general programming concepts.

## Steps

1. Always start with `resolve-library-id` using the library name and the user's question, unless the user provides an exact library ID in `/org/project` format
2. Pick the best match (ID format: `/org/project`) by: exact name match, description relevance, code snippet count, source reputation (High/Medium preferred), and benchmark score (higher is better). If results don't look right, try alternate names or queries (e.g., "next.js" not "nextjs", or rephrase the question). Use version-specific IDs when the user mentions a version
3. `query-docs` with the selected library ID and the user's full question (not single words)
4. Answer using the fetched docs
<!-- context7 -->

<!-- rules -->
Always apply the rules in `~/.agents/rules/` as if they were inlined here. Read the file when relevant:

- `~/.agents/rules/commit.md` — commit workflow (use the `commit` skill, conventional commits)
- `~/.agents/rules/context7.md` — use Context7 MCP for library docs
- `~/.agents/rules/human-writing.md` — natural prose, no AI-generated patterns
- `~/.agents/rules/spec-implement-flow.md` — `/specification` and `/implementing` share one branch and one draft PR
<!-- rules -->
