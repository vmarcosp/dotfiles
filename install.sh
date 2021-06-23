# mv git config
ln -s -f $PWD/env/.gitconfig ~/

# link nvim files
mkdir -p ~/.config/coc/extensions
mkdir -p ~/.config/nvim

ln -s -f $PWD/nvim/init.vim ~/.config/nvim/init.vim
ln -s -f $PWD/nvim/coc-settings.json ~/.config/nvim/coc-settings.json
ln -s -f $PWD/nvim/coc-package.json ~/.config/coc/extensions/package.json
ln -s -f $PWD/nvim/coc-db.json ~/.config/coc/extensions/db.json

# fix NVM/Node ZSH
# bash nvm-zsh.sh
