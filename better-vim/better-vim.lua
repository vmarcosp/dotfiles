return {
  mappings = {
    leader = "\\",
  },
  flags = {
    disable_tabs = true
  },
  lualine = {
    sections = {
      x = {
       {'filetype', separator = nil},
       {'diagnostics', separator = nil},
    }
  }
 }
}
