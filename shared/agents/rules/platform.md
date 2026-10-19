---
alwaysApply: true
---

This user has three machines. Detect which one before assuming paths, tools, or hardware.

| Machine | Hardware | `DOTFILES_MACHINE` |
|---------|----------|--------------------|
| Mac | MacBook on macOS | `macos` |
| PC | Desktop PC on Omarchy | `omarchy-pc` |
| MacBook (Omarchy) | MacBook Pro (T2) on Omarchy | `omarchy-macbook` |

Apple hardware does not mean macOS. Check the OS, not `/sys/class/dmi` or the hostname alone.

- **macOS**: `uname -s` is Darwin. Homebrew, Ghostty under `~/Library/Application Support/com.mitchellh.ghostty`, nvm, `caffeinate`/`awake`, `reattach-to-user-namespace`.
- **Omarchy**: `/usr/share/omarchy` exists or `omarchy` is on PATH. Packages via `omarchy pkg add`. Ghostty is `~/.config/ghostty` and includes the Omarchy theme file. Desktop config is Hyprland (`~/.config/hypr`). Toolchain is mise, not nvm. Never edit `/usr/share/omarchy/`.
- **Which Omarchy machine**: `~/.config/omarchy/machine` holds `pc` or `macbook` (missing means `pc`). zsh exports it as `DOTFILES_MACHINE`.

When the working directory is this dotfiles repo, follow the repo `AGENTS.md`.
