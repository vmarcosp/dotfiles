#!/usr/bin/env bash
if [ -z "$BETTER_VIM_LICENSE" ]
then
    echo "\BETTER_VIM_LICENSE is empty."
    exit 1
fi

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update
brew upgrade

brew install wget
brew install curl
brew install tmux
brew install reattach-to-user-namespace
brew install gh
brew install pidof
brew install lazygit
brew install --cask raycast
brew install --cask kitty
brew install --cask arc
brew install --cask discord
brew install --cask logseq

# -- NerdFonts ------------------------------
bash ./scripts/install-nerd-fonts.sh

# -- :BetterVim --------------------------
curl -L "https://bettervim.com/install/$BETTER_VIM_LICENSE" | bash
ln -sf $PWD/better-vim/better-vim.lua ~/.config/better-vim/
ln -sf $PWD/yugem ~/yugem

# -- git ---------------------------------
ln -s -f $PWD/env/.gitconfig ~/

# -- oh-my-zsh + zsh ---------------------
curl -o- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash
ln -s -f $PWD/env/.zshrc ~/
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# -- kitty --------------------------------
ln -s $PWD/kitty/* ~/.config/kitty

# -- tmux --------------------------------
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s -f $PWD/tmux/.tmux.conf ~/.tmux.conf
ln -s -f $PWD/tmux/shifter.sh ~/shifter.sh
chmod +x ~/shifter.sh

# -- nvm + custom nvm config for zsh ------ 
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install node
