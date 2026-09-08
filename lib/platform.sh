# Shared by install.sh, mac-compliance.sh, and zsh. Safe in bash and zsh.
# DOTFILES must be set by the caller.

is_macos() { [ "$(uname -s)" = Darwin ]; }
is_linux() { [ "$(uname -s)" = Linux ]; }
is_omarchy() { [ -d /usr/share/omarchy ] || command -v omarchy >/dev/null 2>&1; }

host_name() {
  if is_macos; then
    printf '%s\n' macos
  elif is_omarchy; then
    printf '%s\n' omarchy
  elif is_linux; then
    printf '%s\n' linux
  else
    printf '%s\n' unknown
  fi
}

log() { printf '\n\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\n\033[1;33m!!\033[0m %s\n' "$*"; }

# Replace dest with a symlink to src. Real files/dirs are moved aside first.
backup_then_link() {
  local src="$1" dest="$2"
  if [ ! -e "$src" ] && [ ! -L "$src" ]; then
    warn "skip link, missing source: $src"
    return 1
  fi
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    local bak="${dest}.bak.dotfiles.$(date +%s)"
    log "Backing up $dest -> $bak"
    mv "$dest" "$bak"
  fi
  ln -sfn "$src" "$dest"
}

link_bin_dir() {
  local dir="$1" f
  [ -d "$dir" ] || return 0
  mkdir -p "$HOME/bin" "$HOME/.local/bin"
  for f in "$dir"/*; do
    [ -e "$f" ] || continue
    [ -f "$f" ] || continue
    ln -sfn "$f" "$HOME/bin/$(basename "$f")"
    ln -sfn "$f" "$HOME/.local/bin/$(basename "$f")"
  done
}

resolve_dotfiles() {
  if [ -n "${DOTFILES:-}" ] && [ -d "$DOTFILES/lib" ]; then
    printf '%s\n' "$DOTFILES"
    return 0
  fi
  local candidate
  for candidate in \
    "${HOME}/Work/dotfiles" \
    "${HOME}/projects/dotfiles" \
    "${HOME}/dotfiles"; do
    if [ -d "$candidate/lib" ]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done
  return 1
}
