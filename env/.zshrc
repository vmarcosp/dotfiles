export PATH=/opt/homebrew/bin:$PATH
export PATH=$HOME/.local/share/solana/install/active_release/bin:$PATH
export ZSH="/Users/marcos/.oh-my-zsh"
export NVM_DIR="$HOME/.nvm"
source ~/env-vars.sh
source $HOME/.cargo/env
source $ZSH/oh-my-zsh.sh

ZSH_THEME="robbyrussell"

plugins=(git)

alias rs="npx rescript build -w"
alias rsclean="npx rescript clean"
alias rsbuild="npx rescript clean && npx rescript build -w"

if [ "$TMUX" = "" ]; then tmux; fi

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

. $(brew --prefix asdf)/asdf.sh

function mktouch () {
  for p in $@; do
    mkdir -p $(dirname "$p")
  done

  touch $@
}

function png2webp () {
  for file in *; do
      cwebp -q 80 "$file" -o "${file%.png}.webp"
  done
}
