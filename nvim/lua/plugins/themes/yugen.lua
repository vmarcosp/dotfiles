local p = {
	placeholder = "#FFFF00",
	color100 = "#FAFAFA",
	color200 = "#D4D4D4",
	color300 = "#A9A9A9",
	color400 = "#696969",
	color500 = "#505050",
	color600 = "#303030",
	color700 = "#151515",
	color800 = "#000000",
	primary = "#FFBE89",
	success = "#7EAB8E",
	warning = "#FFF2AF",
	error = "#F57A7A",
	none = "none",
}

return {
	dir = "~/projects/vmcp/yugen.nvim",
	config = function()
		vim.cmd.colorscheme("yugen")
		local hl = function(group, styles)
			vim.api.nvim_set_hl(0, group, styles)
		end

		hl("CustomLualineMode", { bg = p.color800, fg = p.color400 })
		hl("MyDashboardFooter", { bg = p.color800, fg = p.color400 })

		hl("TelescopeResultsTitle", { bg = p.color700, fg = p.color700 })
		hl("TelescopePreviewBorder", { bg = p.color700, fg = p.color700 })

		hl("TelescopePreviewTitle", { bg = p.color700, fg = p.color700 })
		hl("TelescopePreviewNormal", { bg = p.color700, fg = p.color100 })
		hl("TelescopePreviewBorder", { bg = p.color700, fg = p.color700 })

		hl("TelescopeResultsNormal", { bg = p.color700, fg = p.color100 })
		hl("TelescopeResultsBorder", { bg = p.color700, fg = p.color700 })

		hl("TelescopePromptTitle", { bg = p.color600, fg = p.color100 })
		hl("TelescopePromptNormal", { bg = p.color700, fg = p.color100 })
		hl("TelescopePromptBorder", { bg = p.color700, fg = p.color700 })
		hl("WinSeparator", { bg = p.color800, fg = p.color700 })
	end,
}
