call plug#begin('~/.config/nvim/plugged')

" -- LSP & Syntax -----------------
Plug 'rescript-lang/vim-rescript', {'branch': 'master'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'editorconfig/editorconfig-vim'
" ---------------------------------

" -- Nvim tree --------------------
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
" ---------------------------------

" -- Telescope & Navigation --------
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'akinsho/bufferline.nvim'
Plug 'glepnir/dashboard-nvim'
" ----------------------------------

" -- Themes ------------------------
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'       
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'

Plug 'joshdick/onedark.vim' 
Plug 'drewtempelmeyer/palenight.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'arcticicestudio/nord-vim'
Plug 'mhartington/oceanic-next'
Plug 'morhetz/gruvbox'
Plug 'cocopon/iceberg.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'altercation/vim-colors-solarized'
Plug 'haishanh/night-owl.vim'
" ----------------------------------

" -- General Plugins ---------------
Plug 'junegunn/seoul256.vim'
Plug 'sheerun/vim-polyglot'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'jparise/vim-graphql'
Plug 'mhinz/vim-mix-format'
Plug 'neomake/neomake'
Plug 'chrisbra/Colorizer'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'terrortylor/nvim-comment'
Plug 'andymass/vim-matchup'
Plug 'windwp/nvim-autopairs'
Plug 'famiu/bufdelete.nvim'
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
" colorscheme palenight
" let g:airline_theme='palenight'

" OceanicNext 
" colorscheme OceanicNext 
" let g:airline_theme='oceanicnext'

" Gruvbox
" colorscheme gruvbox
" let g:airline_theme='gruvbox'
" let g:gruvbox_invert_selection = 0
" set background=light

" Iceberg
 colorscheme iceberg
 let g:airline_theme='iceberg'

" Ayu  
" let ayucolor="light"
" colorscheme ayu 
" let g:airline_theme='ayu'

" One Half
 colorscheme onehalfdark
 let g:airline_theme='onehalfdark'

" Solarized
" syntax enable
" set background=light
" colorscheme solarized

" Night Owl 
" colorscheme night-owl
" let g:airline_theme='night_owl'

" if has('gui_running')
"     set background=light
" else
"     set background=dark
" endif

" -------------------------------------------------

lua << END
require('lualine').setup {
  extensions = { 'nvim-tree' },
  options = {
    disabled_filetypes = {'NvimTree'}
  }
}
END

" -- Highlight line number ------------------------
 set cursorline
 au InsertEnter * highlight CursorLine ctermfg=none ctermbg=none cterm=none guifg=none guibg=none gui=none
" -------------------------------------------------

" -- nvim-web-devicons ----------------------------
lua << EOF
require('nvim_comment').setup()
require('nvim-autopairs').setup{}
require("nvim-web-devicons").set_icon {
  res = {
    icon = "■",
    color = "#e6484f",
    name = "rescript"
  }
}
EOF
" -------------------------------------------------

lua <<EOF
  local home = os.getenv('HOME')
  local db = require('dashboard')
  db.preview_command = 'cat | lolcat -F 0.3'
  db.preview_file_path = home .. '/.config/nvim/static/neovim.cat'
  db.preview_file_height = 12
  db.preview_file_width = 80
  db.custom_center = {
      {icon = '  ',
      desc = 'Recently latest session                  ',
      shortcut = 'SPC s l',
      action ='SessionLoad'},
      {icon = '  ',
      desc = 'Recently opened files                   ',
      action =  'DashboardFindHistory',
      shortcut = 'SPC f h'},
      {icon = '  ',
      desc = 'Find  File                              ',
      action = 'Telescope find_files find_command=rg,--hidden,--files',
      shortcut = 'SPC f f'},
      {icon = '  ',
      desc ='File Browser                            ',
      action =  'Telescope file_browser',
      shortcut = 'SPC f b'},
      {icon = '  ',
      desc = 'Find  word                              ',
      action = 'Telescope live_grep',
      shortcut = 'SPC f w'},
      {icon = '  ',
      desc = 'Open Personal dotfiles                  ',
      action = 'Telescope dotfiles path=' .. home ..'/.dotfiles',
      shortcut = 'SPC f d'},
    }
EOF

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

g.nvim_tree_git_hl = git_status

require'nvim-tree'.setup {
   -- lsp_diagnostics = false,
   disable_netrw = true,
   hijack_netrw = true,
   ignore_ft_on_setup = { "dashboard" },
   -- auto_close = false,
   open_on_tab = true,
   hijack_cursor = true,
   update_cwd = true,
   -- quit_on_open = true,
   renderer = {
     root_folder_modifier = table.concat { ":t:gs?$?/", string.rep(" ", 1000), "?:gs?^??" },
     highlight_opened_files = "all",
     add_trailing = true,
     special_files = { },
     indent_markers = {
       enable = true
     },
     icons = {
       glyphs = {
           default = "",
           symlink = "",
           git = {
              deleted = "",
              ignored = "◌",
              renamed = "➜",
              staged = "✓",
              unmerged = "",
              unstaged = "",
              untracked = "",
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
     }
   },
   filters = {
     custom = { ".git", "node_modules", ".cache", "*.bs.js" }
   },
   git = {
    ignore = true
   },
   update_focused_file = {
      enable = true,
      update_cwd = true,
   },
   view = {
      -- allow_resize = true,
      side = "left",
      width = 32,
   },
}
EOF
" -------------------------------------------------

" -- Commands -------------------------------------
function! DisableST()
  return "%#NonText#"
endfunction
au BufEnter NvimTree setlocal statusline=%!DisableST()

command! -nargs=0 FormatFiles :CocCommand  prettier.formatFile eslint.executeAutofix
au VimEnter * NvimTreeFocus

" -- Shortcuts ------------------------------------
autocmd FileType rescript nnoremap <silent> <buffer> gd :RescriptJumpToDefinition<CR>
nnoremap <silent> <c-s> :w <cr>
nnoremap <silent> <c-k> :m +1 <cr>
nnoremap <silent> <c-j> :m -2 <cr>
nnoremap <silent> <c-l> :nohl <cr>
nnoremap <silent> <s-Up> 5k <cr>
nnoremap <silent> <s-Down> 5j <cr>
nnoremap <silent> <c-p> :Telescope find_files <cr>
nnoremap <silent> <c-o> :Telescope live_grep  <cr>
nnoremap <silent> td :bdelete <cr>
nnoremap <silent> nn :BufferLineCyclePrev <cr>
nnoremap <silent> mm :BufferLineCycleNext <cr>
nnoremap <silent> <c-i> :NvimTreeToggle <cr>
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
set wildignore+=*_esy/*,*esy.lock/*,*/node_modules/*,*.reast,*.cmj,*.d,*.cmt,*.cmi,*.bs.js
" -------------------------------------------------

" -- Typos ----------------------------------------
iabbrev lenght length
iabbrev widht width
iabbrev heigth height
iabbrev investiments investments
" -------------------------------------------------

let g:user_emmet_leader_key=','
syntax on
set nowrap
set clipboard+=unnamedplus
set foldmethod=syntax
set nofoldenable
set mouse=a
set completeopt+=preview
set expandtab
set tabstop=2
set softtabstop=2
set number
set ignorecase
