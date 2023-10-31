local M = {}

local toggle_term = {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup {
      float_opts = {
        border = 'curved',
        width = 124,
        height = 16,
        winblend = 3,
        zindex = 999,
      },
    }
  end
}

local everforest = {
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


M.plugins = {
  "rescript-lang/vim-rescript",
  "nkrkv/nvim-treesitter-rescript",
  "devongovett/tree-sitter-highlight",
  "ThePrimeagen/vim-be-good",
  "kchmck/vim-coffee-script",
  toggle_term,
  everforest
}

M.mappings = {
  leader = "\\",
  custom = {
    ["<leader>gt"] = {
      function()
        vim.cmd(":ToggleTerm  direction=float")
        vim.cmd(":TermExec cmd='lazygit'")
      end,
      'Open lazygit'
    },
    ["<leader>t"] = {
      function()
        vim.cmd(":ToggleTerm  direction=float")
      end,
      'Open terminal'
    },
    ["<s-k>"] = { "5kzz", "Jump 5 lines above" },
    ["<s-j>"] = { "5jzz", "Jump 5 lines below" },
    -- Disabling nvim.tree
    ["<c-n>"] = { "", "" },
  }
}

M.theme = {}

M.flags = {
  disable_theme_loading = true,
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
        mdx = 'mdx',
      }
    })

    vim.treesitter.language.register('markdown', 'mdx')
  end
}

M.lsps = {
  ["rescriptls@latest-master"] = {},
}

-- M.treesitter = "all"

M.unload_plugins = {
  "noice"
}

return M
