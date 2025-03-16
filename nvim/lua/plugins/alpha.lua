local function get_git_branch()
	local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
	if vim.v.shell_error ~= 0 or branch == "" then
		return nil
	end
	return branch
end

local function render_branch()
	local branch = get_git_branch()
	if branch then
		return "󰘬 " .. branch
	else
		return ""
	end
end

return {
	"goolord/alpha-nvim",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		dashboard.section.header.val = {
			"",
			"",
			"",
			"",
			"",
			"",
		}
		dashboard.section.buttons.val = {
			dashboard.button("P", "  > Find file", ":Telescope find_files<CR>"),
			dashboard.button("F", "  > Search", ":Telescope find_files<CR>"),
			dashboard.button("U", "  > Update plugins", ":Lazy update<CR>"),
		}

		for _, button in ipairs(dashboard.section.buttons.val) do
			button.opts.hl = "AlphaButtons"
			button.opts.hl_shortcut = "AlphaShortcut"
		end

		dashboard.section.footer.val = render_branch()
		dashboard.section.footer.opts.hl = "AlphaFooter"
		alpha.setup(dashboard.opts)
	end,
}
