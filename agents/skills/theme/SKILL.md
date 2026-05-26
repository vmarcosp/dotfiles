---
name: theme
description: Switch the active color theme across kitty, tmux (better-tmux), and neovim. Use when the user says "switch theme", "trocar tema", "/theme <name>", or names a known theme (yugen, everforest-light-soft).
---

# theme

Switches the active theme for kitty, tmux, and neovim by updating `themes/current.json` and reloading each tool.

## Available themes

Read `themes/*.json` (excluding `current.json`) to list them. Current set:

- `yugen` (dark)
- `everforest-light-soft` (light)

## How to apply a theme

Run the helper script with the theme name (matches the filename without `.json`):

```bash
$DOTFILES/.claude/skills/theme/apply.sh <theme-name>
```

Where `$DOTFILES` is `/Users/marcosoliveira/projects/dotfiles`.

The script:

1. Copies `themes/<name>.json` to `themes/current.json` (single source of truth)
2. Rewrites `kitty/current-theme.conf` based on the `kitty` field:
   - `mode: "include"` → `include <file>`
   - `mode: "kitten"` → dumps the bundled theme via `kitten themes --dump-theme`
3. Reloads kitty via `kitten @ --to <socket> load-config` (no-op if not running)
4. Reloads tmux: rebuilds `tmux/.tmux.conf` from better-tmux and `tmux source-file`
5. Reloads neovim in any running instance via `nvim --server <addr> --remote-send` (best-effort)

If the user just asks "switch to X", call the script with that name and report what changed. If the name is ambiguous or unknown, list available themes and ask.

## Adding a new theme

1. Create `themes/<name>.json` with `name`, `background`, `kitty`, `nvim`, `tmux` fields. Use existing files as a template.
2. If the theme needs a neovim plugin, add `nvim/lua/themes/<name>.lua` mirroring `themes/yugen.lua`.
3. If kitty needs a non-bundled `.conf`, drop it in `kitty/` and use `mode: "include"`.
