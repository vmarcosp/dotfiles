call plug#begin('~/.config/nvim/plugged')

" Bufferline :: Tabs 
Plug 'akinsho/bufferline.nvim'

Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-surround'
Plug 'yuttie/comfortable-motion.vim'
Plug 'rescript-lang/vim-rescript', {'branch': 'master'}

" Nvim tree
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" ------- Basic plugins --------

" -----------------------------

" --------- Themes ---------
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'       

Plug 'joshdick/onedark.vim' 
Plug 'drewtempelmeyer/palenight.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'arcticicestudio/nord-vim'
Plug 'mhartington/oceanic-next'
Plug 'morhetz/gruvbox'
Plug 'cocopon/iceberg.vim'
Plug 'ayu-theme/ayu-vim'
" --------------------------

" -------- General Plugins --------
Plug 'tpope/vim-sensible'
Plug 'junegunn/seoul256.vim'
Plug 'sheerun/vim-polyglot'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'jparise/vim-graphql'
Plug 'elixir-editors/vim-elixir' 
Plug 'mhinz/vim-mix-format'
Plug 'slashmili/alchemist.vim' 
Plug 'neomake/neomake'
Plug 'chrisbra/Colorizer'
" --------------------------------

call plug#end()

" -------- Configuraçao de temas e cores ----------
set t_Co=256
set termguicolors
set background=dark

" Dracula
" let g:dracula_colorterm = 0
" let g:dracula_italic = 0
" colorscheme dracula
" let g:airline_theme='dracula'

" Palenight 
colorscheme palenight
let g:airline_theme='palenight'

" OceanicNext 
" colorscheme OceanicNext
" let g:airline_theme='oceanicnext'

" Gruvbox
"colorscheme gruvbox
" let g:airline_theme='gruvbox'

" Iceberg
" colorscheme iceberg
" let g:airline_theme='iceberg'

" Ayu 
" colorscheme ayu 
" let g:airline_theme='ayu'

" -------------------------------------------------

" ------ buffeliner.nvim --------------------------
lua << EOF
require("bufferline").setup{}
EOF
" -------------------------------------------------

" ------ nvim.tree config -------------------------
lua << EOF
require'nvim-tree'.setup()
EOF
let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ] "empty by default
let g:nvim_tree_gitignore = 1 "0 by default
let g:nvim_tree_quit_on_open = 1 "0 by default, closes the tree when you open a file
let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
let g:nvim_tree_hide_dotfiles = 1 "0 by default, this option hides files and folders starting with a dot `.`
let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
let g:nvim_tree_highlight_opened_files = 1 "0 by default, will enable folder and file icon highlight for opened files/directories.
let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
let g:nvim_tree_add_trailing = 1 "0 by default, append a trailing slash to folder names
let g:nvim_tree_group_empty = 1 " 0 by default, compact folders that only contain a single folder into one node in the file tree
let g:nvim_tree_disable_window_picker = 1 "0 by default, will disable the window picker.
let g:nvim_tree_icon_padding = ' ' "one space by default, used for rendering the space between the icon and the filename. Use with caution, it could break rendering if you set an empty string depending on your font.
let g:nvim_tree_symlink_arrow = ' >> ' " defaults to ' ➛ '. used as a separator between symlinks' source and target.
let g:nvim_tree_respect_buf_cwd = 1 "0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
let g:nvim_tree_create_in_closed_folder = 0 "1 by default, When creating files, sets the path of a file when cursor is on a closed folder to the parent folder when 0, and inside the folder when 1.
let g:nvim_tree_refresh_wait = 500 "1000 by default, control how often the tree can be refreshed, 1000 means the tree can be refresh once per 1000ms.
let g:nvim_tree_window_picker_exclude = {
    \   'filetype': [
    \     'notify',
    \     'packer',
    \     'qf'
    \   ],
    \   'buftype': [
    \     'terminal'
    \   ]
    \ }

let g:nvim_tree_show_icons = {
    \ 'git': 1,
    \ 'folders': 0,
    \ 'files': 0,
    \ 'folder_arrows': 0,
    \ }

let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': "★",
    \   'deleted': "",
    \   'ignored': "◌"
    \   },
    \ 'folder': {
    \   'arrow_open': "",
    \   'arrow_closed': "",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   },
    \   'lsp': {
    \     'hint': "",
    \     'info': "",
    \     'warning': "",
    \     'error': "",
    \   }
    \ }

nnoremap <c-i> :NvimTreeToggle<cr>
nnoremap <leader>r :NvimTreeRefresh<CR>

highlight NvimTreeFolderIcon guibg=red
" -------------------------------------------------


" ---------- Commands -----------------
command! -nargs=0 FormatFiles :CocCommand  prettier.formatFile eslint.executeAutofix

" ---------- Shortcuts -----------------
autocmd FileType typescriptreact nnoremap <c-fm> :FormatFiles <cr>
autocmd FileType javascriptreact nnoremap <c-fm> :FormatFiles <cr>
autocmd FileType typescript nnoremap <c-fm>  :FormatFiles <cr>
autocmd FileType javascript nnoremap <c-fm>:FormatFiles <cr>
autocmd FileType rescript nnoremap <silent> <buffer> gd :RescriptJumpToDefinition<CR>
nnoremap <c-s> :w <cr>
nnoremap <c-k> :m +1 <cr>
nnoremap <c-j> :m -2 <cr>
nnoremap <c-l> :nohl <cr>
nnoremap <s-Up> 5k <cr>
nnoremap <s-Down> 5j <cr>
nnoremap <c-p> :Telescope find_files prompt_prefix=⚡<cr>
nnoremap <c-n> :BufferLineMovePrev <CR>
nnoremap <c-m> :BufferLineMoveNext <CR>
" --------------------------------------

" -------- Fonts & Icons -----------
set encoding=utf8
if !exists('g:airline_symbols')
let g:airline_symbols = {}
endif
let g:airline_powerline_fonts=1
let g:airline_symbols.notexists = ' ✗'
" ----------------------------------

" ---------- Files & Folders ---------------
set wildignore+=*_esy/*,*esy.lock/*,*/node_modules/*,*.reast,*.cmj,*.d,*.cmt,*.cmi
let NERDTreeIgnore = ['\.bs.js$']
" ------------------------------------------

" ------- Typos --------
iabbrev lenght length
iabbrev widht width
iabbrev heigth height
iabbrev discipline discipline
" ---------------------


" ---------- FZF ---------------
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --layout reverse --margin=1,4 --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
let $FZF_DEFAULT_COMMAND="rg --files-with-matches --hidden '.' --glob '!.git'"
" ---------------------
 
syntax on
set nowrap
set clipboard+=unnamedplus
let g:user_emmet_leader_key=','
set foldmethod=syntax
set nofoldenable
set mouse=a
set omnifunc=rescript#Complete
set completeopt+=preview
set expandtab
set tabstop=2
set softtabstop=2
set number
set ignorecase
