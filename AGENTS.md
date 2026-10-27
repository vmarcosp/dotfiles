# Dotfiles

Personal development environment for three machines on two hosts. One repo, equal machines. `install.sh` is the only ongoing bootstrap.

## Machines

| Machine | Hardware | Host | `DOTFILES_MACHINE` |
|---------|----------|------|--------------------|
| Mac | MacBook on macOS | macOS | `macos` |
| PC | Desktop PC, 1080p 27" monitor at 240 Hz | Omarchy | `omarchy-pc` |
| MacBook (Omarchy) | MacBook Pro 15,4 (T2) running Omarchy, `eDP-1` 2560x1600 at scale 2 | Omarchy | `omarchy-macbook` |

"MacBook" does not mean macOS. One MacBook runs Omarchy. Detect the host first, then the Omarchy profile:

- **macOS**: `uname -s` is `Darwin`
- **Omarchy**: `/usr/share/omarchy` exists or `omarchy` is on `PATH`
- **Omarchy profile**: `~/.config/omarchy/machine` contains `pc` or `macbook`. Missing or unknown values mean `pc`.

From the shell, `echo $DOTFILES_MACHINE` gives the full answer. In scripts, source `lib/platform.sh` and call `machine_name`.

Never assume macOS because this repo used to be Mac-only. Never assume macOS because the hardware is a MacBook. Never edit `/usr/share/omarchy/` (package-owned). User desktop config lives in `omarchy/` and is linked into `~/.config`.

```
dotfiles/
├── install.sh              # all machines: packages + symlinks (idempotent)
├── lib/platform.sh         # host_name / machine_name / omarchy_profile / backup_then_link
├── AGENTS.md               # this file (root CLAUDE.md points here)
├── shared/                 # all machines
│   ├── git/.gitconfig
│   ├── zsh/.zshrc          # exports DOTFILES_MACHINE; sources macos/zsh.zsh or omarchy/zsh.zsh
│   ├── nvim/               # this lazy.nvim config (not Omarchy LazyVim)
│   ├── tmux/.tmux.conf
│   ├── better-tmux/
│   ├── agents/             # global AI skills/rules → ~/.agents, ~/.claude, ~/.cursor, ~/.gemini
│   ├── claude/
│   ├── cursor/             # hooks only; MCP is ~/.cursor/mcp.json (local)
│   ├── opencode/           # global config; MCP overlay is ~/.config/opencode/mcp.local.json
│   └── bin/
├── macos/                  # macos machine only
│   ├── zsh.zsh
│   ├── packages.sh
│   ├── ghostty/            # yugen
│   └── bin/                # awake, notification (terminal-notifier)
├── omarchy/                # omarchy-pc and omarchy-macbook
│   ├── zsh.zsh
│   ├── packages.sh
│   ├── ghostty/            # config (both) + pc.conf / macbook.conf overrides
│   ├── hypr/               # → ~/.config/hypr; machine.lua reads the profile
│   ├── xcompose/           # XCompose (both; `'c` → `ç` for us-intl)
│   ├── fcitx5/             # profile (both; keyboard-us-intl)
│   ├── config/             # selected ~/.config/omarchy files
│   └── bin/                # notification (desktop toast)
└── .agents/                # rules for this repo only
```

## Omarchy profile

Both Omarchy machines share `omarchy/`. The profile picks the per-machine parts.

```
install.sh ──asks pc|macbook──▶ ~/.config/omarchy/machine
                                   │
     ┌─────────────────┬───────────┴──────────────┐
     ▼                 ▼                          ▼
hypr/machine.lua   zsh                        Ghostty
(monitors, input,  DOTFILES_                  machine.conf →
 looknfeel,        MACHINE                    pc.conf or
 autostart, rules)                            macbook.conf
```

Keyboard is the same on both: `us` + `intl` (dead keys for accents), `~/.XCompose` from `omarchy/xcompose/XCompose`, fcitx5 profile `keyboard-us-intl`.

- First run asks the question. Later runs default to the saved answer.
- `OMARCHY_MACHINE=macbook ./install.sh` (or `pc`) skips the prompt.
- To switch a machine's profile, re-run `install.sh` and answer again. Then `hyprctl reload` and restart Ghostty.

Current per-machine differences:

| Area | omarchy-pc | omarchy-macbook |
|------|------------|-----------------|
| Monitors (`hypr/monitors.lua`) | `HDMI-A-1` 1080p at 240 Hz, scale 1, `GDK_SCALE=1` | `eDP-1` scale 2, `GDK_SCALE=2` |
| Input (`hypr/input.lua`) | Beken ABNT2 board (TTY `br-abnt2`) | Apple internal trackpad sensitivity |
| Look and feel (`hypr/looknfeel.lua`) | Tearing + direct scanout for games | Omarchy defaults |
| Autostart / window rules | qBittorrent, CS2 rules | — |
| Ghostty | `omarchy/ghostty/pc.conf` | `omarchy/ghostty/macbook.conf` |

## Where to put a change

| Change applies to | Edit |
|-------------------|------|
| All three machines | `shared/**` |
| macos only | `macos/**` |
| Both Omarchy machines | `omarchy/**` (shared parts) |
| One Omarchy machine | Branch on the profile: `require("hypr.machine")` in Hyprland Lua, `omarchy/ghostty/<profile>.conf` for Ghostty, `$DOTFILES_MACHINE` in zsh, `OMARCHY_MACHINE` in `install.sh` |

Do not edit `omarchy/**` from macOS or `macos/**` from Omarchy unless the user asks. Never touch `/usr/share/omarchy/**`.

Omarchy still writes theme state under `~/.config/omarchy/themes`, `themed/`, `plugins/`, and `~/.local/state/omarchy/`. Those stay off git. `~/.config/omarchy/machine` is also local.

## Sync

```
git pull && ./install.sh
```

## Common tasks

- Shell: edit `shared/zsh/` plus `macos/zsh.zsh` or `omarchy/zsh.zsh`, then `exec zsh`. Per-machine: `[[ $DOTFILES_MACHINE == omarchy-macbook ]]`.
- Ghostty: `macos/ghostty/config` on macos. On Omarchy, `omarchy/ghostty/config` for both machines, `pc.conf` / `macbook.conf` for one. Reload with `Ctrl+Shift+,`.
- Neovim: `shared/nvim/lua/`. yugen on macOS; on Omarchy, live theme from `~/.local/state/omarchy/current/theme/neovim.lua`.
- tmux bar: `shared/better-tmux/`. `themes/macos.tsx` (yugen) vs `themes/omarchy.tsx` (reads live Omarchy `colors.toml`). `install.sh` fetches the GitHub release binary into `~/.local/bin`.
- Global skill/rule: `shared/agents/skills/` or `shared/agents/rules/`
- Omarchy desktop: `omarchy/hypr/`, `omarchy/config/shell.json`, then `hyprctl reload` / `hyprctl configerrors`
- New symlink: `install.sh`, then re-run it

## Packages

- macOS: Homebrew lists in `macos/packages.sh` (casks, nvm)
- Omarchy (both machines): `omarchy pkg add` from `OMARCHY_PACKAGES` in `omarchy/packages.sh`; AUR extras via `omarchy pkg aur add` (`OMARCHY_AUR_PACKAGES`, currently Todoist AppImage and Spotifast). Todoist CLI (`td`) is `npm i -g @doist/todoist-cli` through mise Node. Neovim, tmux, Ghostty, lazygit, jq, mise ship with Omarchy. Do not install `omarchy-zsh` (it would fight this `.zshrc`). Do not install nvm here (mise).
