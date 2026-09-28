local platform = require("config.platform")

if platform.is_omarchy() then
	return {}
end

-- Optional macOS theme. Switch with `theme everforest-light` / `theme yugen`.
local p = {
	fg = "#5C6A72",
	muted = "#829181",
	subtle = "#A6B0A0",
	title = "#E6E2CC",
	float = "#F4F0D9",
	primary = "#F57D26",
	none = "none",
}

local plugins = {
	yugen = "yugen.nvim",
	["everforest-light"] = "everforest-nvim",
}

-- Load the theme plugin on first switch, or re-run its config after that.
local function activate(name)
	local plugin = require("lazy.core.config").plugins[plugins[name] or plugins.yugen]
	if not plugin then
		return
	end
	if plugin._.loaded then
		require("lazy.core.loader").reload(plugin)
	else
		require("lazy").load({ plugins = { plugin.name } })
	end
end

local function watch()
	local uv = vim.uv or vim.loop
	local dir = vim.fn.fnamemodify(platform.macos_theme_file(), ":h")
	vim.fn.mkdir(dir, "p")
	local current = platform.macos_theme()
	local handle = uv.new_fs_event()
	-- `theme` writes via rename, so watch the dir and re-read the file.
	uv.fs_event_start(handle, dir, {}, vim.schedule_wrap(function(err)
		local name = platform.macos_theme()
		if err or name == current then
			return
		end
		current = name
		activate(name)
		vim.cmd("redraw!")
	end))
end

return {
	{
		"neanias/everforest-nvim",
		lazy = platform.macos_theme() ~= "everforest-light",
		priority = 1000,
		config = function()
			vim.o.background = "light"
			require("everforest").setup({ background = "medium" })
			vim.cmd.colorscheme("everforest")
			local hl = function(group, styles)
				vim.api.nvim_set_hl(0, group, styles)
			end

			hl("CustomLualineMode", { bg = p.none, fg = p.muted })

			hl("MyDashboardFooter", { bg = p.none, fg = p.primary })

			hl("TelescopeResultsTitle", { bg = p.float, fg = p.float })
			hl("TelescopePreviewTitle", { bg = p.float, fg = p.float })
			hl("TelescopePreviewNormal", { bg = p.float, fg = p.fg })
			hl("TelescopePreviewBorder", { bg = p.float, fg = p.float })

			hl("TelescopeResultsNormal", { bg = p.float, fg = p.fg })
			hl("TelescopeResultsBorder", { bg = p.float, fg = p.float })

			hl("TelescopePromptTitle", { bg = p.title, fg = p.fg })
			hl("TelescopePromptNormal", { bg = p.float, fg = p.fg })
			hl("TelescopePromptBorder", { bg = p.float, fg = p.float })
			hl("WinSeparator", { bg = p.none, fg = p.float })

			hl("SnacksDashboardHeader", { bg = p.none, fg = p.muted })
			hl("SnacksDashboardDesc", { bg = p.none, fg = p.subtle })
			hl("SnacksDashboardIcon", { bg = p.none, fg = p.subtle })
			hl("SnacksDashboardKey", { bg = p.none, fg = p.subtle })

			hl("NormalFloat", { bg = p.float, fg = p.fg })
			hl("FloatBorder", { bg = p.float, fg = p.float })

			-- Ícones do nvim-tree
			local devicons = require("nvim-web-devicons")
			local icons = devicons.get_icons()
			for _, icon in pairs(icons) do
				icon.color = p.primary
			end
			devicons.set_icon(icons)
		end,
	},
	{
		name = "macos-theme-hotreload",
		dir = vim.fn.stdpath("config"),
		lazy = false,
		config = watch,
	},
}
