#!/usr/bin/env bash
# One-shot Mac pass after pulling the shared/macos/omarchy layout.
# Re-links everything, then reports stale or broken paths from the old tree.
set -euo pipefail

if [[ "$(uname -s)" != Darwin ]]; then
  echo "mac-compliance.sh is for macOS only. On Omarchy run ./install.sh" >&2
  exit 1
fi

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "$DOTFILES/lib/platform.sh"

log "Running install.sh for this Mac"
"$DOTFILES/install.sh"

log "Checking leftover links from the pre-shared/ layout"

stale_ok=0
check_link() {
  local dest="$1" needle="$2"
  if [ ! -e "$dest" ] && [ ! -L "$dest" ]; then
    warn "missing: $dest"
    stale_ok=1
    return
  fi
  if [ -L "$dest" ]; then
    local target
    target="$(readlink "$dest")"
    if [[ "$target" != *"$needle"* ]]; then
      warn "$dest -> $target  (expected path containing $needle)"
      stale_ok=1
    fi
    if [ ! -e "$dest" ]; then
      warn "broken symlink: $dest -> $target"
      stale_ok=1
    fi
  fi
}

check_link "$HOME/.zshrc" "shared/zsh/.zshrc"
check_link "$HOME/.gitconfig" "shared/git/.gitconfig"
check_link "$HOME/.config/nvim" "shared/nvim"
check_link "$HOME/.tmux.conf" "shared/tmux/.tmux.conf"
check_link "$HOME/.config/better-tmux" "shared/better-tmux"
check_link "$HOME/.agents" "shared/agents"
check_link "$HOME/.config/kitty/kitty.conf" "macos/kitty"
check_link "$HOME/Library/Application Support/com.mitchellh.ghostty/config" "macos/ghostty"

localize_cursor_mcp
ensure_local_mcp
if [ -L "$HOME/.cursor/mcp.json" ]; then
  warn "~/.cursor/mcp.json is still a symlink; MCP must stay local"
  stale_ok=1
fi

# Drop broken ~/bin entries that pointed at the old bin/ or env/ paths.
if [ -d "$HOME/bin" ]; then
  for f in "$HOME/bin"/*; do
    [ -L "$f" ] || continue
    if [ ! -e "$f" ]; then
      warn "removing broken ~/bin link: $f -> $(readlink "$f")"
      rm -f "$f"
      stale_ok=1
    fi
  done
fi

# Re-apply bin links in case we just removed stubs.
link_bin_dir "$DOTFILES/shared/bin"
link_bin_dir "$DOTFILES/macos/bin"

if [ "$stale_ok" -eq 0 ]; then
  log "Mac compliance: all checked links point at the new layout."
else
  log "Mac compliance: install.sh ran; review warnings above."
fi
log "Open a new terminal or run: exec zsh"
