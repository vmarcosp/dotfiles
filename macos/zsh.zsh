# macOS-only zsh. Sourced from shared/zsh/.zshrc.

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

export PATH="$PATH:/usr/local/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export PATH="$HOME/.opencode/bin:$PATH"

cursor() {
  : "${CURSOR_API_KEY:?Set CURSOR_API_KEY in ~/env-vars.sh}"
  CURSOR_CONFIG_DIR="${CURSOR_CONFIG_DIR:-$HOME/.cursor-cli/work}" \
    command cursor agent "$@"
}

cursorp() {
  : "${CURSORP_API_KEY:?Set CURSORP_API_KEY in ~/env-vars.sh}"
  CURSOR_API_KEY="$CURSORP_API_KEY" \
  CURSOR_CONFIG_DIR="${CURSOR_CONFIG_DIR:-$HOME/.cursor-cli/personal}" \
    command cursor agent "$@"
}

# Optional work machine SDK; skip silently when the path is absent.
if [ -f "$HOME/.worktrees/faststore-ai-native-wt-docs-migrate-docs/google-cloud-sdk/path.zsh.inc" ]; then
  . "$HOME/.worktrees/faststore-ai-native-wt-docs-migrate-docs/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "$HOME/.worktrees/faststore-ai-native-wt-docs-migrate-docs/google-cloud-sdk/completion.zsh.inc" ]; then
  . "$HOME/.worktrees/faststore-ai-native-wt-docs-migrate-docs/google-cloud-sdk/completion.zsh.inc"
fi
