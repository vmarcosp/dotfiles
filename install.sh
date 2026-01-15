#!/usr/bin/env bash
if [ -z "$BETTER_VIM_LICENSE" ]
then
    echo "\BETTER_VIM_LICENSE is empty."
    exit 1
fi

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update
brew upgrade

brew install wget
brew install curl
brew install tmux
brew install reattach-to-user-namespace
brew install gh
brew install pidof
brew install jq
brew install lazygit
brew install oven-sh/bun/bun
brew install --cask raycast
brew install --cask rectangle
brew install --cask kitty
brew install --cask arc
brew install --cask discord
brew install --cask hiddenbar

# -- NerdFonts ------------------------------
bash ./scripts/install-nerd-fonts.sh

# -- :BetterVim --------------------------
curl -L "https://bettervim.com/install/$BETTER_VIM_LICENSE" | bash
ln -sf $PWD/better-vim/better-vim.lua ~/.config/better-vim/
ln -sf $PWD/yugem ~/yugem

# -- git ---------------------------------
ln -s -f $PWD/env/.gitconfig ~/

# -- oh-my-zsh + zsh ---------------------
curl -o- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash
ln -s -f $PWD/env/.zshrc ~/
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# -- kitty --------------------------------
ln -s $PWD/kitty/yugen.conf ~/.config/kitty
ln -s $PWD/kitty/kitty.conf ~/.config/kitty

# -- tmux --------------------------------
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s -f $PWD/tmux/.tmux.conf ~/.tmux.conf
ln -s -f $PWD/better-tmux ~/.config
bun install --cwd ./better-tmux

# -- claude code ---------------------------
rm -rf ~/.claude/agents ~/.claude/skills ~/.claude/commands
rm -f ~/.claude/CLAUDE.md ~/.claude/settings.json
ln -s -f $PWD/.claude/CLAUDE.md ~/.claude/CLAUDE.md
ln -s -f $PWD/.claude/settings.json ~/.claude/settings.json
ln -sfn $PWD/.claude/agents ~/.claude/agents
ln -sfn $PWD/.claude/skills ~/.claude/skills
ln -sfn $PWD/.claude/commands ~/.claude/commands

# Add MCP servers globally (user scope)
for server in $(jq -r 'keys[]' $PWD/claude/mcp-servers.json); do
    claude mcp remove -s user "$server" 2>/dev/null || true
    cmd=$(jq -r ".\"$server\".command" $PWD/claude/mcp-servers.json)
    args=$(jq -r ".\"$server\".args | join(\" \")" $PWD/claude/mcp-servers.json)
    claude mcp add -s user "$server" -- $cmd $args
done

# -- global scripts (bin) --------------------
mkdir -p ~/bin
ln -s -f $PWD/bin/ai-notify ~/bin/ai-notify

# -- nvm + custom nvm config for zsh ------
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install node
