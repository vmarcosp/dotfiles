local hide = { alpha = true, TelescopePrompt = true, toggleterm = true, NvimTree = true }

local function visible()
	return not hide[vim.bo.filetype]
end

return {
	"nvim-lualine/lualine.nvim",
	opts = {
		options = {
			icons_enabled = true,
			theme = "auto",
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			always_divide_middle = true,
			globalstatus = true,
		},
		sections = {
			lualine_a = { { "mode", color = "CustomLualineMode", cond = visible } },
			lualine_b = {
				{
					function()
						if vim.bo.filetype == "NvimTree" then
							return ""
						end
						return vim.fn.expand("%:t")
					end,
					color = "CustomLualineMode",
					cond = visible,
				},
			},
			lualine_c = {},
			lualine_x = {},
			lualine_y = { { "filetype", color = "CustomLualineMode", cond = visible } },
			lualine_z = { { "branch", color = "CustomLualineMode", cond = visible } },
		},
		tabline = {},
		winbar = {},
		extensions = {},
	},
}
