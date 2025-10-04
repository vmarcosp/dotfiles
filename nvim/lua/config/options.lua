vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"
-- remove the ~ from empty lines
vim.opt.fillchars = { eob = " " }
vim.opt.number = true
vim.o.relativenumber = true

-- sync clipboard between nvim and OS
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

vim.g.nvim_tree_git_hl = 1
vim.o.compatible = false
vim.cmd("set t_Co=256")
vim.o.termguicolors = true
vim.o.background = "dark"
vim.o.cursorline = true
vim.o.syntax = "on"
vim.o.wrap = false
vim.o.completeopt = "menuone,noselect"
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.ignorecase = true
vim.o.encoding = "utf-8"
vim.o.mouse = "a"
vim.o.wildignore = "*/node_modules/*"
vim.o.backup = false
vim.o.writebackup = false
vim.o.updatetime = 300
vim.o.signcolumn = "yes"
vim.o.splitbelow = true
vim.o.splitright = true

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99

-- Diagnostic signs
local signs = {
	Error = "●",
	Warn = "●",
	Hint = "●",
	Info = "●",
}

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
