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

# TPM + plugins live under XDG when ~/.config/tmux/tmux.conf exists (both hosts
# link that file). Matching that path keeps install_plugins and run-shell aligned.
tpm_plugins_dir() {
  echo "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins"
}

install_tpm() {
  local plugins tpm
  plugins="$(tpm_plugins_dir)"
  tpm="$plugins/tpm"
  mkdir -p "$plugins"

  if [ ! -d "$tpm" ]; then
    log "Installing tmux plugin manager"
    git clone https://github.com/tmux-plugins/tpm "$tpm"
  else
    git -C "$tpm" pull --ff-only || true
  fi

  # Drop the legacy clone if we migrated to XDG (harmless if absent).
  if [ -d "$HOME/.tmux/plugins/tpm" ] && [ "$tpm" != "$HOME/.tmux/plugins/tpm" ]; then
    rm -rf "$HOME/.tmux/plugins/tpm"
    rmdir "$HOME/.tmux/plugins" 2>/dev/null || true
  fi

  if [ -x "$tpm/bin/install_plugins" ]; then
    log "Installing tmux plugins (resurrect, sensible, …)"
    "$tpm/bin/install_plugins" || warn "TPM install_plugins failed; in tmux: prefix + I"
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

  mkdir -p "$HOME/.config/omarchy/hooks/theme-set.d" \
    "$HOME/.config/omarchy/hooks/font-set.d"
  backup_then_link "$DOTFILES/omarchy/hooks/theme-set.d/refresh-better-tmux" \
    "$HOME/.config/omarchy/hooks/theme-set.d/refresh-better-tmux"
  backup_then_link "$DOTFILES/omarchy/hooks/font-set.d/keep-split-fonts" \
    "$HOME/.config/omarchy/hooks/font-set.d/keep-split-fonts"

  mkdir -p "$HOME/.config/fontconfig/conf.d"
  backup_then_link "$DOTFILES/omarchy/fontconfig/fonts.conf" \
    "$HOME/.config/fontconfig/fonts.conf"
  backup_then_link "$DOTFILES/omarchy/fontconfig/conf.d/51-ui-fonts.conf" \
    "$HOME/.config/fontconfig/conf.d/51-ui-fonts.conf"

  mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
  backup_then_link "$DOTFILES/omarchy/gtk/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
  backup_then_link "$DOTFILES/omarchy/gtk/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"

  if command -v gsettings >/dev/null; then
    gsettings set org.gnome.desktop.interface font-name 'Inter 14'
    gsettings set org.gnome.desktop.interface document-font-name 'Inter 14'
  fi

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
  brew upgrade || warn "brew upgrade had errors; continuing with remaining setup"
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

install_todoist_cli_npm() {
  # Pin to mise Node. Cursor (and similar) put their own node first on PATH,
  # and npm then installs globals into that prefix — td never shows up in a
  # normal shell.
  local node_bin npm_bin prefix
  if command -v mise >/dev/null; then
    node_bin="$(mise which node 2>/dev/null || true)"
  fi
  if [ -z "${node_bin:-}" ] || [ ! -x "$node_bin" ]; then
    warn "mise Node not found; skip Todoist CLI (mise install node)"
    return 0
  fi
  prefix="$(cd "$(dirname "$node_bin")/.." && pwd)"
  npm_bin="$(dirname "$node_bin")/npm"
  if [ ! -x "$npm_bin" ]; then
    warn "mise npm not found at $npm_bin; skip Todoist CLI"
    return 0
  fi
  if [ -x "$prefix/bin/td" ] && [ -z "${TODOIST_CLI_FORCE:-}" ]; then
    log "Todoist CLI already at $prefix/bin/td"
    return 0
  fi
  log "Installing Todoist CLI (@doist/todoist-cli) into $prefix"
  "$npm_bin" install -g --prefix "$prefix" --allow-scripts=@doist/todoist-cli \
    @doist/todoist-cli
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
  if [ "${#OMARCHY_AUR_PACKAGES[@]}" -gt 0 ]; then
    log "Installing Omarchy AUR packages: ${OMARCHY_AUR_PACKAGES[*]}"
    if ! omarchy pkg aur add "${OMARCHY_AUR_PACKAGES[@]}"; then
      warn "omarchy pkg aur add failed. Run: omarchy pkg aur add ${OMARCHY_AUR_PACKAGES[*]}"
    fi
  fi
  install_todoist_cli_npm
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
if command -v td >/dev/null; then
  log "Todoist CLI is installed. Sign in once with: td auth login"
else
  warn "Todoist CLI (td) is not on PATH yet."
fi
if [ "$HOST" = omarchy ]; then
  log "Ghostty uses the Omarchy theme file (not yugen). Restart terminals to reload."
  log "Ghostty starts zsh via command = zsh. Login shell is still bash until: chsh -s /usr/bin/zsh"
  if command -v hyprctl >/dev/null; then
    hyprctl reload >/dev/null || true
    hyprctl configerrors || true
  fi
fi
log "Restart the shell (exec zsh) to pick up the new config."
