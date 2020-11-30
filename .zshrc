
ZSH_DISABLE_COMPFIX=true
export ZSH="/Users/vmarcosp/.oh-my-zsh"
export NVM_DIR="$HOME/.nvm"
source $ZSH/oh-my-zsh.sh

ZSH_THEME="avit"
plugins=(git)

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
