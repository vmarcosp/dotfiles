# Dotfiles Project

This is the dotfiles repo for Marcos Oliveira's personal macOS dev environment. Everything here is symlinked to its system location — editing a file is the same as editing it in place.

## Key facts

- `agents/` contains shared AI tooling (rules, skills, commands) symlinked to `~/.agents` and `~/.claude/`
- `.agents/` (this folder) is scoped to this project only — rules and skills here apply only when Claude works inside the dotfiles repo
- `install.sh` is the source of truth for all symlinks — edit it to add or change what gets linked
- The repo uses `CLAUDE.md -> agents/AGENTS.md` at the root as the global CLAUDE.md for all projects

## Repo layout quick reference

| Folder | Purpose |
|--------|---------|
| `env/` | `.zshrc` and `.gitconfig` |
| `nvim/` | Neovim config (lazy.nvim) |
| `kitty/` | Kitty terminal config |
| `tmux/` | Minimal `.tmux.conf` |
| `better-tmux/` | TypeScript/React tmux status bar |
| `bin/` | `ai-notify` and `worktree` scripts |
| `agents/` | Shared AI tooling — symlinked globally |
| `.agents/` | Dotfiles-specific Claude config (this folder) |
| `.claude/` | Claude Code project settings |
| `claude/` | Global Claude Code settings (symlinked to `~/.claude/settings.json`) |

## Common tasks

- Add a global AI rule: create a file in `agents/rules/`
- Add a global skill: create a folder in `agents/skills/`
- Add a dotfiles-specific rule or skill: add to `.agents/`
- Change tmux status bar: edit `better-tmux/index.tsx`
- Add a new symlink: edit `install.sh`, then re-run it
