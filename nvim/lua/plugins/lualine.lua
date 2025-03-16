local function make(section_config, excluded_buffers)
	excluded_buffers = excluded_buffers or { "Home" }

	local exclude_lookup = {}
	for _, buf_name in ipairs(excluded_buffers) do
		exclude_lookup[buf_name] = true
	end

	local result = {}
	for _, component in ipairs(section_config) do
		if component == "filename" then
			table.insert(result, {
				function()
					if vim.bo.filetype == "NvimTree" then
						return ""
					end

					local filename = vim.fn.expand("%:t")
					if exclude_lookup[filename] then
						return ""
					end

					return filename
				end,
			})
		elseif type(component) == "table" then
			local original_cond = component.cond
			component.cond = function()
				local filename = vim.fn.expand("%:t")
				if exclude_lookup[filename] then
					return false
				end

				if original_cond then
					return original_cond()
				end

				return true
			end
			table.insert(result, component)
		else
			table.insert(result, {
				component,
				cond = function()
					local filename = vim.fn.expand("%:t")
					return not exclude_lookup[filename]
				end,
			})
		end
	end

	return result
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
