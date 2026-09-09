#!/usr/bin/env bash
# Bootstrap this repo on macOS or Omarchy. Idempotent: safe to re-run after git pull.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "$DOTFILES/lib/platform.sh"

HOST="$(host_name)"
log "Dotfiles: $DOTFILES (host: $HOST)"

install_oh_my_zsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log "Installing oh-my-zsh"
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
      "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
      "" --unattended
  fi
  local custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  if [ ! -d "$custom/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
      "$custom/plugins/zsh-autosuggestions"
  else
    git -C "$custom/plugins/zsh-autosuggestions" pull --ff-only || true
  fi
}

install_tpm() {
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    log "Installing tmux plugin manager"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  else
    git -C "$HOME/.tmux/plugins/tpm" pull --ff-only || true
  fi
}

# CLI binaries: https://github.com/bettervim/better-tmux/releases
BETTER_TMUX_VERSION="${BETTER_TMUX_VERSION:-0.0.15}"

install_better_tmux_cli() {
  local os arch asset dest url tmp
  dest="$HOME/.local/bin/better-tmux"
  mkdir -p "$HOME/.local/bin"

  case "$(uname -s)" in
    Darwin) os=darwin ;;
    Linux) os=linux ;;
    *) warn "No better-tmux release for $(uname -s)"; return 0 ;;
  esac
  case "$(uname -m)" in
    x86_64|amd64) arch=x64 ;;
    arm64|aarch64) arch=arm64 ;;
    *) warn "No better-tmux release for $(uname -m)"; return 0 ;;
  esac
  asset="better-tmux-${os}-${arch}"

  if [ -x "$dest" ] && [ -z "${BETTER_TMUX_FORCE:-}" ]; then
    log "better-tmux CLI already at $dest"
    return 0
  fi

  url="https://github.com/bettervim/better-tmux/releases/download/v${BETTER_TMUX_VERSION}/${asset}"
  tmp="${dest}.tmp"
  log "Downloading $asset (v${BETTER_TMUX_VERSION})"
  curl -fL --retry 3 -o "$tmp" "$url"
  chmod +x "$tmp"
  mv "$tmp" "$dest"
}

install_better_tmux() {
  local dir="$DOTFILES/shared/better-tmux"
  install_better_tmux_cli
  log "Installing better-tmux JS deps"
  if command -v pnpm >/dev/null; then
    pnpm install --dir "$dir"
  elif command -v npm >/dev/null; then
    npm install --prefix "$dir"
  else
    warn "pnpm/npm not found; skip better-tmux JS deps"
  fi
}

link_shared() {
  log "Linking shared config"
  backup_then_link "$DOTFILES/shared/git/.gitconfig" "$HOME/.gitconfig"
  backup_then_link "$DOTFILES/shared/zsh/.zshrc" "$HOME/.zshrc"
  backup_then_link "$DOTFILES/shared/nvim" "$HOME/.config/nvim"
  backup_then_link "$DOTFILES/shared/tmux/.tmux.conf" "$HOME/.tmux.conf"
  # tmux 3.2+ prefers XDG over ~/.tmux.conf when this file exists (Omarchy ships one).
  mkdir -p "$HOME/.config/tmux"
  backup_then_link "$DOTFILES/shared/tmux/.tmux.conf" "$HOME/.config/tmux/tmux.conf"
  backup_then_link "$DOTFILES/shared/better-tmux" "$HOME/.config/better-tmux"

  backup_then_link "$DOTFILES/shared/agents" "$HOME/.agents"
  mkdir -p "$HOME/.claude"
  backup_then_link "$DOTFILES/shared/agents/AGENTS.md" "$HOME/.claude/CLAUDE.md"
  backup_then_link "$DOTFILES/shared/claude/settings.json" "$HOME/.claude/settings.json"
  backup_then_link "$DOTFILES/shared/agents/agents" "$HOME/.claude/agents"
  backup_then_link "$DOTFILES/shared/agents/skills" "$HOME/.claude/skills"
  backup_then_link "$DOTFILES/shared/agents/commands" "$HOME/.claude/commands"
  backup_then_link "$DOTFILES/shared/agents/rules" "$HOME/.claude/rules"
  backup_then_link "$DOTFILES/shared/claude/workflows" "$HOME/.claude/workflows"

  mkdir -p "$HOME/.cursor"
  backup_then_link "$DOTFILES/shared/agents/skills" "$HOME/.cursor/skills"
  backup_then_link "$DOTFILES/shared/cursor/hooks.json" "$HOME/.cursor/hooks.json"
  ensure_local_mcp

  mkdir -p "$HOME/.opencode" "$HOME/.config/opencode"
  backup_then_link "$DOTFILES/shared/opencode/plugins" "$HOME/.opencode/plugins"
  backup_then_link "$DOTFILES/shared/opencode/tui.jsonc" "$HOME/.config/opencode/tui.jsonc"
  backup_then_link "$DOTFILES/shared/opencode/tui.jsonc" "$HOME/.config/opencode/tui.json"
  backup_then_link "$DOTFILES/shared/opencode/themes" "$HOME/.config/opencode/themes"
  backup_then_link "$DOTFILES/shared/opencode/opencode.json" "$HOME/.config/opencode/opencode.json"

  link_bin_dir "$DOTFILES/shared/bin"
}

