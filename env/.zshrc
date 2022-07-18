export PATH=/opt/homebrew/bin:$PATH
source ~/env-vars.sh
export PATH=$HOME/.local/share/solana/install/active_release/bin:$PATH
source $HOME/.cargo/env

export ZSH="/Users/marcos/.oh-my-zsh"

ZSH_THEME="robbyrussell"
plugins=(git)

source $ZSH/oh-my-zsh.sh

alias rs="npx rescript build -w"
alias rsclean="npx rescript clean"
alias rsbuild="npx rescript clean && npx rescript build -w"
if [ "$TMUX" = "" ]; then tmux; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

. $(brew --prefix asdf)/asdf.sh

function mktouch () {
  for p in $@; do
    mkdir -p $(dirname "$p")
  done

  touch $@
}

[ -f "/Users/marcos/.ghcup/env" ] && source "/Users/marcos/.ghcup/env" # ghcup-env

function png2webp () {
  for file in *; do
      cwebp -q 80 "$file" -o "${file%.png}.webp"
  done
}

export PATH="$PATH:$HOME/.spicetify"
