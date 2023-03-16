lua << EOF
require("nvim-web-devicons").set_icon {
  res = {
    icon = "ﬦ",
    color = "#e6484f",
    name = "ReScript"
  }
}

require('gitsigns').setup()
EOF

set mouse=a
set relativenumber
