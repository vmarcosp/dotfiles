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

if [[ -z "${TMUX:-}" && -o interactive && -t 0 ]] && command -v tmux >/dev/null; then
  tmux
fi
