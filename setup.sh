# Create setups folder
mkdir _setups

# Code extensions
code --install-extension dbaeumer.vscode-eslint
code --install-extension jpoissonnier.vscode-styled-component
code --install-extension robertohuertasm.vscode-icons
code --install-extension obinbentley.sass-indented
code --install-extension silvenon.mdx
code --install-extension dsznajder.es7-react-js-snippets
code --install-extension dracula-theme.theme-dracula

# Mv git config
cp .gitconfig ~/

# Install Monaco font
bash fonts/monaco.sh

# Fix NVM/Node ZSH
bash nvm-zsh.sh
