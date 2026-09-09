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
)

# Official Linux desktop is the AppImage. CLI is npm (@doist/todoist-cli) via mise.
# shellcheck disable=SC2034
OMARCHY_AUR_PACKAGES=(
  todoist-appimage
)
