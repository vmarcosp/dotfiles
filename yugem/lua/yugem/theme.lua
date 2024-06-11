local blend = require('yugem.utils').blend

local M = {}

function M.get(config)
  local p = require 'yugem.palette'

  local theme = {}
  local groups = config.groups or {}
  local styles = {
    italic = (config.disable_italics and p.none) or 'italic',
    vert_split = (config.bold_vert_split and groups.border) or p.none,
    background = (config.disable_background and p.none) or groups.background,
    float_background = (config.disable_float_background and p.none) or groups.panel,
  }
  styles.nc_background = (config.dim_nc_background and not config.disable_background and groups.panel)
      or styles.background

  theme = {
    ColorColumn = { bg = p.blueGray1 },
    Conceal = { bg = p.none },
    CurSearch = { link = 'IncSearch' },
    Cursor = { fg = p.background3, bg = p.blueGray1 },
    CursorColumn = { bg = p.background1 },
    CursorLine = { bg = p.color600 },
    CursorLineNr = { fg = p.color300 },
    DarkenedPanel = { bg = groups.panel },
    DarkenedStatusline = { bg = groups.panel },
    DiffAdd = { bg = blend(groups.git_add, groups.background, 0.5) },
    DiffChange = { bg = p.blueGray1 },
    DiffDelete = { bg = blend(groups.git_delete, groups.background, 0.5) },
    DiffText = { bg = blend(groups.git_text, groups.background, 0.5) },
    diffAdded = { link = 'DiffAdd' },
    diffChanged = { link = 'DiffChange' },
    diffRemoved = { link = 'DiffDelete' },
    Directory = { fg = p.blue3, bg = p.none },
    ErrorMsg = { fg = p.error, style = 'bold' },
    FloatBorder = { fg = groups.border },
    FloatTitle = { fg = p.blueGray2 },
    FoldColumn = { fg = p.blueGray2 },
    Folded = { fg = p.text, bg = groups.panel },
    IncSearch = { fg = p.color200, bg = p.color600 },
    LineNr = { fg = p.color500 },
    MatchParen = { fg = p.color200, bg = p.color700 },
    ModeMsg = { fg = p.color200 },
    MoreMsg = { fg = p.color200 },
    NonText = { fg = p.color500 },
    Normal = { fg = p.color200, bg = styles.color800 },
    NormalFloat = { fg = p.color200, bg = styles.color700 },
    NormalNC = { fg = p.text, bg = styles.nc_background },
    NvimInternalError = { fg = p.error, bg = p.color700 },
    Pmenu = { fg = p.color200, bg = p.color700 },
    PmenuSbar = { bg = p.colo700 },
    PmenuSel = { fg = p.color200, bg = p.color400 },
    PmenuThumb = { bg = p.color600 },
    Question = { fg = p.warning },
    RedrawDebugClear = { fg = '#ffffff', bg = p.warning },
    RedrawDebugComposed = { fg = '#ffffff', bg = p.teal2 },
    RedrawDebugRecompose = { fg = p.error, bg = p.color700 },
    Search = { fg = p.color200, bg = p.color600 },
    SpecialKey = { fg = p.teal1 },
    SpellBad = { sp = p.error, style = 'undercurl' },
    SpellCap = { sp = p.blue1, style = 'undercurl' },
    SpellLocal = { sp = p.warning, style = 'undercurl' },
    SpellRare = { sp = p.blue1, style = 'undercurl' },
    SignColumn = { fg = p.text, bg = p.none },
    StatusLine = { fg = p.blue3, bg = styles.float_background },
    StatusLineNC = { fg = p.blue3, bg = styles.background },
    StatusLineTerm = { link = 'StatusLine' },
    StatusLineTermNC = { link = 'StatusLineNC' },
    TabLine = { fg = p.blue3, bg = styles.float_background },
    TabLineFill = { bg = styles.float_background },
    TabLineSel = { fg = p.text, bg = p.background1 },
    Title = { fg = p.text },
    VertSplit = { fg = groups.border, bg = styles.vert_split },
    Visual = { fg = p.color200, bg = p.color600 },
    WarningMsg = { fg = p.warning },
    Whitespace = { fg = p.color700 },
    WildMenu = { link = 'IncSearch' },

    Constant = { fg = p.color200 },       -- (preferred) any constant
    String = { fg = p.primary },          --   a string constant: "this is a string"
    Character = { fg = p.successuccess }, --  a character constant: 'c', '\n'
    Number = { fg = p.primary },          --   a number constant: 234, 0xff
    Boolean = { fg = p.primary },         --  a boolean constant: TRUE, false
    Float = { fg = p.primary },           --    a floating point constant: 2.3e10

    Identifier = { fg = p.teal3 },        -- (preferred) any variable name
    Function = { fg = p.primary },        -- function name (also: methods for classes)

    Statement = { fg = p.text },          -- (preferred) any statement
    Conditional = { fg = p.blueGray1 },   --  if, then, else, endif, switch, etc.
    Repeat = { fg = p.blue3 },            --   for, do, while, etc.
    Label = { fg = p.text },              --    case, default, etc.
    Operator = { fg = p.color400 },       -- "sizeof", "+", "*", etc.
    Keyword = { fg = p.color400 },        --  any other keyword
    Exception = { fg = p.blue3 },         --  try, catch, throw

    PreProc = { fg = p.text },            -- (preferred) generic Preprocessor
    Include = { fg = p.blueGray1 },       --  preprocessor #include

    Type = { fg = p.color300 }, -- (preferred) int, long, char, etc.

    Special = { fg = p.blueGray2 },       -- (preferred) any special symbol
    Tag = { fg = p.primary },             --    you can use CTRL-] on this
    Delimiter = { fg = p.blueGray1 },     --  character that needs attention
    SpecialComment = { fg = p.color500 }, -- special things inside a comment

    Comment = { fg = p.color500 },        -- (preferred) any special symbol

    Underlined = { style = 'underline' }, -- (preferred) text that stands out, HTML links
    Bold = { style = 'bold' },
    Italic = { style = 'italic' },
    qfLineNr = { fg = p.blueGray3 },
    qfFileName = { fg = p.blueGray2 },
    debugPC = { bg = p.background1 },                       -- used for highlighting the current line in terminal-debug
    debugBreakpoint = { bg = p.background2, fg = p.pink3 }, -- used for breakpoint colors in terminal-debug
    DiagnosticError = { fg = groups.error },
    DiagnosticHint = { fg = groups.hint },
    DiagnosticInfo = { fg = groups.info },
    DiagnosticWarn = { fg = groups.warn },
    DiagnosticDefaultError = { fg = groups.error },
    DiagnosticDefaultHint = { fg = groups.hint },
    DiagnosticDefaultInfo = { fg = groups.info },
    DiagnosticDefaultWarn = { fg = groups.warn },
    DiagnosticFloatingError = { fg = groups.error },
    DiagnosticFloatingHint = { fg = groups.hint },
    DiagnosticFloatingInfo = { fg = groups.info },
    DiagnosticFloatingWarn = { fg = groups.warn },
    DiagnosticSignError = { fg = groups.error },
    DiagnosticSignHint = { fg = groups.hint },
    DiagnosticSignInfo = { fg = groups.info },
    DiagnosticSignWarn = { fg = groups.warn },
    DiagnosticStatusLineError = { fg = groups.error, bg = groups.panel },
    DiagnosticStatusLineHint = { fg = groups.hint, bg = groups.panel },
    DiagnosticStatusLineInfo = { fg = groups.info, bg = groups.panel },
    DiagnosticStatusLineWarn = { fg = groups.warn, bg = groups.panel },
    DiagnosticUnderlineError = { sp = groups.error, style = 'undercurl' },
    DiagnosticUnderlineHint = { sp = groups.hint, style = 'undercurl' },
    DiagnosticUnderlineInfo = { sp = groups.info, style = 'undercurl' },
    DiagnosticUnderlineWarn = { sp = groups.warn, style = 'undercurl' },
    DiagnosticVirtualTextError = { fg = groups.error },
    DiagnosticVirtualTextHint = { fg = groups.hint },
    DiagnosticVirtualTextInfo = { fg = groups.info },
    DiagnosticVirtualTextWarn = { fg = groups.warn },

    -- Treesitter
    ['@variable'] = { fg = p.color200 },
    ['@boolean'] = { link = 'Boolean' },
    ['@comment'] = { link = 'Comment' },
    ['@variable.builtin'] = { fg = p.color300 },
    ['@constant.builtin'] = { fg = p.color300 },
    ['@constant.falsy'] = { fg = p.primary },
    ['@constructor'] = { fg = p.color500 },
    ['field'] = { fg = p.text },
    ['@function.builtin'] = { fg = p.color300 },
    ['@function'] = { link = 'Function' },
    ['@function.call'] = { fg = p.primary },
    TSInclude = { fg = p.blue2 },
    ['@keyword'] = { link = 'Keyword' },
    ['@keyword.return'] = { fg = p.color300 },
    ['@keyword.function'] = { fg = p.color300 },
    ['@keyword.operator'] = { fg = p.color400 },
    ['@label'] = { fg = p.color500 },
    ['@method'] = { fg = p.teal1 },
    ['@operator'] = { fg = 'color400' },
    ['@parameter'] = { fg = p.text },
    ['@property'] = { fg = p.color300 },
    ['@punctuation.delimiter'] = { fg = groups.punctuation },
    ['@punctuation.special'] = { fg = groups.punctuation },
    ['@punctuation.bracket'] = { fg = p.color400 },
    ['@string'] = { fg = p.color400 },
    ['@string.escape'] = { fg = p.color100 },
    ['@tag'] = { fg = p.primary },
    ['@tag.delimiter'] = { fg = p.color400 },
    ['@tag.attribute'] = { fg = p.color300, style = styles.italic },
    ['@text'] = { fg = p.color200 },
    ['@title'] = { fg = groups.headings.h1, style = 'bold' },
    ['@type'] = { link = 'Type' },
    ['@type.builtin'] = { link = 'Type' },
    TSURI = { fg = groups.link },

    -- tsx
    ['@keyword.export.tsx'] = { fg = p.color400 },
    ['@keyword.import.tsx'] = { fg = p.color400 },
    ['@import.identifier.tsx'] = { fg = p.color300 },

    -- typescript
    ['@keyword.export.typescript'] = { fg = p.color400 },
    ['@keyword.import.typescript'] = { fg = p.color400 },
    ['@import.identifier.typescript'] = { fg = p.color300 },
    typescriptVariable = { fg = p.blue2 },
    typescriptExport = { fg = p.teal1 },
    typescriptDefault = { fg = p.teal1 },
    typescriptConstraint = { fg = p.teal1 },
    typescriptBlock = { fg = p.text },
    typescriptIdentifierName = { fg = p.blueGray2 },
    typescriptTSInclude = { fg = p.teal1 },
    typescriptCastKeyword = { fg = p.blueGray2 },
    typescriptEnum = { fg = p.blue4 },
    typescriptTypeCast = { fg = p.blueGray2 },
    typescriptParenExp = { fg = p.blueGray2 },
    typescriptObjectType = { fg = p.blueGray1 },

    -- lua
    luaTSConstructor = { fg = p.blueGray1 },

    -- vim.lsp.buf.document_highlight()
    LspReferenceText = { bg = p.blue2 },
    LspReferenceRead = { bg = p.blue2 },
    LspReferenceWrite = { bg = p.blue2 },

    -- lsp-highlight-codelens
    LspCodeLens = { fg = p.blueGray1 },          -- virtual text of code lens
    LspCodeLensSeparator = { fg = p.blueGray3 }, -- separator between two or more code lens

    -- lewis6991/gitsigns.nvim
    GitSignsAdd = { fg = groups.git_add },
    GitSignsChange = { fg = groups.git_change },
    GitSignsDelete = { fg = groups.git_delete },
    SignAdd = { link = 'GitSignsAdd' },
    SignChange = { link = 'GitSignsChange' },
    SignDelete = { link = 'GitSignsDelete' },

    -- NvimTree
    NvimTreeFileDirty = { fg = p.color200 },
    NvimTreeFileNew = { fg = p.color200 },
    NvimTreeFileRenamed = { fg = p.color200 },
    NvimTreeFileStaged = { fg = p.color200 },
    NvimTreeFolderIcon = { fg = p.color400 },
    NvimTreeFolderName = { fg = p.color300 },
    NvimTreeGitDeleted = { fg = groups.color200 },
    NvimTreeGitDirty = { fg = p.color200 },
    NvimTreeGitIgnored = { fg = groups.git_ignore },
    NvimTreeGitMerge = { fg = groups.git_merge },
    NvimTreeGitNew = { fg = groups.git_add },
    NvimTreeGitRenamed = { fg = groups.git_rename },
    NvimTreeGitStaged = { fg = groups.git_stage },
    NvimTreeImageFile = { fg = p.color100 },
    NvimTreeExecFile = { fg = p.color100 },
    NvimTreeNormal = { fg = p.color200 },
    NvimTreeOpenedFile = { fg = p.color400, bg = 'none' },
    NvimTreeOpenedFolderName = { link = 'NvimTreeFolderName' },
    NvimTreeRootFolder = { fg = p.color100 },
    NvimTreeSpecialFile = { link = 'NvimTreeNormal' },
    NvimTreeWindowPicker = { fg = p.color100, bg = p.color600 },
    WinSeparator = { fg = p.color600, bg = p.color800 },

    -- folke/which-key.nvim
    WhichKey = { fg = p.color200 },
    WhichKeyGroup = { fg = p.color200 },
    WhichKeySeparator = { fg = p.color500 },
    WhichKeyDesc = { fg = p.color200 },
    WhichKeyBorder = { bg = p.color200 },
    WhichKeyFloat = { bg = p.color700 },
    WhichKeyValue = { fg = p.color200 },

    -- Nvim Cmp
    CmpItemAbbr = { fg = p.blueGray2 },
    CmpItemAbbrDeprecated = { fg = p.color700, style = 'strikethrough' },
    CmpItemAbbrMatch = { fg = p.color300 },
    CmpItemAbbrMatchFuzzy = { fg = p.color100 },
    CmpItemKind = { fg = p.primary },
    CmpItemKindClass = { fg = p.primary },
    CmpItemKindFunction = { fg = p.primary },
    CmpItemKindInterface = { fg = p.primary },
    CmpItemKindMethod = { fg = p.primary },
    CmpItemKindSnippet = { fg = p.primary },
    CmpItemKindVariable = { fg = p.primary },

    -- ray-x/lsp_signature.nvim
    LspSignatureActiveParameter = { bg = p.blueGray1 },

    -- Telescope
    TelescopeMatching = { fg = p.primary },
    TelescopeNormal = { fg = p.color200 },
    TelescopeSelection = { fg = p.color200, bg = p.color700 },
    TelescopeTitle = { fg = p.color200 },
    TelescopeBorder = { fg = p.color600 },
    TelescopePromptBorder = { fg = p.color700 },
    TelescopePromptNormal = { fg = p.color100 },
    TelescopePromptPrefix = { fg = p.color200 },
    TelescopePreviewTitle = { fg = p.color100, bg = p.color700 },
    TelescopePromptTitle = { fg = p.color100, bg = p.color700 },
    TelescopeResultsDiffAdd = { fg = p.primary },
    TelescopeResultsDiffChange = { fg = p.color600 },
    TelescopeResultsDiffDelete = { fg = p.primary },

    -- Dashboard
    DashboardFooter = { fg = p.color400, bg = 'none', bold = true },
    BvDashboardKey = { fg = p.color100, bg = 'none', bold = true },
    BvDashboardItemIcon = { fg = p.color300 },
    BvDashboardItemText = { fg = p.color300 },

    -- code action
    ActionPreviewNormal = { link = 'SagaNormal' },
    ActionPreviewBorder = { link = 'SagaBorder' },
    ActionPreviewTitle = { fg = p.blueGray2, bg = p.background2 },
    CodeActionNormal = { link = 'SagaNormal' },
    CodeActionBorder = { link = 'SagaBorder' },
    CodeActionText = { fg = p.warning },
    CodeActionNumber = { fg = p.blue3 },
    -- finder
    FinderSelection = { fg = p.blueGray2, bold = true },
    FinderFileName = { fg = p.white },
    FinderCount = { link = 'Label' },
    FinderIcon = { fg = p.warning },
    FinderType = { fg = p.teal1 },
    --finder spinner
    FinderSpinnerTitle = { fg = p.pink3, bold = true },
    FinderSpinner = { fg = p.pink3, bold = true },
    FinderPreviewSearch = { link = 'Search' },
    FinderVirtText = { fg = p.blue1 },
    FinderNormal = { link = 'SagaNormal' },
    FinderBorder = { link = 'SagaBorder' },
    FinderPreviewBorder = { link = 'SagaBorder' },
    -- definitionheading
    DefinitionBorder = { link = 'SagaBorder' },
    DefinitionNormal = { link = 'SagaNormal' },
    DefinitionSearch = { link = 'Search' },
    -- hover
    HoverNormal = { link = 'SagaNormal' },
    HoverBorder = { link = 'SagaBorder' },
    -- rename
    RenameBorder = { link = 'SagaBorder' },
    RenameNormal = { fg = p.white, p.background2 },
    RenameMatch = { link = 'Search' },
    -- diagnostic
    DiagnosticBorder = { link = 'SagaBorder' },
    DiagnosticSource = { fg = p.blueGray2 },
    DiagnosticNormal = { link = 'SagaNormal' },
    DiagnosticErrorBorder = { link = 'DiagnosticError' },
    DiagnosticWarnBorder = { link = 'DiagnosticWarn' },
    DiagnosticHintBorder = { link = 'DiagnosticHint' },
    DiagnosticInfoBorder = { link = 'DiagnosticInfo' },
    DiagnosticPos = { fg = p.blueGray2 },
    DiagnosticWord = { fg = p.white },
    -- Call Hierachry
    CallHierarchyNormal = { link = 'SagaNormal' },
    CallHierarchyBorder = { link = 'SagaBorder' },
    CallHierarchyIcon = { fg = p.pink2 },
    CallHierarchyTitle = { fg = p.pink2 },
    -- lightbulb
    LspSagaLightBulb = { link = 'DiagnosticSignHint' },
    -- shadow
    SagaShadow = { bg = p.background3 },
    -- Outline
    OutlineIndent = { fg = p.blue2 },
    OutlinePreviewBorder = { link = 'SagaNormal' },
    OutlinePreviewNormal = { link = 'SagaBorder' },
    -- Float term
    TerminalBorder = { link = 'SagaBorder' },
    TerminalNormal = { link = 'SagaNormal' },
  }

  vim.g.terminal_color_0 = p.color800
  vim.g.terminal_color_8 = p.color300
  vim.g.terminal_color_1 = p.primary   -- red
  vim.g.terminal_color_9 = p.color300  -- bright red
  vim.g.terminal_color_2 = p.color400  -- green
  vim.g.terminal_color_10 = p.color500 -- bright green
  vim.g.terminal_color_3 = p.warning   -- yellow
  vim.g.terminal_color_11 = p.color300 -- bright yellow
  vim.g.terminal_color_4 = p.color400  -- blue
  vim.g.terminal_color_12 = p.primary  -- bright blue
  vim.g.terminal_color_5 = p.primary   -- magenta
  vim.g.terminal_color_13 = '#D00000'  -- bright magenta
  vim.g.terminal_color_6 = p.color200  -- cyan
  vim.g.terminal_color_14 = '#D00000'  -- bright cyan
  vim.g.terminal_color_7 = p.color100  -- white
  vim.g.terminal_color_15 = p.color100 -- bright white

  return theme
end

return M
