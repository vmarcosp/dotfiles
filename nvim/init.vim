call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'       
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-surround'
Plug 'yuttie/comfortable-motion.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'rescript-lang/vim-rescript', {'branch': 'master'}
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'

" ------- Basic plugins --------
Plug 'tpope/vim-sensible'
Plug 'junegunn/seoul256.vim'
" -----------------------------

" --------- Themes ---------
Plug 'joshdick/onedark.vim' 
Plug 'drewtempelmeyer/palenight.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'arcticicestudio/nord-vim'
Plug 'mhartington/oceanic-next'
Plug 'morhetz/gruvbox'
Plug 'cocopon/iceberg.vim'
" --------------------------

" -------- Syntax plugins --------
Plug 'sheerun/vim-polyglot'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'jparise/vim-graphql'
Plug 'elixir-editors/vim-elixir' " Syntax highlighting, Filetype detection, Automatic indentation
Plug 'mhinz/vim-mix-format' " Run mix formatter asynchronously (:MixFormat, :verb MixFormat, :MixFormatDiff)
Plug 'slashmili/alchemist.vim' " Completion for Modules and functions, and much more...
Plug 'neomake/neomake' " Execute code checks to find mistakes in the currently edited file
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
" colorscheme palenight
" let g:airline_theme='palenight'

" OceanicNext 
" colorscheme OceanicNext
" let g:airline_theme='oceanicnext'

"
" Gruvbox
colorscheme gruvbox
let g:airline_theme='gruvbox'

" Iceberg
" colorscheme iceberg
" let g:airline_theme='iceberg'
" -------------------------------------------------

syntax on
set expandtab
set tabstop=2
set softtabstop=2
set number
set ignorecase

" ---------- Shortcuts -----------------
autocmd FileType javascript nnoremap <c-a> :CocCommand eslint.executeAutofix<cr>
autocmd FileType javascriptreact nnoremap <c-a> :CocCommand eslint.executeAutofix<cr>
autocmd FileType typescript nnoremap <c-a> :CocCommand eslint.executeAutofix<cr>
autocmd FileType typescriptreact nnoremap <c-a> :CocCommand eslint.executeAutofix<cr>
autocmd FileType reason nnoremap <c-a> :call CocAction('format')<cr>
command! -nargs=0 Prettier :CocCommand prettier.formatFile
autocmd FileType typescriptreact nnoremap <c-f> :Prettier <cr>
autocmd FileType javascriptreact nnoremap <c-f> :Prettier <cr>
autocmd FileType typescript nnoremap <c-f> :Prettier <cr>
autocmd FileType javascript nnoremap <c-f> :Prettier <cr>
autocmd FileType rescript nnoremap <silent> <buffer> gd :RescriptJumpToDefinition<CR>

nnoremap <c-s> :w <cr>
nnoremap <c-j> :m +1 <cr>
nnoremap <c-k> :m -2 <cr>
nnoremap <c-l> :nohl <cr>
nnoremap <c-p> :Files <cr>
nnoremap <c-Up> 5k <cr>
nnoremap <c-Down> 5j <cr>

set omnifunc=rescript#Complete
set completeopt+=preview

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
" ------------------------------------------

" ------- Typos --------
iabbrev lenght length
iabbrev widht width
iabbrev heigth height
iabbrev discipline discipline
" ---------------------

" fzf config
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --layout reverse --margin=1,4 --preview 'bat --color=always --style=header,grid --line-range :300 {}'"

set nowrap
set clipboard+=unnamedplus

let g:user_emmet_leader_key=','
set foldmethod=syntax
set nofoldenable
