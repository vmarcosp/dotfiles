# Dotfiles

Personal macOS development environment for Marcos Oliveira. Everything is symlinked to its system location by `install.sh`; editing a file here edits it in place.

Run `./install.sh` to bootstrap a new machine or restore all symlinks.

## Repository layout

```
dotfiles/
├── install.sh       # Bootstrap: Homebrew, symlinks, nvm
├── AGENTS.md        # This file (also root CLAUDE.md)
├── env/             # .zshrc and .gitconfig
├── nvim/            # Neovim config (lazy.nvim)
├── kitty/           # Kitty terminal config
├── tmux/            # Minimal tmux config
├── better-tmux/     # TypeScript/React status bar
├── bin/             # Utility scripts
├── agents/          # Shared AI rules and skills
├── .agents/         # Dotfiles-only Claude config
├── .claude/         # Claude Code project settings
├── claude/          # Global Claude Code settings
├── opencode/        # Opencode config
├── cursor/          # Cursor hooks/MCP
├── wallpapers/      # Desktop wallpapers
├── __assets/        # README screenshots
└── cs/              # Counter-Strike autoexec
```

## Symlinks

`install.sh` links these to their system locations:

| Source | Destination |
|--------|-------------|
| `env/.gitconfig` | `~/.gitconfig` |
| `env/.zshrc` | `~/.zshrc` |
| `nvim/` | `~/.config/nvim` |
| `kitty/kitty.conf`, `kitty/yugen.conf` | `~/.config/kitty/` |
| `tmux/.tmux.conf` | `~/.tmux.conf` |
| `better-tmux/` | `~/.config/better-tmux` |
| `agents/` | `~/.agents` |
| `agents/AGENTS.md` | `~/.claude/CLAUDE.md` |
| `claude/settings.json` | `~/.claude/settings.json` |
| `agents/agents`, `agents/skills`, `agents/commands`, `agents/rules` | `~/.claude/agents`, `~/.claude/skills`, `~/.claude/commands`, `~/.claude/rules` |
| `claude/workflows` | `~/.claude/workflows` |
| `agents/skills` | `~/.cursor/skills` |
| `cursor/hooks.json`, `cursor/mcp.json` | `~/.cursor/hooks.json`, `~/.cursor/mcp.json` |
| `bin/*` | `~/bin/` |
| `opencode/plugins` | `~/.opencode/plugins` |

## Key facts

- `install.sh` is the source of truth for packages and symlinks.
- `agents/` is shared across AI tools; `.agents/` applies only inside this repo.
- `CLAUDE.md` at the root is a symlink to this file.
- The dark `yugen` theme is applied per-tool and kept in sync manually.

## Common tasks

- **Shell config:** edit `env/.zshrc`, then run `exec zsh`.
- **Neovim:** edit files under `nvim/lua/`; lazy.nvim picks them up on launch.
- **tmux status bar:** edit `better-tmux/index.tsx`.
- **Global AI rule:** add a file to `agents/rules/`.
- **Global skill:** add a folder to `agents/skills/`.
- **Repo-scoped AI rule/skill:** add to `.agents/`.
- **New symlink:** edit `install.sh`, then re-run it.
