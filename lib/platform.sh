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

# MCP configs stay machine-local. If ~/.cursor/mcp.json is a repo symlink, copy it to a regular file.
localize_cursor_mcp() {
  local dest="$HOME/.cursor/mcp.json"
  local tmp="${dest}.dotfiles-local"
  mkdir -p "$HOME/.cursor"

  [ -L "$dest" ] || return 0

  if [ -f "$dest" ]; then
    cp "$dest" "$tmp"
  elif [ -f "$DOTFILES/shared/cursor/mcp.json" ]; then
    cp "$DOTFILES/shared/cursor/mcp.json" "$tmp"
  else
    local commit=""
    commit="$(git -C "$DOTFILES" log -1 --format=%H -- shared/cursor/mcp.json 2>/dev/null || true)"
    if [ -z "$commit" ] || ! git -C "$DOTFILES" show "$commit:shared/cursor/mcp.json" >"$tmp" 2>/dev/null; then
      warn "Could not materialize $dest from the old symlink; fix it by hand."
      rm -f "$tmp"
      return 0
    fi
  fi

  rm -f "$dest"
  mv "$tmp" "$dest"
  log "Left $dest as a local file (not managed by this repo)"
}

# Playwright + Context7 on this machine only (never committed).
ensure_local_mcp() {
  localize_cursor_mcp
  python3 - "$@" <<'PY'
import json
from pathlib import Path

cursor_path = Path.home() / ".cursor" / "mcp.json"
cursor_path.parent.mkdir(parents=True, exist_ok=True)
if cursor_path.is_symlink():
    raise SystemExit("cursor mcp.json is still a symlink")
cursor = {"mcpServers": {}}
if cursor_path.is_file():
    cursor = json.loads(cursor_path.read_text())
servers = cursor.setdefault("mcpServers", {})
servers["playwright"] = {
    "command": "npx",
    "args": ["-y", "@playwright/mcp@latest"],
}
servers["context7"] = {
    "url": "https://mcp.context7.com/mcp",
    "headers": {"CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"},
}
cursor_path.write_text(json.dumps(cursor, indent=2) + "\n")
cursor_path.chmod(0o600)

opencode_path = Path.home() / ".config" / "opencode" / "mcp.local.json"
opencode_path.parent.mkdir(parents=True, exist_ok=True)
opencode = {"$schema": "https://opencode.ai/config.json", "mcp": {}}
if opencode_path.is_file() and not opencode_path.is_symlink():
    opencode = json.loads(opencode_path.read_text())
mcp = opencode.setdefault("mcp", {})
mcp["playwright"] = {
    "type": "local",
    "command": ["npx", "-y", "@playwright/mcp@latest"],
    "enabled": True,
}
mcp["context7"] = {
    "type": "remote",
    "url": "https://mcp.context7.com/mcp",
    "enabled": True,
    "headers": {"CONTEXT7_API_KEY": "{env:CONTEXT7_API_KEY}"},
}
opencode["$schema"] = "https://opencode.ai/config.json"
opencode_path.write_text(json.dumps(opencode, indent=2) + "\n")
opencode_path.chmod(0o600)
print(f"wrote {cursor_path}")
print(f"wrote {opencode_path}")
PY
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
