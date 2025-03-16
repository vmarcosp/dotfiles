local silent = { noremap = true, silent = true }
local keymap = vim.keymap.set

-- navigate between buffers
keymap("n", "<C-h>", "<C-w><C-h>")
keymap("n", "<C-l>", "<C-w><C-l>")
keymap("n", "<C-j>", "<C-w><C-j>")
keymap("n", "<C-k>", "<C-w><C-k>")

-- jump from 5 to 5 lines
keymap("n", "<s-k>", "5kzz")
keymap("n", "<s-j>", "5jzz")
keymap("n", "<s-j>", "5jzz")

-- save with ctrl s
keymap("n", "<C-s>", ":w<CR>", silent)
keymap("i", "<C-s>", "<Esc>:w<CR>", silent)
keymap("v", "<C-s>", "<Esc>:w<CR>", silent)

-- nvim-tree
keymap("n", "<C-n>", ":NvimTreeToggle<CR>", silent)

-- telescope
local telescope = require("telescope.builtin")
keymap("n", "<c-p>", telescope.find_files, silent)
keymap("n", "<c-f>", telescope.live_grep, silent)
keymap("n", "<c-o>", telescope.buffers, silent)

-- comment using ctrl /
vim.cmd([[ nmap <C-/> gcc ]])
vim.cmd([[ nmap <C-_> gcc ]])
vim.cmd([[ vmap <C-/> gc ]])
vim.cmd([[ vmap <C-_> gc ]])

-- terminals
local Terminals = {}

Terminals.floating_window_opts = {
	border = "curved",
	width = 124,
	height = 16,
	winblend = 3,
	zindex = 999,
}

Terminals.lazygit = {
	cmd = "lazygit",
	direction = "float",
	float_opts = Terminals.floating_window_opts,
	on_open = function(term)
		vim.cmd("startinsert!")
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	end,
	on_close = function()
		vim.cmd("startinsert!")
	end,
}

Terminals.default = {
	direction = "float",
	float_opts = Terminals.floating_window_opts,
}

keymap("n", "<leader>gt", function()
	local terminal = require("toggleterm.terminal").Terminal
	terminal:new(Terminals.lazygit):toggle()
end)

keymap("n", "<leader>t", function()
	local terminal = require("toggleterm.terminal").Terminal
	terminal:new(Terminals.default):toggle()
end)
