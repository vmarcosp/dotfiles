# Already provided by Omarchy on a typical install: neovim, tmux, ghostty,
# lazygit, jq, mise, starship. This list is only the extras this repo needs.
# shellcheck disable=SC2034
OMARCHY_PACKAGES=(
  zsh
  eza
  zoxide
  fzf
  fd
  bat
  ttf-space-mono-nerd
  inter-font
  ttf-ibm-plex
  # Wayland typing for Voxtype. Omarchy's dictation installer pulls this too.
  wtype
  voxtype-bin
  # Mesh VPN. Each machine still logs in on its own: tailscale up --qr
  tailscale
)

# Official Linux desktop is the AppImage. CLI is npm (@doist/todoist-cli) via mise.
# shellcheck disable=SC2034
OMARCHY_AUR_PACKAGES=(
  todoist-appimage
  # Native Spotify client (crmne/spotifast). Playback needs Spotify Premium.
  spotifast-bin
)
