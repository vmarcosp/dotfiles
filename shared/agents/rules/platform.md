---
alwaysApply: true
---

This user has a Mac and an Omarchy Linux PC. Detect the host before assuming paths or tools.

- **macOS**: `uname -s` is Darwin. Homebrew, Ghostty under `~/Library/Application Support/com.mitchellh.ghostty`, nvm, `caffeinate`/`awake`, `reattach-to-user-namespace`.
- **Omarchy**: `/usr/share/omarchy` exists or `omarchy` is on PATH. Packages via `omarchy pkg add`. Ghostty is `~/.config/ghostty` and includes the Omarchy theme file. Desktop config is Hyprland (`~/.config/hypr`). Toolchain is mise, not nvm. Never edit `/usr/share/omarchy/`.

When the working directory is this dotfiles repo, follow the repo `AGENTS.md`.
