#!/usr/bin/env bash
if [ -z "$BETTER_VIM_LICENSE" ]
then
    echo "\BETTER_VIM_LICENSE is empty."
    exit 1
fi

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"brew update
brew update
brew upgrade
## -- General tools -------------------
brew install wget
brew install curl

## -- tmux ----------------------------
brew install tmux
brew install reattach-to-user-namespace
brew install gh
brew install lazygit

## -- Cask ----------------------------
brew install --cask raycast
brew install --cask iterm2
brew install --cask fig
brew install --cask arc

# -- NerdFonts ------------------------------
brew tap homebrew/cask-fonts
brew install --cask font-space-mono-nerd-font

# -- :BetterVim --------------------------
curl -L "https://bettervim.com/install/$BETTER_VIM_LICENSE" | bash
ln -sf $PWD/better-vim/better-vim.lua ~/.config/better-vim/

# -- git ---------------------------------
ln -s -f $PWD/env/.gitconfig ~/

# -- oh-my-zsh + zsh ---------------------
curl -o- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash
ln -s -f $PWD/env/.zshrc ~/

# -- tmux --------------------------------
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s -f $PWD/tmux/.tmux.conf ~/.tmux.conf

# -- nvm + custom nvm config for zsh ------ 
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install node
