mktouch() {
  local p
  for p in "$@"; do
    mkdir -p "$(dirname "$p")"
  done
  touch "$@"
}

png2webp() {
  local file
  for file in *; do
    cwebp -q 100 "$file" -o "${file%.png}.webp"
  done
}

clean-swap() {
  rm -rf ~/.local/state/nvim/swap/**/*.swp
}

clean-branches() {
  git branch | grep -v 'main' | xargs git branch -D
}

kill-ports() {
  local port
  for port in "$@"; do
    lsof -ti:"$port" | xargs kill -9 2>/dev/null
  done
}

commit-sync() {
  git add .
  git commit -m "*"

  if ! git pull --rebase; then
    print -u2 "commit-sync: pull stopped with conflicts. Resolve them before pushing."
    return 1
  fi

  git push
}

commit-changelog() {
  local prefix
  prefix=$([ -n "$1" ] && echo "docs($1):" || echo "docs:")
  git commit -m "$prefix updated CHANGELOG.md"
}

ssh-vps() {
  local host="${1:-vps}"
  if [ -n "$TMUX" ]; then
    tmux set-option -g prefix C-a
    tmux bind-key C-a send-prefix
    trap 'tmux set-option -g prefix C-d; tmux bind-key C-d send-prefix' EXIT INT
  fi
  ssh "$host"
  if [ -n "$TMUX" ]; then
    tmux set-option -g prefix C-d
    tmux bind-key C-d send-prefix
    trap - EXIT INT
  fi
}

tmux-revert-prefix() {
  tmux set-option -g prefix C-d
  tmux bind-key C-d send-prefix
  echo "Prefix reverted to C-d"
}

alias vim="nvim"
alias avante='NVIM_AVANTE_MODE=1 nvim -c "lua vim.defer_fn(function() require(\"avante.api\").zen_mode() end, 100)"'
alias claudio="claude --model fable"
alias claudin="claude --model haiku"
alias h2='$(npm prefix -s)/node_modules/.bin/shopify hydrogen'
alias gemini="agy --dangerously-skip-permissions"
