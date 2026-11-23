#!/usr/bin/env bash
# Start `yokai --headless` detached from the agent's shell, with no terminal. State lives in files
# next to the log, so the watchdog and the orchestrator read it from any shell, across /compact.
#
#   run-yokai.sh start <worktree> <log-file>   start a run (refuses if one is alive)
#   run-yokai.sh status <log-file>             prints: RUNNING <pid> | EXITED <code> | STOPPED | NONE
#   run-yokai.sh stop <log-file>               stop the run; status becomes STOPPED
#
# Files beside the log: <log>.pid (the wrapper's pid), <log>.exit (exit code, or "stopped").
# Env: YOKAI_ARGS (default "--headless --max-iters 2"). Never pass --allow-gated.
set -u
cmd=${1:?start|status|stop}

status() {
  local log=$1
  if [ -f "$log.pid" ] && kill -0 "$(cat "$log.pid")" 2>/dev/null; then
    echo "RUNNING $(cat "$log.pid")"
  elif [ -f "$log.exit" ]; then
    local code; code=$(cat "$log.exit")
    if [ "$code" = stopped ]; then echo STOPPED; else echo "EXITED $code"; fi
  elif [ -f "$log.pid" ]; then
    echo "EXITED unknown"   # died without writing its code (killed from outside)
  else
    echo NONE
  fi
}

case "$cmd" in
  start)
    W=${2:?worktree}; LOG=${3:?log file}
    YOKAI_ARGS=${YOKAI_ARGS:-"--headless --max-iters 2"}
    case "$YOKAI_ARGS" in *--allow-gated*) echo "refusing --allow-gated" >&2; exit 2;; esac
    if status "$LOG" | grep -q '^RUNNING'; then
      echo "already $(status "$LOG")" >&2; exit 1
    fi
    touch "$LOG"; rm -f "$LOG.exit"
    echo "--- run-yokai start $(date '+%F %T') yokai $YOKAI_ARGS ---" >> "$LOG"
    # The wrapper records yokai's exit code; a TERM from `stop` records "stopped" instead.
    nohup bash -c '
      trap "echo stopped > \"$2.exit\"; kill \$child 2>/dev/null; exit 143" TERM INT
      cd "$1" || exit 1
      yokai '"$YOKAI_ARGS"' >> "$2" 2>&1 < /dev/null &
      child=$!
      wait $child; code=$?
      [ -f "$2.exit" ] || echo $code > "$2.exit"
    ' _ "$W" "$LOG" > /dev/null 2>&1 &
    echo $! > "$LOG.pid"
    echo "RUNNING $(cat "$LOG.pid")"
    ;;
  status)
    status "${2:?log file}"
    ;;
  stop)
    LOG=${2:?log file}
    if [ -f "$LOG.pid" ] && kill -0 "$(cat "$LOG.pid")" 2>/dev/null; then
      kill -TERM "$(cat "$LOG.pid")"
      for _ in 1 2 3 4 5 6 7 8 9 10; do kill -0 "$(cat "$LOG.pid")" 2>/dev/null || break; sleep 1; done
    fi
    status "$LOG"
    ;;
  *) echo "usage: run-yokai.sh start|status|stop" >&2; exit 2;;
esac
