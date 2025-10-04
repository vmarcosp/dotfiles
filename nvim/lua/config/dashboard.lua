local hour = tonumber(os.date("%H"))
local greeting
if hour < 12 then
	greeting = "good morning."
elseif hour < 18 then
	greeting = "good afternoon."
else
	greeting = "good evening."
end

return {
	enabled = true,
	width = 40,
	preset = {
		keys = {
			{ icon = "", key = "f", desc = "Find File", action = ":Telescope find_files" },
			{
				icon = "",
				key = "c",
				desc = "Config",
				action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
			},
			{ icon = "󰈆", key = "q", desc = "Quit", action = ":qa" },
		},
	},
	sections = {
		{ section = "keys", gap = 1, padding = 1 },
		{
			text = { { greeting, hl = "MyDashboardFooter" } },
			align = "center",
			padding = 1,
		},
	},
}
