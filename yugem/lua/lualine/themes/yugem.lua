local palette = require('yugem.palette')

local yugem = {}

yugem.normal = {
	a = { fg = palette.color800, bg = palette.color100, gui = 'bold' },
	b = { fg = palette.color100, bg = palette.color600 },
	c = { fg = palette.color400, bg = palette.none },
}

yugem.insert = {
	a = { fg = palette.color800, bg = palette.color100, gui = 'bold' },
	b = { fg = palette.color100, bg = palette.color600 },
}

yugem.visual = {
	a = { fg = palette.color800, bg = palette.color100, gui = 'bold' },
	b = { fg = palette.color100, bg = palette.color600 },
}

yugem.replace = {
	a = { fg = palette.color800, bg = palette.color100, gui = 'bold' },
	b = { fg = palette.color100, bg = palette.color600 },
}

yugem.command = {
	a = { fg = palette.color800, bg = palette.color100, gui = 'bold' },
	b = { fg = palette.color100, bg = palette.color600 },
}

yugem.inactive = {
	a = { fg = palette.blueGray3, bg = palette.background1, gui = 'bold' },
	b = { fg = palette.blueGray3, bg = palette.background1 },
	c = { fg = palette.blueGray3, bg = palette.none },
}

return yugem
