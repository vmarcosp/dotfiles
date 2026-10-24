#!/usr/bin/env bash
# An empty `last` save still counts as a file. Resurrect then kills the
# fresh session and the server exits. Skip that save, or use the newest
# non-empty one.

dir="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/resurrect"
last="$dir/last"
target="$(readlink -f "$last" 2>/dev/null || true)"

if [ ! -s "${target:-}" ]; then
  good=""
  for f in $(ls -t "$dir"/tmux_resurrect_*.txt 2>/dev/null); do
    if [ -s "$f" ]; then
      good="$f"
      break
    fi
  done
  if [ -z "$good" ]; then
    tmux display-message "Tmux resurrect save is empty; kept the new session."
    exit 0
  fi
  ln -sfn "$(basename "$good")" "$last"
fi

exec "$HOME/.config/tmux/plugins/tmux-resurrect/scripts/restore.sh" "$@"
