# -- brew -------------------------------
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update
brew upgrade
brew install wget
brew install curl

# -- nvim + nvim plugins/configs ---------
brew install neovim
brew install python3
pip3 install --user --upgrade neovim
brew install ripgrep

# -- git --------------------------------
brew install git
ln -s -f $PWD/env/.gitconfig ~/

# -- oh-my-zsh + zsh ---------------------
touch ~/env-vars.sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
ln -s -f $PWD/env/.zshrc ~/

# -- tmux --------------------------------
brew install tmux
arch -arm64 brew install reattach-to-user-namespace
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s -f $PWD/tmux/.tmux.conf ~/.tmux.conf

# -- nvim --------------------------------
mkdir -p ~/.config/coc/extensions
mkdir -p ~/.config/nvim
ln -s -f $PWD/nvim/init.vim ~/.config/nvim/init.vim
ln -s -f $PWD/nvim/coc-settings.json ~/.config/nvim/coc-settings.json
ln -s -f $PWD/nvim/coc-package.json ~/.config/coc/extensions/package.json
ln -s -f $PWD/nvim/coc-db.json ~/.config/coc/extensions/db.json

# -- nvm + custom nvm plugin for zsh ------ 
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
git clone https://github.com/lukechilds/zsh-nvm.git ~/.zsh-nvm
source ~/.zsh-nvm/zsh-nvm.plugin.zsh

