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

keymap("v", "<s-j>", ":m '>+1<CR>gv=gv")
keymap("v", "<s-k>", ":m '<-2<CR>gv=gv")

-- save with ctrl s
keymap("n", "<C-s>", ":w<CR>", silent)
keymap("i", "<C-s>", "<Esc>:w<CR>", silent)
keymap("v", "<C-s>", "<Esc>:w<CR>", silent)

keymap("n", "<leader>cl", "<cmd>nohl<cr>")

-- nvim-tree
keymap("n", "<C-n>", ":NvimTreeToggle<CR>", silent)

-- telescope
local telescope = require("telescope.builtin")
keymap("n", "<c-p>", telescope.find_files, silent)
keymap("n", "<c-f>", telescope.live_grep, silent)
keymap("n", "<c-o>", telescope.buffers, silent)

-- ai stuff
keymap("n", "<s-p>", ":CopilotChat<cr>", silent)

-- comment using ctrl /
vim.cmd([[ nmap <C-/> gcc ]])
vim.cmd([[ nmap <C-_> gcc ]])
vim.cmd([[ vmap <C-/> gc ]])
vim.cmd([[ vmap <C-_> gc ]])

-- terminals
local Terminals = {}

-- Function to calculate dynamic terminal size (80% of screen)
local function get_dynamic_size()
	local width = math.floor(vim.o.columns * 0.9)
	local height = math.floor(vim.o.lines * 0.7)
	return {
		width = width,
		height = height,
	}
end

-- Get the floating window options with dynamic size
function Terminals.get_float_opts()
	local dynamic_size = get_dynamic_size()
	return {
		width = dynamic_size.width,
		height = dynamic_size.height,
		winblend = 3,
		zindex = 999,
	}
end

-- Set up the toggle term configuration
local Terminal = require("toggleterm.terminal").Terminal

-- Create a function to get a new lazygit terminal with current window size
function Terminals.create_lazygit()
	return Terminal:new({
		cmd = "lazygit",
		direction = "float",
		float_opts = Terminals.get_float_opts(),
		on_open = function(term)
			vim.cmd("startinsert!")
			vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
		end,
		on_close = function()
			vim.cmd("startinsert!")
		end,
	})
end

-- Create a function to get a new default terminal with current window size
function Terminals.create_default()
	return Terminal:new({
		direction = "float",
		float_opts = Terminals.get_float_opts(),
	})
end

-- Set up keymaps
keymap("n", "<leader>gt", function()
	Terminals.create_lazygit():toggle()
end)

keymap("n", "<leader>t", function()
	Terminals.create_default():toggle()
end)
