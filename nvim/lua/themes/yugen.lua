return {
	"sainnhe/everforest",
	priority = 1000,
	config = function()
		vim.o.background = "light"
		vim.g.everforest_background = "soft"
		vim.g.everforest_better_performance = 1
		vim.cmd.colorscheme("everforest")
	end,
}
