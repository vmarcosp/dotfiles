# CLAUDE.md

## Project Overview

This is a personal dotfiles repository containing configurations for a macOS development environment. The project includes customized setups for Neovim, Kitty terminal, tmux, and zsh, all using a custom theme called "yugen 幽玄".

## Project Structure

```
.
├── __assets/          # Screenshots and visual assets (versioned previews)
├── better-tmux/       # Custom tmux status bar (TypeScript/React)
├── cs/                # Counter-Strike autoexec configuration
├── env/               # Environment configuration files (.zshrc, .gitconfig)
├── kitty/             # Kitty terminal emulator configuration
├── nvim/              # Neovim configuration (uses lazy.nvim)
├── tmux/              # tmux configuration
├── wallpapers/        # Desktop wallpapers collection
├── install.sh         # Installation script for setting up dotfiles
└── README.md          # User-facing documentation
```

## Key Technologies & Tools

- **Neovim**: Main editor using lazy.nvim package manager
- **Kitty**: Terminal emulator with custom yugen theme
- **tmux**: Terminal multiplexer with custom configuration and better-tmux status bar
- **zsh**: Shell with oh-my-zsh framework
- **Node.js/pnpm**: Used for better-tmux TypeScript/React component

## Configuration Files

### Main Configuration Locations

- **Neovim**: `nvim/init.lua` (entry point)
  - Uses modular configuration under `nvim/lua/config/`
  - Package management via lazy.nvim
  - Custom theme: yugen

- **Shell**: `env/.zshrc`
  - oh-my-zsh integration
  - NVM (Node Version Manager) support
  - Custom functions: `mktouch`, `png2webp`, `clean-swap`, `clean-branches`, `commit-sync`
  - Vi-mode enabled
  - Auto-starts tmux on terminal launch

- **Terminal**: `kitty/kitty.conf`
  - Custom theme configuration in `kitty/yugen.conf`

- **Multiplexer**: `tmux/.tmux.conf`
  - Custom status bar powered by better-tmux
  - Uses tpm (tmux plugin manager)

- **Git**: `env/.gitconfig`

## Custom Functions (zsh)

Located in `env/.zshrc`:

- `mktouch()`: Creates file and all parent directories
- `png2webp()`: Batch converts PNG files to WebP format
- `clean-swap()`: Removes Neovim swap files
- `clean-branches()`: Deletes all Git branches except main
- `commit-sync()`: Quick add, commit, and push workflow

## Better TMUX

Custom tmux status bar implementation located in `better-tmux/`:
- Built with TypeScript and React
- Managed with pnpm
- Provides enhanced visual status information for tmux

## Theme: Yugen 幽玄

A consistent color theme applied across:
- Neovim
- Kitty terminal
- tmux status bar

## Development Setup

### Prerequisites
- macOS (Darwin-based)
- Homebrew
- Node.js/nvm
- oh-my-zsh
- tmux + tpm
- Neovim (with lazy.nvim)

### Installation
Run the installation script:
```bash
./install.sh
```

## Working with This Repository

### Making Changes

1. **Neovim Configuration**: Edit files in `nvim/lua/config/`
2. **Shell Config**: Modify `env/.zshrc` for shell customization
3. **Tmux**: Edit `tmux/.tmux.conf` or better-tmux components
4. **Kitty**: Update `kitty/kitty.conf` or theme in `kitty/yugen.conf`

### Common Tasks

- **Update screenshot**: Add versioned preview to `__assets/` (e.g., `v10.png`)
- **Better-tmux changes**: Navigate to `better-tmux/` and use pnpm commands
- **Sync dotfiles**: Use the `commit-sync` shell function

## Notes

- The project uses symlinks to place configuration files in appropriate system locations
- Assets folder contains versioned screenshots for documentation
- Git configuration and editor config are included for consistent development experience
- Counter-Strike config (`cs/autoexec.cfg`) included for gaming setup
