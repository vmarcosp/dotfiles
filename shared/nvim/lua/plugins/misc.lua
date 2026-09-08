return {
	"tpope/vim-surround",
	"andymass/vim-matchup",
	"tpope/vim-sensible",
	"norcalli/nvim-colorizer.lua",
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = true,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
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
			notifier = { enabled = true },
			scroll = { enabled = true },
			animations = { enabled = true },
		},
	},
}
