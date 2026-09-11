-- Let the terminal background (Ghostty's blur/opacity) show through Neovim.
local groups = {
	"Normal",
	"NormalNC",
	"NonText",
	"EndOfBuffer",
	"SignColumn",
	"LineNr",
	"CursorLineNr",
	"FoldColumn",
	"Folded",
	"MsgArea",
	"MsgSeparator",
	"VertSplit",
	"WinSeparator",
	"StatusLine",
	"StatusLineNC",
	"TabLine",
	"TabLineFill",
	"NvimTreeNormal",
	"NvimTreeNormalNC",
	"NvimTreeEndOfBuffer",
	"NvimTreeWinSeparator",
	"NvimTreeStatusLine",
	"GitSignsAdd",
	"GitSignsChange",
	"GitSignsDelete",
	"DiagnosticSignError",
	"DiagnosticSignWarn",
	"DiagnosticSignInfo",
	"DiagnosticSignHint",
}

local function clear_bg(group)
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
	if not ok or vim.tbl_isempty(hl) then
		return
	end
	hl.bg = nil
	hl.ctermbg = nil
	vim.api.nvim_set_hl(0, group, hl)
end

local function apply()
	for _, group in ipairs(groups) do
		clear_bg(group)
	end
end

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("transparent-background", { clear = true }),
	callback = vim.schedule_wrap(apply),
})

-- Plugins that define their own groups load after the colorscheme.
vim.api.nvim_create_autocmd("VimEnter", { callback = vim.schedule_wrap(apply) })

apply()
