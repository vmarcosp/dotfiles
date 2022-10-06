#!/usr/bin/env bash

brew update
brew upgrade
brew install wget
brew install curl
brew install neovim
brew install python3
pip3 install --user --upgrade neovim
brew install ripgrep
brew install tmux
arch -arm64 brew install reattach-to-user-namespace
brew install git

ln -s -f $PWD/env/.gitconfig ~/

# -- oh-my-zsh + zsh ---------------------
touch ~/env-vars.sh
curl -o- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash
ln -s -f $PWD/env/.zshrc ~/

# -- tmux --------------------------------
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s -f $PWD/tmux/.tmux.conf ~/.tmux.conf

# -- nvim --------------------------------
mkdir -p ~/.config/nvim
mkdir -p ~/.config/coc/extensions
touch ~/.config/coc/extensions/package.json
touch ~/.config/coc/extensions/db.json
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
ln -s -f $PWD/nvim/modules/ ~/.config/nvim/
ln -s -f $PWD/nvim/init.vim ~/.config/nvim/init.vim
ln -s -f $PWD/nvim/coc-settings.json ~/.config/nvim/coc-settings.json
n -s -f $PWD/nvim/UltiSnips ~/.config/nvim
ln -s -f $PWD/nvim/coc-package.json ~/.config/coc/extensions/package.json
ln -s -f $PWD/nvim/coc-db.json ~/.config/coc/extensions/db.json

# -- wezterm -----------------------------
mkdir ~/.config/wezterm/
ln -s -f $PWD/wezterm/wezterm.lua ~/.config/wezterm/

# -- nvm + custom nvm config for zsh ------ 
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install node
