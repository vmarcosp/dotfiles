local Config = {}

local everforest = {
  "neanias/everforest-nvim",
  version = false,
  lazy = false,
  priority = 1000,
  config = function()
    local everforest = require("everforest")
    everforest.setup({ background = "hard" })
    everforest.load()
  end,
}

Config.plugins = {
  "rescript-lang/vim-rescript",
  "nkrkv/nvim-treesitter-rescript",
  "devongovett/tree-sitter-highlight",
  "rcarriga/nvim-notify",
  "kchmck/vim-coffee-script",
  "f-person/git-blame.nvim",
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

function get_bettervimrc()
  local config_file_path = os.getenv("HOME") .. "/.config/better-vim/.bettervimrc"
  local values = {}

  local file = io.open(config_file_path, "r")
  if not file then
    return values
  end

  for line in file:lines() do
    local key, value = line:match("export%s+([^=]+)=\"(.+)\"")
    if key and value then
      values[key] = value
    end
  end

  file:close()
  return values
end

vim.api.nvim_create_user_command('BetterVimLicense', function()
  local bettervimrc = get_bettervimrc()
  local message = "Your license: " .. bettervimrc["BETTER_VIM_LICENSE"]
  local opts = { title = "BetterVim", timeout = 1000 }
  require("notify")(message, "info", opts)
end, {})

vim.api.nvim_create_user_command('BetterVimVersion', function()
  local bettervimrc = get_bettervimrc()
  local message = "Your BetterVim is at v" .. bettervimrc["BETTER_VIM_VERSION"]
  local opts = { title = "BetterVim", timeout = 1000 }
  require("notify")(message, "info", opts)
end, {})


vim.api.nvim_create_user_command('BetterVimDocs', function()
  os.execute("open https://bettervim.com/docs")
end, {})

vim.api.nvim_create_user_command('BetterVimUpdate', function()
  local terminal = require('toggleterm.terminal').Terminal
  terminal:new({
    display_name = "Updating BetterVim",
    name = "Updating BetterVim",
    cmd = "bash ~/.config/nvim/better-vim-update.sh",
    direction = "float",
    float_opts = {
      border = 'curved',
      width = 28,
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

Config.mappings = {
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

Config.flags = {
  disable_auto_theme_loading = true,
  format_on_save = true,
  disable_tabs = true
}

Config.lualine = {
  options = {
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  }
}

Config.hooks = {
  after_setup = function()
    vim.o.relativenumber = 1
    -- Syntax highlight support for MDX
    vim.filetype.add({
      extension = {
        mdx = 'mdx',
      }
    })
    vim.treesitter.language.register('markdown', 'mdx')
  end
}

Config.lsps = {
  ["rescriptls@latest-master"] = {},
}


Config.treesitter = { "javascript", "typescript", "lua"}

Config.unload_plugins = { "noice" }

return Config
