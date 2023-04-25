return {
  mappings = {
    leader = "\\",
  },
  plugins = {
    "rescript-lang/vim-rescript",
    "nkrkv/nvim-treesitter-rescript",
    "devongovett/tree-sitter-highlight",
  },
  treesitter = "all",
  lsps = {
    ["rescriptls@latest-master"] = {},
  },
  theme = {
    name = "catppuccin",
  },
  flags = {
    disable_tabs = true
  },
  nvim_tree = {
    view = {
      hide_root_folder = true,
      adaptive_size = false
    }
  },
  hooks = {
    after_setup = function()
      vim.cmd("set relativenumber")
    end
  }
}
