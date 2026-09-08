return {
	"nvim-tree/nvim-web-devicons",
	config = function()
		require("nvim-web-devicons").setup({
			override = {
				css = {
					icon = "",
					color = "#FFBE89",
					name = "Css",
				},
			},
		})
	end,
}
