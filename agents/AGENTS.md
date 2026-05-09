# AGENTS.md

Personal macOS development environment for Marcos Oliveira. Everything is symlinked from this repo to its system location — editing a file here is the same as editing it in place. Run `install.sh` to bootstrap a new machine or restore symlinks after a fresh clone.

## Repository Layout

```
dotfiles/
├── install.sh          # Bootstrap script
├── CLAUDE.md           # Symlink to agents/AGENTS.md
├── env/                # Shell and git config
├── nvim/               # Neovim configuration
├── kitty/              # Kitty terminal config
├── tmux/               # tmux config
├── better-tmux/        # Custom tmux status bar (TypeScript + React)
├── bin/                # Utility scripts installed to ~/bin
├── agents/             # AI agent config (skills, rules, commands) — shared across tools
├── .agents/            # Claude Code project-level agent config (dotfiles-specific)
├── .claude/            # Claude Code project-level settings
├── claude/             # Claude Code global settings
├── opencode/           # Opencode config (plugins)
├── wallpapers/         # Desktop wallpapers
├── __assets/           # Versioned screenshots for README
└── cs/                 # Counter-Strike autoexec (unrelated to dev setup)
```

## Symlink Map

`install.sh` creates all symlinks. Here's where each piece lands:

| Source | System location |
|--------|----------------|
| `env/.gitconfig` | `~/.gitconfig` |
| `env/.zshrc` | `~/.zshrc` |
| `nvim/` | `~/.config/nvim` |
| `kitty/kitty.conf` | `~/.config/kitty/kitty.conf` |
| `kitty/yugen.conf` | `~/.config/kitty/yugen.conf` |
| `kitty/current-theme.conf` | `~/.config/kitty/current-theme.conf` |
| `tmux/.tmux.conf` | `~/.tmux.conf` |
| `better-tmux/` | `~/.config/better-tmux` |
| `agents/` | `~/.agents` |
| `agents/AGENTS.md` | `~/.claude/CLAUDE.md` |
| `agents/agents` | `~/.claude/agents` |
| `agents/skills` | `~/.claude/skills` |
| `agents/commands` | `~/.claude/commands` |
| `agents/rules` | `~/.claude/rules` |
| `claude/settings.json` | `~/.claude/settings.json` |
| `bin/worktree` | `~/bin/worktree` |
| `opencode/plugins` | `~/.opencode/plugins` |

## Theme: Yugen 幽玄

A consistent dark theme applied across Neovim, Kitty, tmux, and Claude Code. Colors are defined per-tool but kept in sync manually. The Catppuccin-inspired palette used in `better-tmux/index.tsx` is the reference point.

## Folders

### env/

Shell and git configuration.

`.zshrc` configures oh-my-zsh (robbyrussell theme, git + vi-mode plugins), sets up Homebrew, NVM, pnpm, and bun paths, and auto-starts tmux on every shell launch. It also defines several utility functions:

- `mktouch` — creates a file and any missing parent directories
- `png2webp` — batch converts PNGs to WebP
- `clean-swap` — deletes Neovim swap files
- `clean-branches` — deletes all local git branches except main
- `kill-ports` — kills processes listening on given ports
- `commit-sync` — quick `git add -A && git commit && git push`
- `commit-changelog` — commits with a conventional changelog prefix

Notable aliases: `vim` maps to `nvim`; `claudio` and `claudin` launch Claude in Opus and Sonnet modes respectively.

`.gitconfig` sets nvim as the default editor, main as the default branch, rebase on pull, and defines short aliases like `sts`, `cm`, `ca`, `d`, and `fuck`.

### nvim/

Neovim config using lazy.nvim. `init.lua` is minimal — it just loads three modules from `lua/config/`: `options`, `keymaps`, and `lazy` (plugin manager bootstrap).

Plugin specs live in `lua/plugins/`. Each plugin has its own file. Key plugins: telescope (file search + grep), nvim-tree (file browser), lualine (status bar), treesitter, LSP via mason, conform (formatting), toggleterm (floating terminals), gitsigns, and the yugen theme.

Key keymaps: `Ctrl-p` for file search, `Ctrl-f` for live grep, `Ctrl-n` for file tree, `\gt` for lazygit in a floating terminal, `\t` for a plain floating terminal. Window navigation uses `Ctrl-h/j/k/l`.

### kitty/

Kitty terminal config. `kitty.conf` is the main file; it sources `yugen.conf` for colors and `current-theme.conf` for the active theme override. Font is Space Mono 14pt with Operator Mono for italics. Background blur is set to 25 with full opacity.

