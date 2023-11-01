local M = {}

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
  "rcarriga/nvim-notify",
  "kchmck/vim-coffee-script",
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
  },
  everforest
}

local Terminals = {}

Terminals.floating_window_opts = {
  border = 'curved',
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

vim.api.nvim_create_user_command('BetterVimUpdate', function()
  local terminal = require('toggleterm.terminal').Terminal
  terminal:new({
    display_name = "Updating BetterVim",
    name = "Updating BetterVim",
    cmd = "bash ~/.config/nvim/better-vim-update.sh",
    direction = "float",
    float_opts = {
      border = 'curved',
      width = 36,
      height = 3,
      winblend = 3,
      zindex = 999,
    },
    on_open = function()
      require("notify")("We're updating your config, please wait ⚙️", "info", { title = "BetterVim", timeout = 1000 })
    end,
    on_close = function()
      require("notify")("Successfully updated your config, reopen your Neovim", "info", { title = "BetterVim" })
    end
  }
  ):toggle()
end, {})

M.mappings = {
  leader = "\\",
  custom = {
    ["<leader>gt"] = {
      function()
        local terminal = require('toggleterm.terminal').Terminal
        terminal:new(Terminals.lazygit):toggle()
      end,
      'Open lazygit'
    },
    ["<leader>t"] = {
      function()
        local terminal = require('toggleterm.terminal').Terminal
        terminal:new(Terminals.default):toggle()
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
  disable_auto_theme_loading = true,
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
