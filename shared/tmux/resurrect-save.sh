#!/usr/bin/env bash
# A save that races server shutdown writes an empty file and points `last`
# at it. The next start then exits. Keep the previous save instead.

dir="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/resurrect"
last="$dir/last"
before="$(readlink -f "$last" 2>/dev/null || true)"

"$HOME/.config/tmux/plugins/tmux-resurrect/scripts/save.sh" "$@"
status=$?

after="$(readlink -f "$last" 2>/dev/null || true)"
if [ -n "$after" ] && [ ! -s "$after" ]; then
  rm -f "$after"
  if [ -n "$before" ] && [ -s "$before" ] && [ "$before" != "$after" ]; then
    ln -sfn "$(basename "$before")" "$last"
  fi
fi

exit "$status"
