call plug#begin('~/.config/nvim/plugged')

" -- LSP & Syntax -----------------
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'rescript-lang/vim-rescript', {'branch': 'master'}
Plug 'editorconfig/editorconfig-vim'
Plug 'makerj/vim-pdf'
" ---------------------------------

" -- Telescope & Navigation --------
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lualine/lualine.nvim'
" ----------------------------------

" -- Themes ------------------------
Plug 'catppuccin/nvim', {'as': 'catppuccin'}
Plug 'arcticicestudio/nord-vim'
Plug 'olivercederborg/poimandres.nvim'
Plug 'ayu-theme/ayu-vim'
" ----------------------------------

" -- General Plugins ---------------
Plug 'junegunn/seoul256.vim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'sheerun/vim-polyglot'
Plug 'jxnblk/vim-mdx-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'jparise/vim-graphql'
Plug 'neomake/neomake'
Plug 'chrisbra/Colorizer'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'tpope/vim-fugitive'
Plug 'andymass/vim-matchup'
Plug 'windwp/nvim-autopairs'
Plug 'glepnir/dashboard-nvim'
Plug 'SirVer/ultisnips'
Plug 'yuttie/comfortable-motion.vim'
Plug 'folke/which-key.nvim'
Plug 'vim-ruby/vim-ruby'
" ----------------------------------

call plug#end()

" -- Themes and Colors ----------------
set t_Co=256
set termguicolors
set background=dark

" Captuccin 
lua << EOF
local catppuccin = require("catppuccin")
require("catppuccin").setup({
	transparent_background = false,
	term_colors = false,
	compile = {
		enabled = false,
		path = vim.fn.stdpath("cache") .. "/catppuccin",
	},
	dim_inactive = {
		enabled = false,
		shade = "dark",
		percentage = 0.15,
	},
	styles = {
		comments = { "italic" },
		conditionals = { "italic" },
		loops = {},
		functions = {},
		keywords = {},
		strings = {},
		variables = {},
		numbers = {},
		booleans = {},
		properties = {},
		types = {},
		operators = {},
	},
	integrations = {
		-- For various plugins integrations see https://github.com/catppuccin/nvim#integrations
	},
	color_overrides = {},
	highlight_overrides = {},
})
EOF
let g:catppuccin_flavour = "macchiato"
colorscheme catppuccin
"
lua << EOF
  require('poimandres').setup {}
EOF
" colorscheme poimandres

" ---------------------------------------
" -- Which Key + Keybindings ------------
nnoremap <c-j> :m +1 <cr>
nnoremap <c-k> :m -2 <cr>
nnoremap <c-s> :w <cr>
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

" -- Navigating between opened buffers --
nnoremap <leader>bb :bnext<cr>
nnoremap <leader>vv :bprevious<cr>
nnoremap <leader>cc :nohl <cr>

" -- coc.nvim bindings ----------------- 
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gg :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction


lua << EOF
  local wk = require("which-key")
  local home = os.getenv("HOME")

  wk.register({
    ["<leader>ff"] = { "<cmd>Telescope find_files<cr>", "Find file" },
    ["<leader>fw"] = { "<cmd>Telescope live_grep<cr>", "Find word" },
    ["<leader>fb"] = { "<cmd>Telescope buffers<cr>", "Show buffers" },
    ["<leader>tt"] = { "<cmd>NvimTreeToggle<cr>", "Open file explorer" },
    ["<leader>tc"] = { "<cmd>NvimTreeCollapse<cr>", "Collpase folders" },
    ["<s-k>"] = { "5k", "Jump 5 lines above"},
    ["<s-j>"] = { "5j", "Jump 5 lines below"},
    ["<leader>dv"] = { "<cmd>e $MYVIMRC<cr>", "Open init.vim"},
    ["<leader>dt"] = { "<cmd>e " .. home .. "/Projects/dotfiles/tmux/.tmux.conf<cr>", "Open tmux config"},
  })

  wk.setup({
    spelling = {
      enabled = true, 
      suggestions = 20, 
    },
  })
