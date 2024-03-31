local palette = require('yugem.palette')

local yugem = {}

yugem.normal = {
	a = { fg = palette.background2, bg = palette.teal1, gui = 'bold' },
	b = { fg = palette.text, bg = palette.background1 },
	c = { fg = palette.blueGray1, bg = palette.none },
}

yugem.insert = {
	a = { fg = palette.background2, bg = palette.blue1, gui = 'bold' },
	b = { fg = palette.text, bg = palette.background1 },
}

yugem.visual = {
	a = { fg = palette.background2, bg = palette.yellow, gui = 'bold' },
	b = { fg = palette.text, bg = palette.background1 },
}

yugem.replace = {
	a = { fg = palette.background2, bg = palette.pink3, gui = 'bold' },
	b = { fg = palette.text, bg = palette.background1 },
}

yugem.command = {
	a = { fg = palette.background2, bg = palette.yellow, gui = 'bold' },
	b = { fg = palette.text, bg = palette.background1 },
}

yugem.inactive = {
	a = { fg = palette.blueGray3, bg = palette.background1, gui = 'bold' },
	b = { fg = palette.blueGray3, bg = palette.background1 },
	c = { fg = palette.blueGray3, bg = palette.none },
}

return yugem
