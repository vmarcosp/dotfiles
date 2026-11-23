#!/usr/bin/env bash
# Deterministic watchdog for an unattended Yokai run. Silent while healthy; it exits, waking the
# orchestrator (run it with the Bash tool's run_in_background), only when something needs a look.
# It restarts Yokai itself, at most MAX_RESTARTS times, when Yokai died without finishing, halting or
# reaching a gate.
#
#   watchdog.sh <worktree> <log-file> [precheck-command]
#
#   worktree         the repo the run commits to
#   log-file         the log run-yokai.sh writes (its .pid and .exit files sit beside it)
#   precheck-command optional; run every tick from the worktree. Non-zero exit → PRECHECK_FAILED.
#                    Example: ".koi/link-sukima.sh check || .koi/link-sukima.sh link"
#
# Env: INTERVAL (s, default 1800), STALE (s without log output while alive, default 3600),
#      MAX_RESTARTS (default 2), YOKAI_ARGS (default "--headless --max-iters 2").
#
# Exit lines (first word is the reason): NEW_COMMIT, STALLED, FINISHED, HALTED, DEAD, STOPPED,
# PRECHECK_FAILED. FINISHED/HALTED/DEAD carry run-yokai status, e.g. (EXITED 3).
# After each exit: look, decide, log the decision, start the watchdog again.
set -u
W=${1:?worktree}; LOG=${2:?log file}; PRECHECK=${3:-}
INTERVAL=${INTERVAL:-1800}; STALE=${STALE:-3600}; MAX_RESTARTS=${MAX_RESTARTS:-2}
YOKAI_ARGS=${YOKAI_ARGS:-"--headless --max-iters 2"}
RUN="$(dirname "$0")/run-yokai.sh"
export YOKAI_ARGS
restarts=0
cd "$W" || exit 1
touch "$LOG"
head0=$(git rev-parse HEAD)

mtime() { stat -f %m "$1" 2>/dev/null || stat -c %Y "$1"; }

while true; do
  sleep "$INTERVAL"
  age=$(( $(date +%s) - $(mtime "$LOG") ))

  if [ -n "$PRECHECK" ] && ! (cd "$W" && bash -c "$PRECHECK") >/dev/null 2>&1; then
    echo "PRECHECK_FAILED $PRECHECK"
    exit 0
  fi

  if [ "$(git rev-parse HEAD)" != "$head0" ]; then
    echo "NEW_COMMIT $(git log --oneline -1)"
    exit 0
  fi

  st=$("$RUN" status "$LOG")
  if [ "${st%% *}" = RUNNING ]; then
    if [ "$age" -gt "$STALE" ]; then
      echo "STALLED yokai alive, log silent for $((age / 60)) min"
      exit 0
    fi
    continue
  fi

  if [ "$st" = STOPPED ]; then
    echo "STOPPED by run-yokai.sh stop"
    exit 0
  fi
  tail_txt=$(grep -v stderr "$LOG" | tail -n 30)
  if printf '%s' "$tail_txt" | grep -q -E 'complete — no runnable phases|all phases \[done\]'; then
    echo "FINISHED all phases done ($st)"
    exit 0
  fi
  if printf '%s' "$tail_txt" | grep -q -E 'phase assessment required|is \[gated\]|cost ceiling|halt'; then
    echo "HALTED ($st) $(printf '%s' "$tail_txt" | grep -E 'halt|gated|assessment|ceiling' | tail -1)"
    exit 0
  fi
  if [ "$restarts" -ge "$MAX_RESTARTS" ]; then
    echo "DEAD ($st) after $restarts restarts; last: $(printf '%s' "$tail_txt" | tail -3 | tr '\n' ' ')"
    exit 0
  fi
  restarts=$(( restarts + 1 ))
  echo "--- watchdog restart $restarts $(date '+%F %T') ---" >> "$LOG"
  "$RUN" start "$W" "$LOG" >/dev/null
done
