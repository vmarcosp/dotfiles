" Custom shortcuts for coc.nvim
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

" Custom which key config
lua << EOF
  local wk = require("which-key")
  local home = os.getenv("HOME")

  vim.g.mapleader = "\\"

  wk.register({
    -- General
    ["<leader>cc"] = { "<cmd>nohl<cr>", "Clear search highlights" },
    ["<c-s>"] = { "<cmd>w<cr>", "Save changes" },

    -- Telescope shortcuts
    ["<c-p>"] = { "<cmd>Telescope find_files<cr>", "Find file" },
    ["<c-f>"] = { "<cmd>Telescope live_grep<cr>", "Find word" },
    ["<c-o>"] = { "<cmd>Telescope buffers<cr>", "Show buffers" },

    -- File explorer shortcuts
    ["<c-n>"] = { "<cmd>NvimTreeToggle<cr>", "Open file explorer" },

    -- Line navigation
    ["<s-k>"] = { "5k", "Jump 5 lines above"},
    ["<s-j>"] = { "5j", "Jump 5 lines below"},

    -- Custom coc.nvim shortcuts
    ["<leader>gd"] = { "<Plug>(coc-definition)", "Go to definition" },
    ["<leader>gg"] = { "Show documentation" },
    ["<leader>gy"] = { "<Plug>(coc-type-definition)",  "Type definition" },
    ["<leader>gi"] = { "<Plug>(coc-implementation)",  "Show implementation" },
    ["<leader>gr"] = { "<Plug>(coc-references)",  "Show references" },
    ["<leader>rn"] = { "<Plug>(coc-rename)",  "Rename symbol" },
    ["<leader>dp"] = { "<Plug>(coc-diagnostic-prev)",  "Go to the next coc diagnostic" },
    ["<leader>dn"] = { "<Plug>(coc-diagnostic-next)",  "Go to the next coc diagnostic" },

    -- Open nvim config
    ["<leader>ev"] = { "<cmd>e $MYVIMRC<cr>", "Open init.vim"},
    ["<leader>sv"] = { "<cmd>source $MYVIMRC<cr>", "Reload neovim config"},

    -- Navigate between buffers
    ["<C-H>"] = { "<C-W>h", "Navigate to the buffer (left)"},
    ["<C-L>"] = { "<C-W>l", "Navigate to the buffer (right)"},
    ["<C-J>"] = { "<C-W>j", "Navigate to the buffer (down)"},
    ["<C-K>"] = { "<C-W>k", "Navigate to the buffer (top)"},
  })

  wk.setup({
    spelling = {
      enabled = true, 
      suggestions = 20, 
    },
  })
EOF

" coc.nvim shortcuts
" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
