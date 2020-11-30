# mv vscode settings.json
cp vscode/settings.json ~/.config/Code/User/settings.json

# mv git config
cp .gitconfig ~/

# Fix NVM/Node ZSH
bash nvm-zsh.sh
