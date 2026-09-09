# Dotfiles

Personal development environment for macOS and Omarchy (Arch + Hyprland). One repo, equal hosts. `install.sh` is the only ongoing bootstrap.

Detect the host before changing anything:

- **macOS** — `uname -s` is `Darwin`
- **Omarchy** — `/usr/share/omarchy` exists or `omarchy` is on `PATH`

Never assume macOS because this repo used to be Mac-only. Never edit `/usr/share/omarchy/` (package-owned). User desktop config lives in `omarchy/` and is linked into `~/.config`.

```
dotfiles/
├── install.sh              # both hosts: packages + symlinks (idempotent)
├── mac-compliance.sh       # one-shot Mac pass after this layout landed
├── lib/platform.sh         # is_macos / is_omarchy / backup_then_link
├── AGENTS.md               # this file (root CLAUDE.md points here)
├── shared/                 # both hosts
│   ├── git/.gitconfig
│   ├── zsh/.zshrc          # sources macos/zsh.zsh or omarchy/zsh.zsh
│   ├── nvim/               # this lazy.nvim config (not Omarchy LazyVim)
│   ├── tmux/.tmux.conf
│   ├── better-tmux/
│   ├── agents/             # global AI skills/rules → ~/.agents, ~/.claude, ~/.cursor
│   ├── claude/
│   ├── cursor/             # hooks only; MCP is ~/.cursor/mcp.json (local)
│   ├── opencode/           # global config; MCP overlay is ~/.config/opencode/mcp.local.json
│   ├── opencode/
│   └── bin/
├── macos/                  # Darwin only
│   ├── zsh.zsh
│   ├── packages.sh
│   ├── kitty/
│   ├── ghostty/            # yugen
│   └── bin/                # awake, notification (terminal-notifier)
├── omarchy/                # Omarchy only
│   ├── zsh.zsh
│   ├── packages.sh
│   ├── ghostty/            # includes Omarchy theme file
│   ├── hypr/               # → ~/.config/hypr
│   ├── config/             # selected ~/.config/omarchy files
│   └── bin/                # notification (desktop toast)
└── .agents/                # rules for this repo only
```

## Sync

```
git pull && ./install.sh
```

On the Mac, the first pull of this layout also needs:

```
./mac-compliance.sh
```

After that, Mac and Omarchy both use `install.sh` only.

## What this host should touch

| Host | Own | Do not own |
|------|-----|------------|
| Both | `shared/**` | — |
| macOS | `macos/**` (Kitty, yugen Ghostty, Homebrew) | `omarchy/**` |
| Omarchy | `omarchy/**` (Hyprland, shell.json, Ghostty without yugen) | `macos/**`, `/usr/share/omarchy/**` |

Omarchy still writes theme state under `~/.config/omarchy/themes`, `themed/`, `plugins/`, and `~/.local/state/omarchy/`. Those stay off git.

## Common tasks

- Shell: edit `shared/zsh/` plus `macos/zsh.zsh` or `omarchy/zsh.zsh`, then `exec zsh`
- Neovim: `shared/nvim/lua/`
- tmux bar: `shared/better-tmux/` — `themes/macos.tsx` (yugen) vs `themes/omarchy.tsx` (reads live Omarchy `colors.toml`). `install.sh` fetches the GitHub release binary into `~/.local/bin`.
- Global skill/rule: `shared/agents/skills/` or `shared/agents/rules/`
- Omarchy desktop: `omarchy/hypr/`, `omarchy/config/shell.json` — then `hyprctl reload` / `hyprctl configerrors`
- New symlink: `install.sh`, then re-run it

## Packages

- macOS: Homebrew lists in `macos/packages.sh` (casks, nvm, Kitty)
- Omarchy: `omarchy pkg add` from `omarchy/packages.sh` only. Neovim, tmux, Ghostty, lazygit, jq, mise ship with Omarchy. Do not install `omarchy-zsh` (it would fight this `.zshrc`). Do not install nvm here (mise).
