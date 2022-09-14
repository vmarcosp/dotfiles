# -- git ---------------------
ln -s -f $PWD/env/.gitconfig ~/

# -- zsh ---------------------
ln -s -f $PWD/env/.zshrc ~/

# -- tmux --------------------
mkdir ~/tmux-themes/
ln -s -f $PWD/tmux/.tmux.conf ~/.tmux.conf

# -- nvim -------------------
mkdir -p ~/.config/coc/extensions
mkdir -p ~/.config/nvim

ln -s -f $PWD/nvim/init.vim ~/.config/nvim/init.vim
ln -s -f $PWD/nvim/coc-settings.json ~/.config/nvim/coc-settings.json
ln -s -f $PWD/nvim/coc-package.json ~/.config/coc/extensions/package.json
ln -s -f $PWD/nvim/coc-db.json ~/.config/coc/extensions/db.json

# -- fix nvm with zsh ------ 
git clone https://github.com/lukechilds/zsh-nvm.git ~/.zsh-nvm
source ~/.zsh-nvm/zsh-nvm.plugin.zsh

