require("config.options")
require("config.lazy")
require("config.keymaps")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "AvanteInput",
	callback = function()
		local colors = { bg = "#000000", fg = "#000000" }
		vim.api.nvim_set_hl(0, "AvantePopupHint", colors)
		vim.api.nvim_set_hl(0, "AvanteInlineHint", colors)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "AvantePromptInput",
	callback = function()
		local colors = { bg = "#151515", fg = "#151515" }
		vim.api.nvim_set_hl(0, "AvantePopupHint", colors)
		vim.api.nvim_set_hl(0, "AvanteInlineHint", colors)
	end,
})
