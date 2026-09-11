return {
	"tpope/vim-surround",
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = true,
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			indent = { enabled = true },
			dashboard = require("config.dashboard"),
			input = { enabled = true },
		},
	},
}
