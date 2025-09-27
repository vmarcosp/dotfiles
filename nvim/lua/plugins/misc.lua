return {
	"github/copilot.vim",
	"tpope/vim-surround",
	"andymass/vim-matchup",
	"tpope/vim-sensible",
	"nvim-pack/nvim-spectre",
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
			input = { enabled = true },
			indent = { enabled = true },
			animate = { enabled = true },
			notifier = {
				enabled = true,
				timeout = 3000,
			},
			scroll = { enabled = true },
		},
	},
}
