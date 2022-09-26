call plug#begin('~/.config/nvim/plugged')

Plug 'numToStr/Comment.nvim'
Plug 'windwp/nvim-spectre'
Plug 'feline-nvim/feline.nvim', { 'branch': '0.5-compat' }
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': 'npm install'}
Plug 'rescript-lang/vim-rescript', {'branch': 'master'}
Plug 'editorconfig/editorconfig-vim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-telescope/telescope.nvim'
Plug 'catppuccin/nvim', {'as': 'catppuccin'}
Plug 'junegunn/seoul256.vim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'sheerun/vim-polyglot'
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

call plug#end()

lua << EOF
require('spectre').setup()
EOF
