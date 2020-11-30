call plug#begin('~/.config/nvim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ryanoasis/vim-devicons'
Plug 'terryma/vim-multiple-cursors'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mattn/emmet-vim'
Plug 'preservim/nerdtree'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-surround'
Plug 'yuttie/comfortable-motion.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

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
Plug 'drewtempelmeyer/palenight.vim'
" --------------------------

" -------- Syntax plugins --------
Plug 'pangloss/vim-javascript'
Plug 'sheerun/vim-polyglot'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'jparise/vim-graphql'
" --------------------------------

call plug#end()

" -------- Configuraçao de temas e cores ----------
set t_Co=256

" Dragula additional config
" let g:dracula_colorterm = 0
" let g:dracula_italic = 0
"
set termguicolors

" set background=dracula
colorscheme nord
let g:airline_theme='nord'
" -------------------------------------------------

syntax on
set expandtab
set tabstop=2
set softtabstop=2
set number
set ignorecase

" ---------- Shortcuts -----------------
vmap <Tad> >gv
" vmap <S-Tab> <gv

"CTRL + s => Save
nnoremap <c-s> :w <cr>

" Ctrl + A => eslint.autoFix
nnoremap <c-a> :CocCommand eslint.executeAutofix<cr>
nnoremap <c-i> :NERDTreeToggle <cr>
nnoremap <c-j> :m +1 <cr>
nnoremap <c-k> :m -2 <cr>
nnoremap <c-l> :nohl <cr>
" -------- Fonts & Icons -----------
set encoding=utf8

if !exists('g:airline_symbols')
let g:airline_symbols = {}
endif
let g:airline_powerline_fonts=1
let g:airline_symbols.notexists = ' ✗'
" ----------------------------------

" ---------- Files & Folders ---------------
set wildignore+=*_esy/*,*esy.lock/*,*/node_modules/*,*.bs.js,*.reast,*.cmj,*.d,*.cmt,*.cmi
let NERDTreeIgnore = ['\.bs.js$']
" ------------------------------------------

" ------- Typos --------
iabbrev lenght length
iabbrev widht width
iabbrev heigth height
iabbrev discipline disicpline
" ---------------------

" ------- Testing -----------
" Não quebrar linhas por padrão. Para definir quebra de linha, só entrar no arquivo e digitar :set wrap
set nowrap

" Permite copiar do clipboard para o vim e do vim para o clipboard
set clipboard+=unnamedplus
let g:user_emmet_leader_key=','
set foldmethod=syntax
set nofoldenable
