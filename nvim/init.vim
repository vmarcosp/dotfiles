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
Plug 'ayu-theme/ayu-vim'
" --------------------------

" -------- Syntax plugins --------
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
" colorscheme palenight
" let g:airline_theme='palenight'

" OceanicNext 
" colorscheme OceanicNext
" let g:airline_theme='oceanicnext'

" Gruvbox
"colorscheme gruvbox
"let g:airline_theme='gruvbox'

" Iceberg
" colorscheme iceberg
" let g:airline_theme='iceberg'

" Ayu 
colorscheme ayu 
let g:airline_theme='ayu'

" -------------------------------------------------


" ---------- Commands -----------------
command! -nargs=0 FormatFiles :CocCommand  prettier.formatFile eslint.executeAutofix

" ---------- Shortcuts -----------------
autocmd FileType typescriptreact nnoremap <c-i> :FormatFiles <cr>
autocmd FileType javascriptreact nnoremap <c-i> :FormatFiles <cr>
autocmd FileType typescript nnoremap <c-i>  :FormatFiles <cr>
autocmd FileType javascript nnoremap <c-i>:FormatFiles <cr>

autocmd FileType rescript nnoremap <silent> <buffer> gd :RescriptJumpToDefinition<CR>

nnoremap <c-s> :w <cr>
nnoremap <c-k> :m +1 <cr>
nnoremap <c-j> :m -2 <cr>
nnoremap <c-l> :nohl <cr>
nnoremap <c-p> :Files <cr>
nnoremap <s-Up> 5k <cr>
nnoremap <s-Down> 5j <cr>
" ---------------------------------------

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
