#!/usr/bin/env bash
# Claude Code status line (yugen themed).
# Reads the session JSON from stdin and prints a single line:
#   <model> · <git branch> · <context tokens used>/<window> (<pct>%)
# Configured via the `statusLine` field in claude/settings.json.

input=$(cat)

# yugen palette (truecolor)
orange=$'\033[38;2;255;190;137m' # accent / model
green=$'\033[38;2;143;188;156m'
yellow=$'\033[38;2;255;242;175m'
red=$'\033[38;2;245;122;122m'
gray=$'\033[38;2;128;128;128m'
reset=$'\033[0m'

# Pull every field in a single jq pass. @tsv keeps a model name with spaces intact.
IFS=$'\t' read -r model used total pct < <(
  printf '%s' "$input" | jq -r '[
    (.model.display_name // "?"),
    (.context_window.total_input_tokens // 0),
    (.context_window.context_window_size // 200000),
    ((.context_window.used_percentage // 0) | floor)
  ] | @tsv'
)

# Resolve the branch from the session's working dir (robust to detached HEAD / no repo).
dir=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // "."')
branch=$(git -C "$dir" branch --show-current 2>/dev/null)

# 42500 -> 42.5k, 200000 -> 200k, 1000000 -> 1M, 999 -> 999
human() {
  awk -v n="$1" 'BEGIN {
    if (n >= 1000000)   { v = n / 1000000; s = "M" }
    else if (n >= 1000) { v = n / 1000;    s = "k" }
    else                { printf "%d", n; exit }
    if (v == int(v)) printf "%d%s", v, s
    else             printf "%.1f%s", v, s
  }'
}

# Color the context usage by how full the window is.
if   [ "${pct:-0}" -ge 90 ]; then ctx="$red"
elif [ "${pct:-0}" -ge 70 ]; then ctx="$yellow"
else                              ctx="$green"
fi

line="${orange}${model}${reset}"
[ -n "$branch" ] && line+=" ${gray}·${reset} ${green} ${branch}${reset}"
line+=" ${gray}·${reset} ${ctx}$(human "$used")${gray}/$(human "$total") (${pct}%)${reset}"

printf '%s\n' "$line"
