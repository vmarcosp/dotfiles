<div align="center">

# ~/dotfiles

Everything I use my day to day in mac coding environments. From skills to tool configurations and custom scripts.

[Overview](#overview) · [Tools](#tools) · [Skills](#skills) · [Install](#install) · [What's inside](#whats-inside)

</div>

---

## Overview

One repo for the machine I actually code on. macOS is the main target; Omarchy gets the same tree when I'm on the Linux box.

Edit files here. `install.sh` symlinks them into place and installs packages. Idempotent — safe to run again after every `git pull`.

## Tools

What gets configured, not a full package dump:

| Area | What |
|:-----|:-----|
| Shell | zsh, oh-my-zsh, host-specific extras in `macos/zsh.zsh` or `omarchy/zsh.zsh` |
| Editor | Neovim — lazy.nvim, yugen on Mac, live Omarchy theme on Omarchy |
| Terminal | Ghostty — yugen on Mac, Omarchy theme on Omarchy |
| Multiplexer | tmux + TPM plugins, better-tmux status bar |
| Git | `.gitconfig` |
| Agents | Skills, rules, and hooks for Cursor, Claude Code, and opencode |
| macOS | Homebrew formulae, casks, and Nerd Fonts via `macos/packages.sh` |

MCP configs stay local (`~/.cursor/mcp.json`, `~/.config/opencode/mcp.local.json`). This repo does not ship secrets.

## Skills

Live in [`shared/agents/skills/`](shared/agents/skills/) and link into every agent home on install.

| Skill | Use it for |
|:------|:-----------|
| `/brainstorm` | Turn a fuzzy idea into something decision-ready |
| `/adr` | Record an architecture decision |
| `/tdd` | Write or update a technical design doc |
| `/review` | Review a delivered change against its contracts |
| `/pr-explainer` | Walk a PR in rounds — overview, Q&A, quiz |
| `/triage-pr-followups` | Triage leftover follow-ups on an open PR |
| `/my-voice` | Rewrite prose in my voice |
| `/humanizer` | Strip chatbot tells from a draft |
| `/nous` | Act on Nous review threads on a local doc |
| `/notification` | Desktop ping when an agent needs you |
| `todoist-cli` | Tasks via the `td` CLI |
| `context7-mcp` | Fetch current library docs via Context7 |
| `writing-great-skills` | Reference for authoring skills well |

## Install

```sh
git clone https://github.com/vmarcosp/dotfiles ~/dotfiles
cd ~/dotfiles && ./install.sh
```

That installs packages for the detected host, clones oh-my-zsh and tmux plugins if needed, and links config into `~`.

**First time on the Mac** after this layout landed:

```sh
./mac-compliance.sh
```

**Day to day:**

```sh
git pull && ./install.sh
exec zsh
```

On Omarchy: `chsh -s /usr/bin/zsh` if you want zsh as login shell. Skip the `omarchy-zsh` package — it fights this `.zshrc`.

Agent context for this repo: [AGENTS.md](AGENTS.md).

## What's inside

```
dotfiles/
├── install.sh              # packages + symlinks (both hosts)
├── mac-compliance.sh       # one-shot Mac migration
├── lib/platform.sh         # host detection
├── shared/                 # both hosts
│   ├── zsh/ nvim/ tmux/ git/
│   ├── better-tmux/
│   ├── agents/             # skills, rules → ~/.agents, ~/.cursor, ~/.claude
│   ├── claude/ cursor/ opencode/
│   └── bin/
├── macos/                  # Homebrew, Ghostty (yugen), mac scripts
└── omarchy/                # Hyprland, Ghostty, shell.json, desktop hooks
```

MIT
