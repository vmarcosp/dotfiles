local custom_catppuccin = require("plugins/themes/custom_catppuccin")

return {
	-- custom_catppuccin,
	"bettervim/yugen.nvim",
	config = function()
		vim.cmd.colorscheme("yugen")
	end,
}
