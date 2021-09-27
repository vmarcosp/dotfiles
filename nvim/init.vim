call plug#begin('~/.config/nvim/plugged')

" -- LSP & Syntax -----------------
Plug 'rescript-lang/vim-rescript', {'branch': 'master'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'editorconfig/editorconfig-vim'
Plug 'lukas-reineke/indent-blankline.nvim'
" ---------------------------------

" -- Nvim tree --------------------
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
" ---------------------------------

" -- Telescope & Navigation --------
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'akinsho/bufferline.nvim'
" ----------------------------------

" -- Themes ------------------------
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
" ----------------------------------

" -- General Plugins ---------------
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
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'yuttie/comfortable-motion.vim'
" ----------------------------------

call plug#end()

" -- Themes and Colors ----------------
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

" -- Highlight line number ------------------------
set cursorline
au InsertEnter * highlight CursorLine ctermfg=none ctermbg=none cterm=none guifg=none guibg=none gui=none
" -------------------------------------------------

" -- nvim-web-devicons ----------------------------
lua << EOF
require("nvim-web-devicons").set_icon {
  res = {
    icon = "λ",
    color = "#e6484f",
    name = "rescript"
  }
}
EOF
" -------------------------------------------------

" -- buffeliner.nvim ------------------------------
lua << EOF
require("bufferline").setup{
  options = {
    separator_style = 'thin',
    offsets = {
      {
        filetype = "NvimTree",
        text = "",
        highlight = "Directory",
        text_align = "left"
      }
    }
  }
}
EOF
" -------------------------------------------------

" -- nvim.tree config -----------------------------
lua << EOF
local g = vim.g
g.nvim_tree_special_files = { } 

g.nvim_tree_add_trailing = 0 -- append a trailing slash to folder names
g.nvim_tree_git_hl = git_status
g.nvim_tree_gitignore = git_status
g.nvim_tree_hide_dotfiles = 0
g.nvim_tree_highlight_opened_files = 0
g.nvim_tree_indent_markers = 1
g.nvim_tree_ignore = { ".git", "node_modules", ".cache" }
g.nvim_tree_quit_on_open = 0 -- closes tree when file's opened
g.nvim_tree_root_folder_modifier = table.concat { ":t:gs?$?/..", string.rep(" ", 1000), "?:gs?^??" }

g.nvim_tree_icons = {
   default = "",
   symlink = "",
   git = {
      deleted = "",
      ignored = "◌",
      renamed = "➜",
      staged = "✓",
      unmerged = "",
      unstaged = "",
      untracked = "★",
   },
   folder = {
      arrow_open = "",
      arrow_closed = "",
      default = "",
      empty = "",
      empty_open = "",
      open = "",
      symlink = "",
      symlink_open = "",
   },
}

g.nvim_tree_root_folder_modifier = table.concat { ":t:gs?$?/", string.rep(" ", 1000), "?:gs?^??" }

require'nvim-tree'.setup {
   lsp_diagnostics = false,
   disable_netrw = true,
   hijack_netrw = true,
   ignore_ft_on_setup = { "dashboard" },
   auto_close = false,
   open_on_tab = false,
   hijack_cursor = true,
   update_cwd = true,
   update_focused_file = {
      enable = true,
      update_cwd = true,
   },
   view = {
      allow_resize = true,
      side = "left",
      width = 25,
   },
}
EOF
" -------------------------------------------------

" -- Commands -------------------------------------
command! -nargs=0 FormatFiles :CocCommand  prettier.formatFile eslint.executeAutofix
 au VimEnter * NvimTreeFocus

" -- Shortcuts ------------------------------------
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
nnoremap <c-n> :BufferLineCyclePrev <CR>
nnoremap <c-m> :BufferLineCycleNext <CR>
" -------------------------------------------------

" -- Fonts & Icons --------------------------------
set encoding=utf8
if !exists('g:airline_symbols')
let g:airline_symbols = {}
endif
let g:airline_powerline_fonts=1
let g:airline_symbols.notexists = ' ✗'
" -------------------------------------------------

" -- Files & Folders ------------------------------
set wildignore+=*_esy/*,*esy.lock/*,*/node_modules/*,*.reast,*.cmj,*.d,*.cmt,*.cmi
" -------------------------------------------------

" -- Typos ----------------------------------------
iabbrev lenght length
iabbrev widht width
iabbrev heigth height
iabbrev discipline discipline
" -------------------------------------------------

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
