#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/projects/dotfiles}"
THEMES_DIR="$DOTFILES/themes"
KITTY_DIR="$DOTFILES/kitty"

name="${1:-}"
if [ -z "$name" ]; then
  echo "usage: apply.sh <theme-name>" >&2
  echo "available:" >&2
  ls "$THEMES_DIR"/*.json | xargs -n1 basename | grep -v '^current\.json$' | sed 's/\.json$//' | sed 's/^/  /' >&2
  exit 1
fi

src="$THEMES_DIR/$name.json"
if [ ! -f "$src" ]; then
  echo "theme not found: $name" >&2
  echo "available:" >&2
  ls "$THEMES_DIR"/*.json | xargs -n1 basename | grep -v '^current\.json$' | sed 's/\.json$//' | sed 's/^/  /' >&2
  exit 1
fi

cp "$src" "$THEMES_DIR/current.json"
echo "→ themes/current.json set to $name"

# --- kitty ---
kitty_mode=$(jq -r '.kitty.mode' "$src")
case "$kitty_mode" in
  include)
    file=$(jq -r '.kitty.file' "$src")
    # Inline the contents so kitty's current-theme.conf is self-contained
    # (matches the format kitten themes writes).
    cat "$KITTY_DIR/$file" > "$KITTY_DIR/current-theme.conf"
    ;;
  kitten)
    theme=$(jq -r '.kitty.theme' "$src")
    if command -v kitten >/dev/null 2>&1; then
      kitten themes --reload-in=all --dump-theme "$theme" > "$KITTY_DIR/current-theme.conf"
    else
      echo "warn: kitten not on PATH, skipping kitty theme dump" >&2
    fi
    ;;
  *)
    echo "warn: unknown kitty.mode '$kitty_mode'" >&2
    ;;
esac
echo "→ kitty/current-theme.conf updated"

# Reload kitty (best-effort). --reload-in=all above already signaled for kitten mode;
# for include mode we still need to nudge running instances.
if pkill -USR1 -x kitty 2>/dev/null; then
  echo "→ kitty reloaded"
else
  echo "  (no running kitty found)"
fi

# --- tmux ---
if command -v tmux >/dev/null 2>&1 && tmux info >/dev/null 2>&1; then
  tmux source-file ~/.tmux.conf >/dev/null 2>&1 || true
  echo "→ tmux reloaded"
else
  echo "  (tmux not running; will pick up theme on next start)"
fi

# --- opencode ---
opencode_theme=$(jq -r '.opencode // empty' "$src")
if [ -n "$opencode_theme" ]; then
  tui_json="$HOME/.config/opencode/tui.json"
  if [ -f "$tui_json" ] || [ -L "$tui_json" ]; then
    tmp=$(mktemp)
    jq --arg t "$opencode_theme" '.theme = $t' "$tui_json" > "$tmp" && mv "$tmp" "$tui_json"
    echo "→ opencode theme set to $opencode_theme"
  fi
fi

# --- neovim ---
reloaded_any=0
for sock in $(ls /tmp/nvim.*/0 2>/dev/null; ls "${XDG_RUNTIME_DIR:-/tmp}"/nvim.*/0 2>/dev/null); do
  if [ -S "$sock" ]; then
    nvim --server "$sock" --remote-send '<Esc>:luafile $MYVIMRC<CR>' 2>/dev/null && reloaded_any=1 || true
  fi
done
if [ "$reloaded_any" = "1" ]; then
  echo "→ neovim reloaded"
else
  echo "  (no running nvim sockets found; reopen or :luafile \$MYVIMRC manually)"
fi

echo "done: $name"
