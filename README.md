<div align="center">

# dotfiles

macOS and Omarchy, same repo. Edit here, live via symlink.

[Install](#install) · [Layout](#layout) · [Skills](#skills) · [License](#license)

</div>

## What it is

Shell, editor, tmux, terminals, AI skills, and (on Omarchy) Hyprland. `install.sh` detects the host and links the right tree.

Ghostty on the Mac uses the `yugen` theme. Ghostty on Omarchy follows the active Omarchy theme. Neovim is this lazy.nvim config on both (yugen), not Omarchy's LazyVim.

## Install

```sh
git clone https://github.com/vmarcosp/dotfiles ~/Work/dotfiles
cd ~/Work/dotfiles && ./install.sh
```

Idempotent. After `git pull`, run `./install.sh` again.

First time on the **Mac** after this layout: `./mac-compliance.sh` (rewrites old symlink targets, then runs `install.sh`).

Omarchy extra: `chsh -s /usr/bin/zsh` if you want zsh as the login shell. Do not install the `omarchy-zsh` package.

## Layout

```
shared/     both hosts (nvim, zsh core, tmux, agents, git)
macos/      Darwin only (Kitty, yugen Ghostty, brew lists)
omarchy/    Omarchy only (Hyprland, Ghostty + theme include, shell.json)
```

`install.sh` is the symlink map. Details: [AGENTS.md](AGENTS.md).

## Skills

Skills live in [`shared/agents/skills/`](shared/agents/skills/) and link into Claude Code, Cursor, and opencode. Pipeline: `/brainstorm` → `/prd` `/tdd` `/adr` → `/phasing` → `/spec` → `/implement`.

## License

MIT