link_macos() {
  log "Linking macOS config"
  mkdir -p "$HOME/.config/kitty"
  backup_then_link "$DOTFILES/macos/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
  backup_then_link "$DOTFILES/macos/kitty/yugen.conf" "$HOME/.config/kitty/yugen.conf"

  local ghostty="$HOME/Library/Application Support/com.mitchellh.ghostty"
  mkdir -p "$ghostty"
  backup_then_link "$DOTFILES/macos/ghostty/config" "$ghostty/config"
  backup_then_link "$DOTFILES/macos/ghostty/yugen.conf" "$ghostty/yugen.conf"

  link_bin_dir "$DOTFILES/macos/bin"
}

link_omarchy() {
  log "Linking Omarchy config"
  mkdir -p "$HOME/.config/ghostty"
  backup_then_link "$DOTFILES/omarchy/ghostty/config" "$HOME/.config/ghostty/config"

  backup_then_link "$DOTFILES/omarchy/hypr" "$HOME/.config/hypr"

  mkdir -p "$HOME/.config/omarchy/defaults" "$HOME/.config/omarchy/extensions"
  backup_then_link "$DOTFILES/omarchy/config/shell.json" "$HOME/.config/omarchy/shell.json"
  backup_then_link "$DOTFILES/omarchy/config/shell.toml" "$HOME/.config/omarchy/shell.toml"
  backup_then_link "$DOTFILES/omarchy/config/defaults/agent" "$HOME/.config/omarchy/defaults/agent"
  backup_then_link "$DOTFILES/omarchy/config/branding" "$HOME/.config/omarchy/branding"
  backup_then_link "$DOTFILES/omarchy/config/extensions/omarchy-menu.jsonc" \
    "$HOME/.config/omarchy/extensions/omarchy-menu.jsonc"

  mkdir -p "$HOME/.config/omarchy/hooks/theme-set.d"
  backup_then_link "$DOTFILES/omarchy/hooks/theme-set.d/refresh-better-tmux" \
    "$HOME/.config/omarchy/hooks/theme-set.d/refresh-better-tmux"

  link_bin_dir "$DOTFILES/omarchy/bin"
}

install_macos() {
  # shellcheck disable=SC1091
  . "$DOTFILES/macos/packages.sh"

  if ! command -v brew >/dev/null; then
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
  brew install "${MACOS_FORMULAE[@]}"
  log "Installing casks"
  brew install --cask "${MACOS_CASKS[@]}"
  log "Installing Nerd Fonts"
  brew install --cask "${MACOS_FONTS[@]}"

  if [ ! -d "$HOME/.nvm" ]; then
    log "Installing nvm + node"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  fi
  export NVM_DIR="$HOME/.nvm"
  # shellcheck disable=SC1091
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm install --lts
  nvm alias default 'lts/*'
}

install_omarchy_pkgs() {
  # shellcheck disable=SC1091
  . "$DOTFILES/omarchy/packages.sh"
  if ! command -v omarchy >/dev/null; then
    warn "omarchy CLI not found; skip package install"
    return 0
  fi
  log "Installing Omarchy packages: ${OMARCHY_PACKAGES[*]}"
  if ! omarchy pkg add "${OMARCHY_PACKAGES[@]}"; then
    warn "omarchy pkg add failed (sudo?). Run: omarchy pkg add ${OMARCHY_PACKAGES[*]}"
  fi
}

case "$HOST" in
  macos) install_macos ;;
  omarchy) install_omarchy_pkgs ;;
  *) warn "Unknown host '$HOST'. Shared links will still be applied." ;;
esac

install_oh_my_zsh
link_shared
install_tpm

case "$HOST" in
  macos) link_macos ;;
  omarchy) link_omarchy ;;
esac

install_better_tmux

log "Done. Host=$HOST"
if [ "$HOST" = omarchy ]; then
  log "Ghostty uses the Omarchy theme file (not yugen). Restart terminals to reload."
  log "Ghostty starts zsh via command = zsh. Login shell is still bash until: chsh -s /usr/bin/zsh"
  if command -v hyprctl >/dev/null; then
    hyprctl reload >/dev/null || true
    hyprctl configerrors || true
  fi
fi
log "Restart the shell (exec zsh) to pick up the new config."
