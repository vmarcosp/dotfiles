local M = {}
local utils = require("better-vim-utils")

local copilot_chat_plugin = {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		{ "github/copilot.vim" },
		{ "nvim-lua/plenary.nvim", branch = "master" },
	},
	build = "make tiktoken",
	opts = {
		mappings = {
			complete = {
				detail = "Use @<Tab> or /<Tab> for options.",
				insert = "<S-Tab>",
			},
		},
	},
}

M.plugins = {
	"rescript-lang/vim-rescript",
	"devongovett/tree-sitter-highlight",
	"fladson/vim-kitty",
	"nvim-pack/nvim-spectre",
	"rescript-lang/tree-sitter-rescript",
	copilot_chat_plugin,
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = true,
	},
}

local Terminals = {}

Terminals.floating_window_opts = {
	border = "curved",
	width = 124,
	height = 16,
	winblend = 3,
	zindex = 999,
}

Terminals.lazygit = {
	cmd = "lazygit",
	direction = "float",
	float_opts = Terminals.floating_window_opts,
	on_open = function(term)
		vim.cmd("startinsert!")
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	end,
	on_close = function()
		vim.cmd("startinsert!")
	end,
}

Terminals.default = {
	direction = "float",
	float_opts = Terminals.floating_window_opts,
}

M.mappings = {
	leader = "\\",
	custom = {
		-- git + terminal stuff
		{
			"<leader>gt",
			function()
				local terminal = require("toggleterm.terminal").Terminal
				terminal:new(Terminals.lazygit):toggle()
			end,
			desc = "Open lazygit",
		},
		{
			"<leader>t",
			function()
				local terminal = require("toggleterm.terminal").Terminal
				terminal:new(Terminals.default):toggle()
			end,
			desc = "Open terminal",
		},
		{ "<leader>ft", "<cmd>Format<cr>" },
		-- AI stuff
		{ "<s-p>", "<cmd>CopilotChat<cr>" },
		-- Navigation
		{ "<s-k>", "5kzz", desc = "Jump 5 lines above" },
		{ "<s-j>", "5jzz", desc = "Jump 5 lines below" },
		{ "<s-j>", "5jzz", desc = "Jump 5 lines below" },
	},
}

M.flags = {
	disable_auto_theme_loading = true,
	format_on_save = true,
	disable_tabs = true,
}

M.lualine = {
	options = {
		globalstatus = true,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
	},
	sections = {
		a = { "mode" },
		b = { "branch" },
		c = { utils.statusline.get_file_name },
		z = { "filetype" },
	},
}

