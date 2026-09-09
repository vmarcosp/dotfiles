local platform = require("config.platform")

if not platform.is_omarchy() then
	return {}
end

-- Preload every Omarchy colorscheme so `omarchy theme set` can hot-reload
-- without a Neovim restart. Specs match Omarchy's LazyVim all-themes.lua.
local specs = {
	{ "ribru17/bamboo.nvim", lazy = true, priority = 1000 },
	{
		"bjarneo/aether.nvim",
		branch = "v3",
		name = "aether",
		lazy = true,
		priority = 1000,
	},
	{ "bjarneo/ethereal.nvim", lazy = true, priority = 1000 },
	{ "bjarneo/hackerman.nvim", lazy = true, priority = 1000 },
	{ "bjarneo/vantablack.nvim", lazy = true, priority = 1000 },
	{ "bjarneo/white.nvim", lazy = true, priority = 1000 },
	{ "catppuccin/nvim", name = "catppuccin", lazy = true, priority = 1000 },
	{ "neanias/everforest-nvim", lazy = true, priority = 1000 },
	{ "kepano/flexoki-neovim", lazy = true, priority = 1000 },
	{ "ellisonleao/gruvbox.nvim", lazy = true, priority = 1000 },
	{ "rebelot/kanagawa.nvim", lazy = true, priority = 1000 },
	{ "tahayvr/matteblack.nvim", lazy = true, priority = 1000 },
	{ "gthelding/monokai-pro.nvim", lazy = true, priority = 1000 },
	{ "EdenEast/nightfox.nvim", lazy = true, priority = 1000 },
	{ "rose-pine/neovim", name = "rose-pine", lazy = true, priority = 1000 },
	{ "ficcdaf/ashen.nvim", lazy = true, priority = 1000 },
	{ "folke/tokyonight.nvim", lazy = true, priority = 1000 },
	{ "OldJobobo/miasma.nvim", lazy = true, priority = 1000 },
	{ "OldJobobo/retro-82.nvim", lazy = true, priority = 1000 },
	{ "omacom-io/lumon.nvim", lazy = true, priority = 1000 },
}

local function parse_theme_spec(theme_spec)
	local colorscheme
	local theme_plugin
	for _, spec in ipairs(theme_spec) do
		if spec[1] == "LazyVim/LazyVim" then
			colorscheme = spec.opts and spec.opts.colorscheme
		elseif spec[1] then
			theme_plugin = spec
		end
	end
	return colorscheme, theme_plugin
end

local function load_current_theme()
	local path = platform.omarchy_theme_lua()
	local ok, theme_spec = pcall(dofile, path)
	if not ok or type(theme_spec) ~= "table" then
		return nil, nil
	end
	return parse_theme_spec(theme_spec)
end

local colorscheme, current_plugin = load_current_theme()

if current_plugin then
	current_plugin.lazy = false
	current_plugin.priority = current_plugin.priority or 1000
	table.insert(specs, current_plugin)
end

local function apply_colorscheme(name)
	if not name then
		return
	end
	pcall(vim.cmd.colorscheme, name)
end

table.insert(specs, {
	name = "omarchy-theme-hotreload",
	dir = vim.fn.stdpath("config"),
	lazy = false,
	priority = 900,
	config = function()
		apply_colorscheme(colorscheme)

		local uv = vim.uv or vim.loop
		local watch_dir = vim.fn.expand("~/.local/state/omarchy/current")
		if vim.fn.isdirectory(watch_dir) == 0 then
			watch_dir = vim.fn.expand("~/.config/omarchy/current")
		end
		if vim.fn.isdirectory(watch_dir) == 0 then
			return
		end

		local function reload()
			local new_colorscheme, theme_plugin_spec = load_current_theme()
			if not new_colorscheme then
				return
			end
			colorscheme = new_colorscheme

			vim.cmd("highlight clear")
			if vim.fn.exists("syntax_on") == 1 then
				vim.cmd("syntax reset")
			end
			vim.o.background = "dark"

			local theme_plugin_name = theme_plugin_spec and (theme_plugin_spec.name or theme_plugin_spec[1])
			if theme_plugin_name then
				local plugin = require("lazy.core.config").plugins[theme_plugin_name]
				if plugin then
					local plugin_dir = plugin.dir .. "/lua"
					if vim.fn.isdirectory(plugin_dir) == 1 then
						require("lazy.core.util").walkmods(plugin_dir, function(modname)
							package.loaded[modname] = nil
							package.preload[modname] = nil
						end)
					end
					if plugin._.loaded then
						require("lazy.core.loader").reload(plugin)
					else
						require("lazy.core.loader").colorscheme(new_colorscheme)
					end
				else
					require("lazy.core.loader").colorscheme(new_colorscheme)
				end
			end

			vim.defer_fn(function()
				apply_colorscheme(new_colorscheme)
				vim.cmd("redraw!")
			end, 5)
		end

		local handle = uv.new_fs_event()
		uv.fs_event_start(
			handle,
			watch_dir,
			{ recursive = true },
			vim.schedule_wrap(function(err, filename)
				if err then
					return
				end
				if filename and not filename:match("neovim%.lua") and filename ~= "theme" then
					return
				end
				reload()
			end)
		)
	end,
})

return specs
