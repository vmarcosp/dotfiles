lua << EOF
require('nvim-autopairs').setup{}
require("nvim-web-devicons").set_icon {
  res = {
    icon = "■",
    color = "#e6484f",
    name = "rescript"
  }
}
EOF

lua << EOF
require("indent_blankline").setup {
    show_current_context = false,
    show_current_context_start = false,
}
EOF

set cursorline
au InsertEnter * highlight CursorLine ctermfg=none ctermbg=none cterm=none guifg=none guibg=none gui=none

lua << EOF
local home = os.getenv('HOME')
local db = require('dashboard')
db.default_banner = {
  "",
  "",
  "",
  "",
}

db.custom_footer = {"", " " .. vim.fn.getcwd():gsub(home, ""):gsub("/Projects", "") .. ""}

db.custom_center = {
     {
        icon = "  ",
        desc = "Open explorer                     ",
        action = "NvimTreeToggle",
        shortcut = "ctrl+n"
    },{
        icon = "  ",
        desc = "Find word                         ",
        action = "Telescope live_grep",
        shortcut = "ctrl+f"
    },
    {
        icon = "  ",
        desc = "Find  File                        ",
        action = "Telescope find_files find_command=rg,--hidden,--files",
        shortcut = "ctrl+p"
    },
  }

EOF

au VimEnter * Dashboard
