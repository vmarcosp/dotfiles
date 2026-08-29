#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() { printf '\n\033[1;34m==>\033[0m %s\n' "$*"; }

# -- Homebrew --------------------------------
if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

log "Updating Homebrew"
brew update
brew upgrade

log "Installing formulae"
brew install \
  wget \
  curl \
  tmux \
  reattach-to-user-namespace \
  gh \
  pidof \
  jq \
  lazygit \
  uv \
  bun \
  neovim \
  pnpm

log "Installing casks"
brew install --cask \
  raycast \
  rectangle \
  kitty \
  arc \
  discord \
  hiddenbar

# -- Nerd Fonts ------------------------------
log "Installing Nerd Fonts"
brew install --cask \
  font-symbols-only-nerd-font \
  font-jetbrains-mono-nerd-font

# -- git -------------------------------------
log "Linking git config"
ln -sfn "$DOTFILES/env/.gitconfig" ~/.gitconfig

# -- oh-my-zsh + zsh -------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  log "Installing oh-my-zsh"
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  git -C "$ZSH_CUSTOM/plugins/zsh-autosuggestions" pull --ff-only || true
fi

ln -sfn "$DOTFILES/env/.zshrc" ~/.zshrc

# -- kitty -----------------------------------
log "Linking kitty config"
mkdir -p ~/.config/kitty
ln -sfn "$DOTFILES/kitty/kitty.conf" ~/.config/kitty/kitty.conf
ln -sfn "$DOTFILES/kitty/yugen.conf" ~/.config/kitty/yugen.conf

# -- ghostty ---------------------------------
log "Linking ghostty config"
if [[ "$(uname -s)" == "Darwin" ]]; then
  GHOSTTY_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"
  mkdir -p "$GHOSTTY_DIR"
  ln -sfn "$DOTFILES/ghostty/config" "$GHOSTTY_DIR/config"
  ln -sfn "$DOTFILES/ghostty/yugen.conf" "$GHOSTTY_DIR/yugen.conf"
else
  mkdir -p ~/.config/ghostty
  ln -sfn "$DOTFILES/ghostty/config" ~/.config/ghostty/config
  ln -sfn "$DOTFILES/ghostty/yugen.conf" ~/.config/ghostty/yugen.conf
fi

# -- neovim ----------------------------------
log "Linking neovim config"
mkdir -p ~/.config
ln -sfn "$DOTFILES/nvim" ~/.config/nvim

# -- tmux ------------------------------------
log "Setting up tmux"
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  git -C ~/.tmux/plugins/tpm pull --ff-only || true
fi
ln -sfn "$DOTFILES/tmux/.tmux.conf" ~/.tmux.conf

# -- better-tmux -----------------------------
log "Setting up better-tmux"
mkdir -p ~/.config
ln -sfn "$DOTFILES/better-tmux" ~/.config/better-tmux
pnpm install --dir "$DOTFILES/better-tmux"

# -- agents (shared across AI tools) ---------
log "Linking shared agents"
ln -sfn "$DOTFILES/agents" ~/.agents

# -- claude code -----------------------------
log "Linking Claude Code config"
mkdir -p ~/.claude
rm -rf ~/.claude/agents ~/.claude/skills ~/.claude/commands ~/.claude/rules ~/.claude/workflows
ln -sfn "$DOTFILES/agents/AGENTS.md" ~/.claude/CLAUDE.md
ln -sfn "$DOTFILES/claude/settings.json" ~/.claude/settings.json
ln -sfn "$DOTFILES/agents/agents" ~/.claude/agents
ln -sfn "$DOTFILES/agents/skills" ~/.claude/skills
ln -sfn "$DOTFILES/agents/commands" ~/.claude/commands
ln -sfn "$DOTFILES/agents/rules" ~/.claude/rules
ln -sfn "$DOTFILES/claude/workflows" ~/.claude/workflows

# -- cursor ----------------------------------
log "Linking Cursor config"
mkdir -p ~/.cursor
rm -rf ~/.cursor/skills
ln -sfn "$DOTFILES/agents/skills" ~/.cursor/skills
ln -sfn "$DOTFILES/cursor/hooks.json" ~/.cursor/hooks.json
ln -sfn "$DOTFILES/cursor/mcp.json" ~/.cursor/mcp.json

# -- opencode -----------------------------------
log "Linking opencode plugins"
mkdir -p ~/.opencode
ln -sfn "$DOTFILES/opencode/plugins" ~/.opencode/plugins

# -- global scripts (bin) --------------------
log "Linking bin scripts"
mkdir -p ~/bin
ln -sfn "$DOTFILES/bin/awake" ~/bin/awake
ln -sfn "$DOTFILES/bin/gh-token-audit" ~/bin/gh-token-audit
ln -sfn "$DOTFILES/bin/worktree" ~/bin/worktree
ln -sfn "$DOTFILES/bin/pr-artifact" ~/bin/pr-artifact
ln -sfn "$DOTFILES/bin/vps-tunnel" ~/bin/vps-tunnel

# -- nvm + node ------------------------------
log "Installing nvm + node"
if [ ! -d "$HOME/.nvm" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi
export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm alias default 'lts/*'

log "Done. Restart your shell (or run 'exec zsh') to pick up the new config."
