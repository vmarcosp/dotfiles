lua << EOF
local g = vim.g

g.nvim_tree_git_hl = git_status

require'nvim-tree'.setup {
  disable_netrw = true,
	hijack_netrw = true,
	open_on_setup = false,
	ignore_ft_on_setup = {},
	open_on_tab = false,
	hijack_cursor = false,
	update_cwd = true,
	diagnostics = {
		enable = true,
		icons = {
			hint = " ",
			info = " ",
			warning = " ",
			error = " ",
		},
	},
	update_focused_file = {
		enable = true,
		update_cwd = true,
		ignore_list = {},
	},
	system_open = {
		cmd = nil,
		args = {},
	},
	filters = {
		dotfiles = false,
		custom = { ".git", ".DS_Store" },
		exclude = { ".gitignore", ".github" },
	},
	git = {
		enable = true,
		ignore = true,
		timeout = 500,
	},
	renderer = {
		icons = {
			git_placement = "after",
			padding = "  ",
			glyphs = {
				default = "",
				symlink = "",
				folder = {
					arrow_closed = "",
					arrow_open = "",
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
					symlink_open = "",
				},
				git = {
					unstaged = "",
					staged = "",
					unmerged = "",
					renamed = "➜",
					untracked = "",
					deleted = "",
					ignored = "◌",
				},
			},
		},
	},
	view = {
		width = 36,
		hide_root_folder = true,
		side = "left",
		number = false,
		relativenumber = false,
	},
	trash = {
		cmd = "trash",
		require_confirm = true,
	},
	actions = {
		open_file = {
			quit_on_open = false,
			window_picker = {
				enable = false,
			},
		},
	},
}
EOF

set wildignore+=*/node_modules/*,*.reast,*.cmj,*.d,*.cmt,*.cmi,*.bs.js
