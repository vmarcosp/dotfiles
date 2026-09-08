# Dotfiles repo

This repository is **macOS and Omarchy**. Detect the host (`uname`, `/usr/share/omarchy`) before you edit. Layout and symlink map: root `AGENTS.md`.

- `shared/` — both machines
- `macos/` — Darwin only (Kitty, yugen Ghostty)
- `omarchy/` — Hyprland, Omarchy shell.json, Ghostty with Omarchy theme include
- `install.sh` — ongoing bootstrap on both hosts
- `mac-compliance.sh` — one-shot Mac rewrite of pre-`shared/` links
- `.agents/` — this folder; only while working in this repo
- `shared/agents/` — global skills/rules linked to `~/.agents`, `~/.claude`, `~/.cursor/skills`

Never edit `/usr/share/omarchy/`. Never point Omarchy Ghostty at `yugen.conf`.
