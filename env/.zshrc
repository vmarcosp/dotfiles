export PATH=/opt/homebrew/bin:$PATH
source ~/env-vars.sh

export ZSH="$HOME/.oh-my-zsh/"

ZSH_THEME="robbyrussell"
plugins=(
  git
  vi-mode
)

source $ZSH/oh-my-zsh.sh

if [ "$TMUX" = "" ]; then tmux; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$PATH:/usr/local/bin

function mktouch () {
  for p in $@; do
    mkdir -p $(dirname "$p")
  done

  touch $@
}

function png2webp () {
  for file in *; do
      cwebp -q 100 "$file" -o "${file%.png}.webp"
  done
}

function clean-swap(){
  rm -rf ~/.local/state/nvim/swap/**/*.swp
}

function clean-branches(){
  git branch | grep -v 'main' | xargs git branch -D
}

function commit-sync() {
  git add .
  git commit -m "*"
  git push
}

function commit-changelog() {
  prefix=$( [ -n "$1" ] && echo "docs($1):" || echo "docs:" )
  git commit -m "$prefix updated CHANGELOG.md"
}

alias vim="nvim"

# pnpm
export PNPM_HOME="/Users/marcosoliveira/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
