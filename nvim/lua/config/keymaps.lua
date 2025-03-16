local keymap = vim.keymap.set

-- navigate between buffers
keymap('n', '<C-h>', '<C-w><C-h>')
keymap('n', '<C-l>', '<C-w><C-l>')
keymap('n', '<C-j>', '<C-w><C-j>')
keymap('n', '<C-k>', '<C-w><C-k>')

-- jump from 5 to 5 lines
keymap("n", "<s-k>", "5kzz")
keymap("n", "<s-j>", "5jzz")
keymap("n", "<s-j>", "5jzz")

-- save with ctrl s
keymap("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
keymap("i", "<C-s>", "<Esc>:w<CR>", { noremap = true, silent = true })
keymap("v", "<C-s>", "<Esc>:w<CR>", { noremap = true, silent = true })

-- nvim-tree
keymap("n", "<C-n>", ":NvimTreeToggle<CR>")

-- telescope
local telescope = require "telescope.builtin"
keymap("n", "<c-p>", telescope.find_files)
keymap("n", "<c-f>", telescope.live_grep)
keymap("n", "<c-o>", telescope.buffers)

-- comment using ctrl /
vim.cmd [[ nmap <C-/> gcc ]]
vim.cmd [[ nmap <C-_> gcc ]]
vim.cmd [[ vmap <C-/> gc ]]
vim.cmd [[ vmap <C-_> gc ]]
