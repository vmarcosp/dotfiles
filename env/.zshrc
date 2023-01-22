# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
export PATH=/opt/homebrew/bin:$PATH
source ~/env-vars.sh

export ZSH="$HOME/.oh-my-zsh/"

ZSH_THEME="robbyrussell"
plugins=(git)

source $ZSH/oh-my-zsh.sh

if [ "$TMUX" = "" ]; then tmux; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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

alias rs="npx rescript build -w"
alias rsclean="npx rescript clean"
alias rsbuild="npx rescript clean && npx rescript build -w"

# opam configuration
[[ ! -r /Users/marcos/.opam/opam-init/init.zsh ]] || source /Users/marcos/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
