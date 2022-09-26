" Save current buffer using ctrl + s
nnoremap <c-s> :w <cr>

" Navigate between buffers
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <leader>bb :bnext<cr>
nnoremap <leader>vv :bprevious<cr>

" Clear searching highlights
nnoremap <leader>cc :nohl <cr>

" Custom coc.nvim bindings
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

" Custom command for formatting files respecting the file extension
autocmd FileType json nnoremap <leader>fi <cmd>CocCommand  prettier.formatFile eslint.executeAutofix<cr>
autocmd FileType javascript nnoremap <leader>fi <cmd>CocCommand  prettier.formatFile eslint.executeAutofix<cr>
autocmd FileType markdown nnoremap <leader>fi <cmd>CocCommand  prettier.formatFile eslint.executeAutofix<cr>
autocmd FileType rescript nnoremap <leader>fi <cmd>RescriptFormat<cr>

" Disable arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

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
    ["<leader>dt"] = { "<cmd>e $HOME/dotfiles/tmux/.tmux.conf<cr>", "Open tmux config"},
  })

  wk.setup({
    spelling = {
      enabled = true, 
      suggestions = 20, 
    },
  })
EOF

" Custom config for UltiSnips
let g:UltiSnipsEditSplit="vertical"


nnoremap <leader>S <cmd>lua require('spectre').open()<CR>

"search current word
nnoremap <leader>sw <cmd>lua require('spectre').open_visual({select_word=true})<CR>
vnoremap <leader>s <esc>:lua require('spectre').open_visual()<CR>
"  search in current file
nnoremap <leader>sp viw:lua require('spectre').open_file_search()<cr>