To change the theme, update `current-theme.conf`.

### tmux/

`.tmux.conf` is intentionally minimal — it sets the shell, enables mouse, configures tpm (tmux plugin manager), and delegates everything else to `better-tmux`. Plugins: `tmux-sensible` and `tmux-resurrect`. The status bar is rendered by better-tmux.

To reload config: press `prefix + r`.

### better-tmux/

A TypeScript + React component that renders the tmux status bar using the `better-tmux` library. Managed with pnpm.

`index.tsx` defines the color palette, window appearance, and all tmux options (escape time, base index, history limit, mouse, etc.). Keybindings are also declared here:

- `\` — horizontal split at current path
- `-` — vertical split at current path
- `h/j/k/l` — pane navigation
- `H/L` — resize pane left/right

After editing `index.tsx`, pnpm rebuilds and tmux picks up the changes on next status refresh.

### bin/

Scripts installed to `~/bin` and available system-wide.

`worktree` is a git worktree manager. It creates a worktree at `~/.worktrees/<repo>-wt-<branch>`, copies `.env*` files from the main repo, auto-detects the package manager (pnpm/npm/yarn/bun) and installs dependencies, and opens a new tmux window if inside a tmux session. Usage: `worktree <branch>` to create, `worktree remove <branch>` to delete.

### agents/

The central config for AI tooling, shared across Claude Code and any other agent that follows the convention. Symlinked to `~/.agents` and its subdirectories to `~/.claude/`.

```
agents/
├── AGENTS.md       # This file. Also the global ~/.claude/CLAUDE.md via symlink.
├── agents/         # Agent definitions (currently empty)
├── commands/       # Custom slash commands (currently empty)
├── rules/          # Always-applied rules
└── skills/         # Reusable skills invoked via /skill-name
```

**Rules** apply automatically to every conversation:

- `commit.md` — always use the `commit` skill; use conventional commits format; never amend published commits
- `context7.md` — use Context7 MCP for any library or API documentation instead of relying on training data
- `human-writing.md` — use the `human-writing` skill for any prose or document writing

**Skills** are a mix of local implementations and symlinks to an external VTEX agents repo (for `implementing` and `specification`). Local skills include `commit`, `human-writing`, `worktree`, `my-voice`, `grill-me`, and `context7-mcp`.

### .agents/

Claude Code project-level agent config, scoped to the dotfiles repo. Claude Code reads this folder when working inside this project, allowing dotfiles-specific rules, skills, and commands that don't belong in the shared `agents/` folder.

### .claude/

Claude Code project-level settings. Not symlinked to `~/.claude` — this is the `.claude` folder that Claude Code itself reads when working inside this repo.

`settings.local.json` contains machine-specific permission overrides (Playwright browser actions, WebFetch, WebSearch) that aren't committed with the global settings.

### claude/

Global Claude Code settings symlinked to `~/.claude/settings.json`.

Configures: Opus as the default model, vim editor mode, dark-ansi theme. Permissions allow Bash, Read, Write, and Edit while blocking destructive operations like `rm -rf`.

### wallpapers/

Four dark JPEG wallpapers that match the yugen theme. Not symlinked — set manually via macOS System Settings.

### __assets/

Versioned screenshots used in `README.md`. Each version gets its own subfolder (e.g., `v10/`) with a cover image and individual case screenshots. Add new screenshots here when the environment changes significantly.

## Making Changes

- **Shell config**: edit `env/.zshrc`, then run `exec zsh` to reload
- **Neovim plugins**: add a file to `nvim/lua/plugins/`, lazy.nvim picks it up on next launch
- **Neovim options or keymaps**: edit `nvim/lua/config/options.lua` or `keymaps.lua`
- **tmux keybindings or status bar**: edit `better-tmux/index.tsx`, then let pnpm rebuild
- **Kitty theme**: update `kitty/current-theme.conf`
- **Claude Code global settings**: edit `claude/settings.json`
- **Claude Code project settings**: edit `.claude/settings.local.json`
- **AI rules (global)**: edit or add files in `agents/rules/`
- **New skills (global)**: add a folder to `agents/skills/`
- **Dotfiles-specific rules or skills**: add to `.agents/` (project-scoped, not symlinked)
- **Install script**: edit `install.sh` — symlinks and Homebrew packages are both here

## Prerequisites

- macOS
- Homebrew
- oh-my-zsh
- NVM + Node LTS
- pnpm
- tmux + tpm
- Neovim

Run `./install.sh` to install and link everything from scratch.
