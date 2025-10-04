return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("nvim-tree").setup({
			disable_netrw = true,
			hijack_netrw = true,
			open_on_tab = true,
			hijack_cursor = true,
			update_cwd = true,
			renderer = {
				root_folder_label = false,
				root_folder_modifier = table.concat({ ":t:gs?$?/", string.rep(" ", 1000), "?:gs?^??" }),
				highlight_opened_files = "all",
				highlight_git = true,
				add_trailing = true,
				special_files = {},
				indent_markers = {
					enable = true,
				},
				icons = {
					glyphs = {
						default = "",
						symlink = "",
						git = {
							deleted = "",
							ignored = "◌",
							renamed = "➜",
							staged = "✓",
							unmerged = "",
							unstaged = "",
							untracked = "",
						},
						folder = {
							arrow_open = "",
							arrow_closed = "",
							default = "",
							empty = "",
							empty_open = "",
							open = "",
							symlink = "",
							symlink_open = "󱧮",
						},
					},
				},
			},
			filters = {
				custom = { ".git", "node_modules" },
			},
			git = {
				enable = false,
				ignore = true,
			},
			update_focused_file = {
				enable = true,
				update_cwd = true,
			},
			view = {
				adaptive_size = true,
				side = "left",
				width = 32,
			},
		})
	end,
}