local setup_theme = function()
	require("catppuccin").setup({
		background = {
			light = "latte",
			dark = "mocha",
		},
		color_overrides = {
			all = {
				rosewater = "#eb7a73",
				flamingo = "#eb7a73",
				red = "#eb7a73",
				maroon = "#eb7a73",
				pink = "#e396a4",
				mauve = "#e396a4",
				peach = "#e89a5e",
				yellow = "#E7B84C",
				green = "#7cb66a",
				teal = "#99c792",
				sky = "#99c792",
				sapphire = "#99c792",
				blue = "#8dbba3",
				lavender = "#8dbba3",
				text = "#f1e4c2",
				subtext1 = "#e5d5b1",
				subtext0 = "#c5bda3",
				overlay2 = "#b8a994",
				overlay1 = "#595959",
				overlay0 = "#5d5d5d",
				surface2 = "#4d4d4d",
				surface1 = "#3A3A3A",
				surface0 = "#292929",
				base = "#1d2224",
				mantle = "#1d2224",
				crust = "#1f2223",
			},
		},
		transparent_background = false,
		show_end_of_buffer = false,
		integration_default = false,
		integrations = {
			barbecue = { dim_dirname = true, bold_basename = true, dim_context = false, alt_background = false },
			cmp = true,
			gitsigns = true,
			hop = true,
			illuminate = { enabled = true },
			native_lsp = { enabled = true, inlay_hints = { background = true } },
			neogit = true,
			neotree = true,
			semantic_tokens = true,
			treesitter = true,
			treesitter_context = true,
			vimwiki = true,
			which_key = true,
		},
		highlight_overrides = {
			all = function(colors)
				return {
					CmpItemMenu = { fg = colors.surface2 },
					CursorLineNr = { fg = colors.text },
					FloatBorder = { bg = colors.base, fg = colors.surface1 }, -- colors.surface0 }, difficult to see
					GitSignsChange = { fg = colors.peach },
					LineNr = { fg = colors.overlay0 },
					LspInfoBorder = { link = "FloatBorder" },
					NormalFloat = { bg = colors.base },
					Pmenu = { bg = colors.mantle, fg = "" },

					-- dashboard
					BvDashboardItemIcon = { fg = colors.blue },
					BvDashboardItemText = { fg = colors.text },
					BvDashboardKey = { fg = colors.blue },
					DashboardFooter = { fg = colors.green },

					NvimTreeWinSeparator = { fg = colors.surface0 },
					VertSplit = { fg = colors.text, bg = colors.base },

					-- telescope prompt
					TelescopePromptTitle = { fg = colors.mantle, bg = colors.blue, style = { "bold" } },
					TelescopePromptCounter = { fg = colors.text, style = { "bold" } },
					TelescopePromptBorder = { fg = colors.surface0, bg = colors.surface0 },
					TelescopePromptNormal = { fg = colors.text, bg = colors.surface0 },

					-- telescope results
					TelescopeResultsTitle = { link = "TelescopePromptTitle" },
					TelescopeResultsBorder = { fg = colors.surface0, bg = colors.surface0 },
					TelescopeResultsNormal = { fg = colors.text, bg = colors.surface0 },
					TelescopeSelection = { bg = "#2D2C2C" },

					-- telescope preview
					TelescopePreviewTitle = { fg = colors.mantle, bg = colors.blue, style = { "bold" } },
					TelescopePreviewNormal = { fg = "#2D2C2C", bg = "#2D2C2C" },
					TelescopePreviewBorder = { link = "TelescopePreviewNormal" },

					WhichKeyFloat = { bg = colors.mantle },
					YankHighlight = { bg = colors.surface2 },
					FidgetTask = { fg = colors.subtext2 },
					FidgetTitle = { fg = colors.peach },

					IblIndent = { fg = colors.surface0 },
					IblScope = { fg = colors.overlay0 },

					Boolean = { fg = colors.mauve },
					Number = { fg = colors.mauve },
					Float = { fg = colors.mauve },

					PreProc = { fg = colors.mauve },
					PreCondit = { fg = colors.mauve },
					Include = { fg = colors.mauve },
					Define = { fg = colors.mauve },
					Conditional = { fg = colors.red },
					Repeat = { fg = colors.red },
					Keyword = { fg = colors.red },
					Typedef = { fg = colors.red },
					Exception = { fg = colors.red },
					Statement = { fg = colors.red },

					Error = { fg = colors.red },
					StorageClass = { fg = colors.peach },
					Tag = { fg = colors.peach },
					Label = { fg = colors.peach },
					Structure = { fg = colors.peach },
					Operator = { fg = colors.sapphire },
					Title = { fg = colors.peach },
					Special = { fg = colors.yellow },
					SpecialChar = { fg = colors.yellow },
					Type = { fg = colors.yellow, style = { "bold" } },
					Function = { fg = colors.green, style = { "bold" } },
					Delimiter = { fg = colors.subtext2 },
					Ignore = { fg = colors.subtext2 },
					Macro = { fg = colors.teal },

					TSAnnotation = { fg = colors.mauve },
					TSAttribute = { fg = colors.mauve },
					TSBoolean = { fg = colors.mauve },
					TSCharacter = { fg = colors.teal },
					TSCharacterSpecial = { link = "SpecialChar" },
					TSComment = { link = "Comment" },
					TSConditional = { fg = colors.red },
					TSConstBuiltin = { fg = colors.mauve },
					TSConstMacro = { fg = colors.mauve },
					TSConstant = { fg = colors.text },
					TSConstructor = { fg = colors.green },
					TSDebug = { link = "Debug" },
					TSDefine = { link = "Define" },
					TSEnvironment = { link = "Macro" },
					TSEnvironmentName = { link = "Type" },
					TSError = { link = "Error" },
					TSException = { fg = colors.red },
					TSField = { fg = colors.blue },
					TSFloat = { fg = colors.mauve },
					TSFuncBuiltin = { fg = colors.green },
					TSFuncMacro = { fg = colors.green },
					TSFunction = { fg = colors.green },
					TSFunctionCall = { fg = colors.green },
					TSInclude = { fg = colors.red },
					TSKeyword = { fg = colors.red },
					TSKeywordFunction = { fg = colors.red },
					TSKeywordOperator = { fg = colors.sapphire },
					TSKeywordReturn = { fg = colors.red },
					TSLabel = { fg = colors.peach },
					TSLiteral = { link = "String" },
					TSMath = { fg = colors.blue },
					TSMethod = { fg = colors.green },
					TSMethodCall = { fg = colors.green },
					TSNamespace = { fg = colors.yellow },
					TSNone = { fg = colors.text },
					TSNumber = { fg = colors.mauve },
					-- TSOperator = { fg = colors.sapphire },
					TSOperator = { fg = colors.peach },
					TSParameter = { fg = colors.text },
					TSParameterReference = { fg = colors.text },
					TSPreProc = { link = "PreProc" },
					TSProperty = { fg = colors.blue },
					TSPunctBracket = { fg = colors.text },
					TSPunctDelimiter = { link = "Delimiter" },
					TSPunctSpecial = { fg = colors.blue },
					TSRepeat = { fg = colors.red },
					TSStorageClass = { fg = colors.peach },
					TSStorageClassLifetime = { fg = colors.peach },
					TSStrike = { fg = colors.subtext2 },
					TSString = { fg = colors.teal },
					TSStringEscape = { fg = colors.green },
					TSStringRegex = { fg = colors.green },
					TSStringSpecial = { link = "SpecialChar" },
					TSSymbol = { fg = colors.text },
					TSTag = { fg = colors.peach },
					TSTagAttribute = { fg = colors.green },
					TSTagDelimiter = { fg = colors.green },
					TSText = { fg = colors.green },
					TSTextReference = { link = "Constant" },
					TSTitle = { link = "Title" },
					TSTodo = { link = "Todo" },
					TSType = { fg = colors.yellow, style = { "bold" } },
					TSTypeBuiltin = { fg = colors.yellow, style = { "bold" } },
					TSTypeDefinition = { fg = colors.yellow, style = { "bold" } },
					TSTypeQualifier = { fg = colors.peach, style = { "bold" } },
					TSURI = { fg = colors.blue },
					TSVariable = { fg = colors.text },
					TSVariableBuiltin = { fg = colors.mauve },

					["@annotation"] = { link = "TSAnnotation" },
					["@attribute"] = { link = "TSAttribute" },
					["@boolean"] = { link = "TSBoolean" },
					["@character"] = { link = "TSCharacter" },
					["@character.special"] = { link = "TSCharacterSpecial" },
					["@comment"] = { link = "TSComment" },
					["@conceal"] = { link = "Grey" },
					["@conditional"] = { link = "TSConditional" },
					["@constant"] = { link = "TSConstant" },
					["@constant.builtin"] = { link = "TSConstBuiltin" },
					["@constant.macro"] = { link = "TSConstMacro" },
					["@constructor"] = { link = "TSConstructor" },
					["@debug"] = { link = "TSDebug" },
					["@define"] = { link = "TSDefine" },
					["@error"] = { link = "TSError" },
					["@exception"] = { link = "TSException" },
					["@field"] = { link = "TSField" },
					["@float"] = { link = "TSFloat" },
					["@function"] = { link = "TSFunction" },
					["@function.builtin"] = { link = "TSFuncBuiltin" },
					["@function.call"] = { link = "TSFunctionCall" },
					["@function.macro"] = { link = "TSFuncMacro" },
					["@include"] = { link = "TSInclude" },
					["@keyword"] = { link = "TSKeyword" },
					["@keyword.function"] = { link = "TSKeywordFunction" },
					["@keyword.operator"] = { link = "TSKeywordOperator" },
					["@keyword.return"] = { link = "TSKeywordReturn" },
					["@label"] = { link = "TSLabel" },
					["@math"] = { link = "TSMath" },
					["@method"] = { link = "TSMethod" },
					["@method.call"] = { link = "TSMethodCall" },
					["@namespace"] = { link = "TSNamespace" },
					["@none"] = { link = "TSNone" },
					["@number"] = { link = "TSNumber" },
					["@operator"] = { link = "TSOperator" },
					["@parameter"] = { link = "TSParameter" },
					["@parameter.reference"] = { link = "TSParameterReference" },
					["@preproc"] = { link = "TSPreProc" },
					["@property"] = { link = "TSProperty" },
					["@punctuation.bracket"] = { link = "TSPunctBracket" },
					["@punctuation.delimiter"] = { link = "TSPunctDelimiter" },
					["@punctuation.special"] = { link = "TSPunctSpecial" },
					["@repeat"] = { link = "TSRepeat" },
					["@storageclass"] = { link = "TSStorageClass" },
					["@storageclass.lifetime"] = { link = "TSStorageClassLifetime" },
					["@strike"] = { link = "TSStrike" },
					["@string"] = { link = "TSString" },
					["@string.escape"] = { link = "TSStringEscape" },
					["@string.regex"] = { link = "TSStringRegex" },
					["@string.special"] = { link = "TSStringSpecial" },
					["@symbol"] = { link = "TSSymbol" },
					["@tag"] = { link = "TSTag" },
					["@tag.attribute"] = { link = "TSTagAttribute" },
					["@tag.delimiter"] = { link = "TSTagDelimiter" },
					["@text"] = { link = "TSText" },
					["@text.danger"] = { link = "TSDanger" },
					["@text.diff.add"] = { link = "diffAdded" },
					["@text.diff.delete"] = { link = "diffRemoved" },
					["@text.emphasis"] = { link = "TSEmphasis" },
					["@text.environment"] = { link = "TSEnvironment" },
					["@text.environment.name"] = { link = "TSEnvironmentName" },
					["@text.literal"] = { link = "TSLiteral" },
					["@text.math"] = { link = "TSMath" },
					["@text.note"] = { link = "TSNote" },
					["@text.reference"] = { link = "TSTextReference" },
					["@text.strike"] = { link = "TSStrike" },
					["@text.strong"] = { link = "TSStrong" },
					["@text.title"] = { link = "TSTitle" },
					["@text.todo"] = { link = "TSTodo" },
					["@text.todo.checked"] = { link = "Green" },
					["@text.todo.unchecked"] = { link = "Ignore" },
					["@text.underline"] = { link = "TSUnderline" },
					["@text.uri"] = { link = "TSURI" },
					["@text.warning"] = { link = "TSWarning" },
					["@todo"] = { link = "TSTodo" },
					["@type"] = { link = "TSType" },
					["@type.builtin"] = { link = "TSTypeBuiltin" },
					["@type.definition"] = { link = "TSTypeDefinition" },
					["@type.qualifier"] = { link = "TSTypeQualifier" },
					["@uri"] = { link = "TSURI" },
					["@variable"] = { link = "TSVariable" },
					["@variable.builtin"] = { link = "TSVariableBuiltin" },

					["@lsp.type.class"] = { link = "TSType" },
					["@lsp.type.comment"] = { link = "TSComment" },
					["@lsp.type.decorator"] = { link = "TSFunction" },
					["@lsp.type.enum"] = { link = "TSType" },
					["@lsp.type.enumMember"] = { link = "TSProperty" },
					["@lsp.type.events"] = { link = "TSLabel" },
					["@lsp.type.function"] = { link = "TSFunction" },
					["@lsp.type.interface"] = { link = "TSType" },
					["@lsp.type.keyword"] = { link = "TSKeyword" },
					["@lsp.type.macro"] = { link = "TSConstMacro" },
					["@lsp.type.method"] = { link = "TSMethod" },
					["@lsp.type.modifier"] = { link = "TSTypeQualifier" },
					["@lsp.type.namespace"] = { link = "TSNamespace" },
					["@lsp.type.number"] = { link = "TSNumber" },
					["@lsp.type.operator"] = { link = "TSOperator" },
					["@lsp.type.parameter"] = { link = "TSParameter" },
					["@lsp.type.property"] = { link = "TSProperty" },
					["@lsp.type.regexp"] = { link = "TSStringRegex" },
					["@lsp.type.string"] = { link = "TSString" },
					["@lsp.type.struct"] = { link = "TSType" },
					["@lsp.type.type"] = { link = "TSType" },
					["@lsp.type.typeParameter"] = { link = "TSTypeDefinition" },
					["@lsp.type.variable"] = { link = "TSVariable" },
				}
			end,
			latte = function(colors)
				return {
					IblIndent = { fg = colors.mantle },
					IblScope = { fg = colors.surface1 },

					LineNr = { fg = colors.surface1 },
				}
			end,
		},
	})

	vim.api.nvim_command("colorscheme catppuccin-frappe")
end

M.hooks = {
	after_setup = function()
		setup_theme()
		require("nvim-web-devicons").set_icon({
			toml = {
				icon = "󰅪",
				name = "TOML",
			},
		})
		-- Remove the ~ from empty lines
		vim.opt.fillchars = { eob = " " }
		vim.o.relativenumber = true
		-- Syntax highlight support for MDX
		vim.filetype.add({
			extension = {
				mdx = "mdx",
			},
		})
		vim.treesitter.language.register("markdown", "mdx")
		vim.treesitter.language.register("bash", "sh")
		local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
		parser_config.rescript = {
			install_info = {
				url = "https://github.com/rescript-lang/tree-sitter-rescript",
				branch = "main",
				files = { "src/scanner.c" },
				generate_requires_npm = false,
				requires_generate_from_grammar = true,
				use_makefile = true, -- macOS specific instruction
			},
		}
	end,
}

M.lsps = {
	bashls = {},
	rescriptls = {},
	graphql = {},
	tailwindcss = {},
	cssls = {},
	cssmodules_ls = {},
	biome = {},
	rust_analyzer = {},
}
M.treesitter = { "javascript", "typescript", "lua", "bash", "ocaml", "rust" }
M.unload_plugins = { "noice" }

return M
