local make = function(components)
	local updated_components = {}
	local hide_lookup = {
		"alpha",
		"TelescopePrompt",
		"toggleterm",
	}

	for i, component in ipairs(components) do
		local updated_component = component

		if type(component) == "table" then
			-- Handle nested tables (e.g., { "mode", color = "CustomLualineMode" })
			if component[1] and type(component[1]) == "string" then
				-- This is a component definition table, process it directly
				if component[1] == "filename" then
					updated_component = vim.tbl_extend("force", component, {
						[1] = function()
							if vim.bo.filetype == "NvimTree" then
								return ""
							end
							return vim.fn.expand("%:t")
						end,
					})
				end
				-- For component tables, add condition directly to the component
				updated_component.cond = function()
					return not vim.tbl_contains(hide_lookup, vim.bo.filetype)
				end
				updated_components[i] = updated_component
			else
				-- This is a table of sub-components, map over them
				updated_component = vim.tbl_map(function(sub_component)
					if sub_component == "filename" then
						return function()
							if vim.bo.filetype == "NvimTree" then
								return ""
							end

							return vim.fn.expand("%:t")
						end
					end
					return sub_component
				end, component)

				updated_components[i] = {
					updated_component,
					cond = function()
						return not vim.tbl_contains(hide_lookup, vim.bo.filetype)
					end,
				}
			end
		elseif component == "filename" then
			updated_component = function()
				if vim.bo.filetype == "NvimTree" then
					return ""
				end

				return vim.fn.expand("%:t")
			end

			updated_components[i] = {
				updated_component,
				cond = function()
					return not vim.tbl_contains(hide_lookup, vim.bo.filetype)
				end,
			}
		else
			updated_components[i] = {
				updated_component,
				cond = function()
					return not vim.tbl_contains(hide_lookup, vim.bo.filetype)
				end,
			}
		end
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
			lualine_a = make({ { "mode", color = "CustomLualineMode" } }),
			lualine_b = make({ { "filename", color = "CustomLualineMode" } }),
			lualine_c = make({}),
			lualine_x = make({ { "diagnostics", color = "CustomLualineMode" } }),
			lualine_y = make({ { "filetype", color = "CustomLualineMode" } }),
			lualine_z = make({ { "branch", color = "CustomLualineMode" } }),
		},
		tabline = {},
		winbar = {
			lualine_c = {
				{
					function()
						return require("nvim-navic").get_location()
					end,
					cond = function()
						return require("nvim-navic").is_available()
					end,
					color = "CustomLualineMode",
				},
			},
		},
		inactive_winbar = {},
		extensions = {},
	},
}
