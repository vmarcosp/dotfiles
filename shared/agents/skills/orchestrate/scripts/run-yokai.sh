#!/usr/bin/env bash
# Start `yokai --headless` for an unattended run. Inside Rex (REX_SESSION and REX_BLOCK set), the run
# opens in a pane to the right of the orchestrator's pane, so Marcos watches it live; elsewhere it runs
# detached with nohup. Either way state lives in files next to the log, so the watchdog and the
# orchestrator read it from any shell, across /compact.
#
#   run-yokai.sh start <worktree> <log-file>   start a run (refuses if one is alive)
#   run-yokai.sh status <log-file>             prints: RUNNING <pid> | EXITED <code> | STOPPED | NONE
#   run-yokai.sh stop <log-file>               stop the run; status becomes STOPPED
#
# Files beside the log: <log>.pid (the wrapper's pid), <log>.exit (exit code, or "stopped"),
# <log>.block (the Rex pane's block id, Rex mode only).
# Env: YOKAI_ARGS (default "--headless --max-iters 2"). Never pass --allow-gated.
#      YOKAI_CMD (default "yokai"), for smoke tests only.
#      RUN_YOKAI_PANE=0 forces the nohup path even inside Rex.
set -u
cmd=${1:?start|status|stop}
SELF="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"

status() {
  local log=$1
  if [ -f "$log.pid" ] && kill -0 "$(cat "$log.pid")" 2>/dev/null; then
    echo "RUNNING $(cat "$log.pid")"
  elif [ -f "$log.exit" ]; then
    local code; code=$(cat "$log.exit")
    if [ "$code" = stopped ]; then echo STOPPED; else echo "EXITED $code"; fi
  elif [ -f "$log.pid" ]; then
    echo "EXITED unknown"   # died without writing its code (killed from outside, or its pane closed)
  else
    echo NONE
  fi
}

case "$cmd" in
  _run)
    # Internal: the wrapper. Records its own pid and yokai's exit code; a TERM from `stop` records
    # "stopped" instead. In a pane, output goes to the pane and to the log; otherwise to the log only.
    W=$2; LOG=$3; ARGS=$4; YCMD=$5; MODE=$6
    echo $$ > "$LOG.pid"
    trap 'echo stopped > "$LOG.exit"; kill $child 2>/dev/null; exit 143' TERM INT
    cd "$W" || { echo 1 > "$LOG.exit"; exit 1; }
    if [ "$MODE" = pane ]; then
      # shellcheck disable=SC2086
      $YCMD $ARGS < /dev/null > >(tee -a "$LOG") 2>&1 &
    else
      # shellcheck disable=SC2086
      $YCMD $ARGS < /dev/null >> "$LOG" 2>&1 &
    fi
    child=$!
    wait $child; code=$?
    [ -f "$LOG.exit" ] || echo $code > "$LOG.exit"
    echo "--- run-yokai exit $code $(date '+%F %T') ---" | tee -a "$LOG"
    exit $code
    ;;
  start)
    W=${2:?worktree}; LOG=${3:?log file}
    case "$LOG" in /*) ;; *) LOG="$PWD/$LOG";; esac
    YOKAI_ARGS=${YOKAI_ARGS:-"--headless --max-iters 2"}
    YOKAI_CMD=${YOKAI_CMD:-yokai}
    case "$YOKAI_ARGS" in *--allow-gated*) echo "refusing --allow-gated" >&2; exit 2;; esac
    if status "$LOG" | grep -q '^RUNNING'; then
      echo "already $(status "$LOG")" >&2; exit 1
    fi
    touch "$LOG"; rm -f "$LOG.exit" "$LOG.pid" "$LOG.block"
    echo "--- run-yokai start $(date '+%F %T') $YOKAI_CMD $YOKAI_ARGS ---" >> "$LOG"
    if [ "${RUN_YOKAI_PANE:-1}" != 0 ] && [ -n "${REX_SESSION:-}" ] && [ -n "${REX_BLOCK:-}" ] \
       && command -v rex > /dev/null; then
      out=$(rex split -s "$REX_SESSION" -b "$REX_BLOCK" --split=right --ratio 40 --focus=false \
        --keep-open -c "$W" --json -- bash "$SELF" _run "$W" "$LOG" "$YOKAI_ARGS" "$YOKAI_CMD" pane) \
        || { echo "rex split failed: $out" >&2; exit 1; }
      printf '%s' "$out" | tr -d ' \n' | sed -n 's/.*"block_ids":\["\([^"]*\)".*/\1/p' > "$LOG.block"
      for _ in 1 2 3 4 5 6 7 8 9 10; do [ -f "$LOG.pid" ] && break; sleep 1; done
      [ -f "$LOG.pid" ] || { echo "pane opened but the wrapper did not start" >&2; exit 1; }
      echo "RUNNING $(cat "$LOG.pid") pane $(cat "$LOG.block")"
    else
      nohup bash "$SELF" _run "$W" "$LOG" "$YOKAI_ARGS" "$YOKAI_CMD" detached > /dev/null 2>&1 &
      for _ in 1 2 3 4 5; do [ -f "$LOG.pid" ] && break; sleep 1; done
      echo "RUNNING $(cat "$LOG.pid" 2>/dev/null || echo "$!")"
    fi
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
