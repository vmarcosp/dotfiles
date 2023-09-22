local M = {}

M.plugins = {
  "rescript-lang/vim-rescript",
  "nkrkv/nvim-treesitter-rescript",
  "devongovett/tree-sitter-highlight",
  "virchau13/tree-sitter-astro",
  "ThePrimeagen/vim-be-good",
  "kchmck/vim-coffee-script",
  { "akinsho/toggleterm.nvim", version = "*", config = true },
  {
    "neanias/everforest-nvim",
    config = function()
      require("everforest").setup({
        background = "hard"
      })
      require("everforest").load()
    end,
    version = false,
    lazy = false,
    priority = 1000,
  }
}

M.mappings = {
  leader = "\\",
  custom = {
    ["<leader>t"] = { "<cmd>ToggleTerm direction=float<cr>", "Toggle Terminal" },
    ["<s-k>"] = { "5kzz", "Jump 5 lines above" },
    ["<s-j>"] = { "5jzz", "Jump 5 lines below" },
  }
}

M.theme = {}

M.flags = {
  disable_theme = true,
  format_on_save = true,
  disable_tabs = true
}

M.nvim_tree = {
  view = {
    adaptive_size = false
  }
}

M.lualine = {
  options = {
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  }
}

M.hooks = {
  after_setup = function()
    vim.cmd("set relativenumber")
    require("everforest").setup({
      background = "hard"
    })
    vim.filetype.add({
      extension = {
        astro = "astro"
      }
    })
  end
}

M.lsps = {
  ["rescriptls@latest-master"] = {},
  astro = {}
}

M.treesitter = "all"

M.unload_plugins = {
  "noice"
}

return M
