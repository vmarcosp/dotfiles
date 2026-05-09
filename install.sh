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
ln -sfn "$DOTFILES/kitty/current-theme.conf" ~/.config/kitty/current-theme.conf

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
rm -rf ~/.claude/agents ~/.claude/skills ~/.claude/commands ~/.claude/rules
ln -sfn "$DOTFILES/agents/AGENTS.md" ~/.claude/CLAUDE.md
ln -sfn "$DOTFILES/claude/settings.json" ~/.claude/settings.json
ln -sfn "$DOTFILES/agents/agents" ~/.claude/agents
ln -sfn "$DOTFILES/agents/skills" ~/.claude/skills
ln -sfn "$DOTFILES/agents/commands" ~/.claude/commands
ln -sfn "$DOTFILES/agents/rules" ~/.claude/rules

# -- opencode -----------------------------------
log "Linking opencode plugins"
mkdir -p ~/.opencode
ln -sfn "$DOTFILES/.opencode/plugins" ~/.opencode/plugins

# -- global scripts (bin) --------------------
log "Linking bin scripts"
mkdir -p ~/bin
ln -sfn "$DOTFILES/bin/ai-notify" ~/bin/ai-notify
ln -sfn "$DOTFILES/bin/worktree" ~/bin/worktree

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
