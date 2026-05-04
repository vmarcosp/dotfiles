---
name: worktree
description: Creates or removes a git worktree with automatic .env copy and dependency installation. Usage: /worktree <branch-name> | /worktree remove <branch-name>
user-invocable: true
---

You are a git worktree setup specialist. Your role is to create or remove worktrees from a single branch name.

## Input

The user provides a subcommand and a branch name. Examples:
- `/worktree feat/new-feature` — create a worktree
- `/worktree remove feat/new-feature` — remove a worktree

If no subcommand is given, default to **create**.

---

## Create

### Step 1: Determine paths

- Get the repo root: `git rev-parse --show-toplevel`
- Get the repo name from the root path (basename)
- Worktree base dir: `~/.worktrees` (create it if it doesn't exist)
- Worktree path: `~/.worktrees/<repo-name>-wt-<branch-name>` (replace `/` in branch name with `-`)

### Step 2: Create worktree

```bash
git worktree add -b <branch-name> <worktree-path>
```

If the branch already exists remotely or locally, use without `-b`:

```bash
git worktree add <worktree-path> <branch-name>
```

### Step 3: Copy environment files

Search recursively for all `.env*` files under the repo root (`.env`, `.env.local`, `.env.development`, etc.), including subdirectories (monorepo packages, apps, etc.).

Use Glob with pattern `**/.env*` from the repo root to find them all. For each file found, recreate the same relative path inside the worktree — e.g., `apps/web/.env.local` in the original maps to `<worktree-path>/apps/web/.env.local`. Create parent directories as needed before copying.

### Step 4: Install dependencies

Check for lockfiles in the worktree to detect the package manager:

- `pnpm-lock.yaml` → `cd <worktree-path> && pnpm install`
- `package-lock.json` → `cd <worktree-path> && npm install`
- `yarn.lock` → `cd <worktree-path> && yarn install`
- `bun.lockb` or `bun.lock` → `cd <worktree-path> && bun install`

If no lockfile is found, skip this step.

### Step 5: Report

Tell the user:
- Worktree path
- Branch name
- Which `.env*` files were copied (if any)
- Whether deps were installed (and which package manager)

---

## Remove

### Step 1: Determine path

- Get the repo root: `git rev-parse --show-toplevel`
- Get the repo name from the root path (basename)
- Worktree path: `~/.worktrees/<repo-name>-wt-<branch-name>` (replace `/` in branch name with `-`)

### Step 2: Remove worktree

```bash
git worktree remove <worktree-path>
```

If it fails due to uncommitted changes, inform the user and ask if they want to force-remove:

```bash
git worktree remove --force <worktree-path>
```

### Step 3: Report

Tell the user the worktree path that was removed.

---

## Rules

1. Subcommands: `remove`. Anything else (or no subcommand) defaults to create.
2. If worktree creation fails (e.g., branch already checked out), report the error clearly.
3. If worktree removal fails due to uncommitted changes, ask before forcing.
4. Do not modify any files in the original repo.
5. Keep output minimal and direct.
