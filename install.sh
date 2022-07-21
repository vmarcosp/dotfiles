# git
ln -s -f $PWD/env/.gitconfig ~/

# zsh
ln -s -f $PWD/env/.zshrc ~/

# link tmux config
mkdir ~/tmux-themes/
ln -s -f $PWD/tmux/.tmux.conf.local ~/
ln -s -f $PWD/tmux/ayu-light.conf ~/tmux-themes/
ln -s -f $PWD/tmux/catpuccin.conf ~/tmux-themes/
ln -s -f $PWD/tmux/ayu.conf ~/tmux-themes/

# link nvim files
mkdir -p ~/.config/coc/extensions
mkdir -p ~/.config/nvim

ln -s -f $PWD/nvim/init.vim ~/.config/nvim/init.vim
ln -s -f $PWD/nvim/coc-settings.json ~/.config/nvim/coc-settings.json
ln -s -f $PWD/nvim/coc-package.json ~/.config/coc/extensions/package.json
ln -s -f $PWD/nvim/coc-db.json ~/.config/coc/extensions/db.json

# fix NVM/Node ZSH
git clone https://github.com/lukechilds/zsh-nvm.git ~/.zsh-nvm

source ~/.zsh-nvm/zsh-nvm.plugin.zsh

git clone https://github.com/tmux-plugins/tmux-resurrect ~/.config/tmux/
