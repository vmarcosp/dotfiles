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

# Optional work machine SDK; skip silently when the path is absent.
if [ -f "$HOME/.worktrees/faststore-ai-native-wt-docs-migrate-docs/google-cloud-sdk/path.zsh.inc" ]; then
  . "$HOME/.worktrees/faststore-ai-native-wt-docs-migrate-docs/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "$HOME/.worktrees/faststore-ai-native-wt-docs-migrate-docs/google-cloud-sdk/completion.zsh.inc" ]; then
  . "$HOME/.worktrees/faststore-ai-native-wt-docs-migrate-docs/google-cloud-sdk/completion.zsh.inc"
fi
