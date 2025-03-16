local make = function(components)
	local updated_components = {}
	local hide_lookup = {
		"alpha",
		"TelescopePrompt",
		"toggleterm",
	}

	for i, component in ipairs(components) do
		local updated_component = component

		if component == "filename" then
			updated_component = function()
				if vim.bo.filetype == "NvimTree" then
					return ""
				end

				return vim.fn.expand("%:t")
			end
		end

		updated_components[i] = {
			updated_component,
			cond = function()
				return not vim.tbl_contains(hide_lookup, vim.bo.filetype)
			end,
		}
	end

	return updated_components
end

return {
	"nvim-lualine/lualine.nvim",
	opts = {
		options = {
			icons_enabled = true,
			theme = "auto",
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = {
				statusline = { "" },
				winbar = {},
			},
			ignore_focus = {},
			always_divide_middle = true,
			always_show_tabline = true,
			globalstatus = true,
			refresh = {
				statusline = 100,
				tabline = 100,
				winbar = 100,
			},
		},
		sections = {
			lualine_a = make({ "mode" }),
			lualine_b = make({ "filename" }),
			lualine_c = make({}),
			lualine_x = make({ "diagnostics" }),
			lualine_y = make({ "filetype" }),
			lualine_z = make({ "branch" }),
		},
		tabline = {},
		winbar = {},
		inactive_winbar = {},
		extensions = {},
	},
}
