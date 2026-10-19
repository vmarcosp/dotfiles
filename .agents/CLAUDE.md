# Dotfiles repo

This repository serves three machines on two hosts: `macos` (MacBook on macOS), `omarchy-pc` (desktop PC), and `omarchy-macbook` (MacBook Pro running Omarchy). A MacBook is not always macOS. Detect the host (`uname`, `/usr/share/omarchy`), then the Omarchy profile (`~/.config/omarchy/machine` or `$DOTFILES_MACHINE`) before you edit. Layout, profile mechanism, and symlink map: root `AGENTS.md`.

- `shared/` — all three machines
- `macos/` — Darwin only (yugen Ghostty)
- `omarchy/` — both Omarchy machines: Hyprland, Omarchy shell.json, Ghostty with Omarchy theme include
- `omarchy/ghostty/{pc,macbook}.conf`, `require("hypr.machine")` — one Omarchy machine only
- `install.sh` — ongoing bootstrap on all machines; asks pc|macbook on Omarchy
- `.agents/` — this folder; only while working in this repo
- `shared/agents/` — global skills/rules linked to `~/.agents`, `~/.claude`, `~/.cursor/skills`

Never edit `/usr/share/omarchy/`. Never point Omarchy Ghostty at `yugen.conf`.
