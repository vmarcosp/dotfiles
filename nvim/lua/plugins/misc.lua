return {
	"tpope/vim-surround",
	"andymass/vim-matchup",
	"tpope/vim-sensible",
	"nvim-pack/nvim-spectre",
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
			explorer = { enabled = true },
			picker = { enabled = true },
			quickfile = { enabled = true },
		},
	},
}