EOF
" ---------------------------------------

" -- lualine ----------------------------
lua << END
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = {
      { 'mode', separator = { right = ' ' }, left_padding = 0 },
    },
    lualine_b = { '' },
    lualine_c = { '' },
    lualine_x = { '' },
    lualine_y = { '' },
    lualine_z = { 
      { 'progress', separator = { left = ' ' } },
    },  
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},  
  },
  tabline = {},
  extensions = { 'nvim-tree', 'fugitive' },
  options = {
     disabled_filetypes = {'NvimTree'}
   }
}
END

" -- nvim-web-devicons ------------------
lua << EOF
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

" -- nvim.tree config -----------------------------
lua << EOF
local g = vim.g

g.nvim_tree_git_hl = git_status

require'nvim-tree'.setup {
   disable_netrw = true,
   hijack_netrw = true,
   ignore_ft_on_setup = { "dashboard" },
   open_on_tab = true,
   hijack_cursor = true,
   update_cwd = true,
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
     custom = { ".git", "node_modules", "*.bs.js" }
   },
   git = {
    ignore = true
   },
   update_focused_file = {
      enable = true,
      update_cwd = true,
   },
   view = {
      side = "left",
      width = 32,
   },
}
EOF
" -------------------------------------------------

" ----- telescope ---------------------------------
lua << EOF
local actions = require "telescope.actions"
require("telescope").setup {
  pickers = {
    buffers = {
      mappings = {
        i = {
          ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
        }
      }
    }
  }
}
EOF

" -------------------------------------------------

" -- indent_blankline -----------------------------
lua << EOF
require("indent_blankline").setup {
    show_current_context = true,
    show_current_context_start = true,
}
EOF

" -- Shortcuts ------------------------------------
autocmd FileType json nnoremap <leader>fi <cmd>CocCommand  prettier.formatFile eslint.executeAutofix<cr>
autocmd FileType javascript nnoremap <leader>fi <cmd>CocCommand  prettier.formatFile eslint.executeAutofix<cr>
autocmd FileType markdown nnoremap <leader>fi <cmd>CocCommand  prettier.formatFile eslint.executeAutofix<cr>
autocmd FileType rescript nnoremap <leader>fi <cmd>RescriptFormat<cr>
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

" -- Highlight line number ------------------------
 set cursorline
 au InsertEnter * highlight CursorLine ctermfg=none ctermbg=none cterm=none guifg=none guibg=none gui=none
" -------------------------------------------------

" -- dashboard -----------------------------------
lua << EOF
local home = os.getenv('HOME')
local db = require('dashboard')
db.default_banner = {
  "",
  "",
  "",
  "",
  "",
  "",
}

db.custom_footer = {"", " " .. vim.fn.getcwd():gsub(home, ""):gsub("/Projects", "") .. ""}

db.custom_center = {
     {
        icon = "  ",
        desc = "Open explorer                     ",
        action = "NvimTreeToggle",
        shortcut = "\\tt"
    },{
        icon = "  ",
        desc = "Find word                         ",
        action = "Telescope live_grep",
        shortcut = "\\fh"
    },
    {
        icon = "  ",
        desc = "Find  File                        ",
        action = "Telescope find_files find_command=rg,--hidden,--files",
        shortcut = "\\ff"
    },
    
    {
        icon = "  ",
        desc = "Open dotfiles                     ",
        action = "e " .. home .. "/Projects/dotfiles/nvim/init.vim",
        shortcut = "\\dv"
    }
}

EOF
" --------------------------------------------

" -- Other configs ---------------------------
au VimEnter * Dashboard

let g:UltiSnipsEditSplit="vertical"

syntax on
set nowrap
set clipboard+=unnamedplus
set completeopt=longest,menuone
set expandtab
set tabstop=2
set softtabstop=2
set relativenumber
set number
set ignorecase
set encoding=utf8
set nocompatible

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

let g:comfortable_motion_scroll_down_key = "j"
let g:comfortable_motion_scroll_up_key = "k"
