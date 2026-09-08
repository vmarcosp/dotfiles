# Omarchy-only zsh. Sourced from shared/zsh/.zshrc.
# Keep bash-only Omarchy files (shopt, bind -f) out of this file.

if [ -r /usr/share/omarchy/default/bash/env-bootstrap ]; then
  # shellcheck disable=SC1091
  . /usr/share/omarchy/default/bash/env-bootstrap
fi

: "${OMARCHY_PATH:=/usr/share/omarchy}"

if [ -f "$OMARCHY_PATH/default/bash/aliases" ]; then
  # shellcheck disable=SC1091
  . "$OMARCHY_PATH/default/bash/aliases"
fi

# Do not source $OMARCHY_PATH/default/bash/functions — those files are bash
# and collide with oh-my-zsh git aliases (e.g. ga()).

if command -v mise >/dev/null; then
  eval "$(mise activate zsh)"
fi

if command -v zoxide >/dev/null; then
  eval "$(zoxide init zsh)"
fi

export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export PATH="$HOME/.opencode/bin:$PATH"
