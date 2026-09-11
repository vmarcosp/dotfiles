# Shared zsh. Host-specific bits live in macos/zsh.zsh and omarchy/zsh.zsh.

_zshrc="${HOME}/.zshrc"
if [ -L "$_zshrc" ]; then
  _zshrc="$(readlink "$_zshrc")"
fi
DOTFILES="$(cd "$(dirname "$_zshrc")/../.." && pwd)"
unset _zshrc

# shellcheck disable=SC1091
. "$DOTFILES/lib/platform.sh"

[[ -f "$HOME/env-vars.sh" ]] && source "$HOME/env-vars.sh"

# OpenCode merges this over the git-linked ~/.config/opencode/opencode.json
if [[ -z "${OPENCODE_CONFIG:-}" && -f "$HOME/.config/opencode/mcp.local.json" ]]; then
  export OPENCODE_CONFIG="$HOME/.config/opencode/mcp.local.json"
fi

export LANG=en_US.UTF-8
export EDITOR="nvim"
export PATH="$HOME/.local/bin:$HOME/bin:$DOTFILES/shared/bin:$DOTFILES/$(host_name)/bin:$DOTFILES/shared/better-tmux/node_modules/.bin:$PATH"

export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_THEME="robbyrussell"
plugins=(git vi-mode)

if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

source "$DOTFILES/shared/zsh/functions.zsh"

host="$(host_name)"
if [[ -f "$DOTFILES/$host/zsh.zsh" ]]; then
  source "$DOTFILES/$host/zsh.zsh"
fi

if [[ -z "${TMUX:-}" && -o interactive && -t 0 && -t 1 ]] && command -v tmux >/dev/null; then
  # A package upgrade leaves the old server running; the new client then can't
  # attach and only says "open terminal failed: not a terminal".
  _tmux_client="${$(tmux -V)#tmux }"
  _tmux_server="$(tmux display-message -p '#{version}' 2>/dev/null)"
  if [[ -n "$_tmux_server" && "$_tmux_server" != "$_tmux_client" ]]; then
    print -u2 "tmux server is $_tmux_server, client is $_tmux_client — not attaching."
    print -u2 "Save sessions with prefix + C-s in the old client, then: tmux kill-server"
  else
    tmux
  fi
  unset _tmux_client _tmux_server
fi
