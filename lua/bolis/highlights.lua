-- Highlight definitions for the Bolis color scheme.
--
-- A spec is either a table (nvim_set_hl definition) or a string (link).
-- Colors are referenced by palette role:
--   bg / bg2   backgrounds (bg2 = elevated panels, cursor line)
--   ui         borders, separators, selections
--   ui2        secondary UI foreground (borders, comments-adjacent gray)
--   ui3        muted blue accent (focused/selected UI)
--   tx/tx2/tx3 primary / secondary / tertiary text
--   red orange yellow green cyan blue purple magenta  accents
--
-- Semantic conventions:
--   keywords -> magenta, preprocessor/import -> purple, functions -> blue,
--   types -> yellow, constants/numbers -> orange, strings -> green,
--   escapes/interpolation -> orange, builtin variables/symbols -> cyan,
--   red is reserved for errors and deletions.
local M = {}

---@param c table palette for one variant
---@param blend fun(fg: string, bg: string, alpha: number): string
---@return table<string, table|string>
function M.get(c, blend)
  local groups = {}

  local function h(defs)
    for name, spec in pairs(defs) do
      if groups[name] ~= nil then
        error("bolis: duplicate highlight definition: " .. name)
      end
      groups[name] = spec
    end
  end

  ----------------------------------------------------------------------------
  -- Core UI
  ----------------------------------------------------------------------------
  h {
    Normal = { fg = c.tx, bg = c.bg },
    NormalNC = { link = "Normal" },
    NormalFloat = { fg = c.tx, bg = c.bg2 },
    FloatBorder = { fg = c.ui2, bg = c.bg2 },
    FloatTitle = { fg = c.blue, bg = c.bg2, bold = true },
    FloatFooter = { fg = c.tx3, bg = c.bg2 },
    FloatShadow = { bg = c.ui },
    MsgArea = { fg = c.tx2 },
    MsgSeparator = { link = "WinSeparator" },
    ModeMsg = { fg = c.tx2 },
    MoreMsg = { fg = c.cyan },
    Question = { fg = c.cyan },
    WarningMsg = { fg = c.orange },
    ErrorMsg = { fg = c.red, bold = true },
    Conceal = { fg = c.tx3 },
    Directory = { fg = c.blue, bold = true },
    Title = { fg = c.blue, bold = true },
    Bold = { bold = true },
    Italic = { italic = true },
    Underlined = { fg = c.blue, underline = true },
    Ignore = { fg = c.tx3 },
    Error = { fg = c.red },
    Todo = { fg = c.yellow, bold = true },
    SnippetTabstop = { fg = c.tx3 },

    Cursor = { fg = c.bg, bg = c.tx },
    CursorIM = { link = "Cursor" },
    TermCursor = { fg = c.bg, bg = c.tx },
    TermCursorNC = { fg = c.bg, bg = c.ui2 },
    CursorLine = { bg = c.bg2 },
    CursorColumn = { bg = c.bg2 },
    CursorLineNr = { fg = c.tx2, bold = true },
    LineNr = { fg = c.tx3 },
    LineNrAbove = { fg = blend(c.tx3, c.bg, 0.4) },
    LineNrBelow = { fg = blend(c.tx3, c.bg, 0.4) },
    SignColumn = { fg = c.tx3, bg = c.bg },
    CursorLineSign = { fg = c.tx3, bg = c.bg2 },
    FoldColumn = { fg = c.tx3, bg = c.bg },
    CursorLineFold = { fg = c.tx3, bg = c.bg2 },
    Folded = { fg = c.tx3, bg = c.bg2 },
    ColorColumn = { bg = c.bg2 },
    NonText = { fg = c.tx3 },
    EndOfBuffer = { fg = c.tx3 },
    SpecialKey = { fg = c.ui2 },
    Whitespace = { fg = c.tx3 },
    WinSeparator = { fg = c.ui },
    VertSplit = { link = "WinSeparator" },
    WinBar = { fg = c.tx2, bold = true },
    WinBarNC = { fg = c.tx3 },

    Pmenu = { fg = c.tx, bg = c.bg2 },
    PmenuSel = { fg = c.tx, bg = c.ui3 },
    PmenuMatch = { fg = c.blue, bold = true },
    PmenuMatchSel = { fg = c.tx, bold = true },
    PmenuKind = { fg = c.tx3 },
    PmenuKindSel = { fg = c.tx2 },
    PmenuExtra = { fg = c.tx3 },
    PmenuExtraSel = { fg = c.tx2 },
    PmenuSbar = { bg = c.ui },
    PmenuThumb = { bg = c.ui2 },
    WildMenu = { fg = c.tx, bg = c.ui3 },

    Visual = { fg = c.tx, bg = c.ui },
    VisualNOS = { link = "Visual" },
    MatchParen = { fg = c.tx, bg = c.ui3, bold = true },
    Search = { fg = c.tx, bg = c.ui3 },
    IncSearch = { fg = c.bg, bg = c.blue, bold = true },
    CurSearch = { link = "IncSearch" },
    Substitute = { fg = c.bg, bg = c.red },
    QuickFixLine = { fg = c.tx, bg = c.ui },
    qfLineNr = { fg = c.blue },
    qfFileName = { fg = c.cyan },
    qfSeparator = { fg = c.tx3 },
    qfErrorLine = { fg = c.red },

    StatusLine = { fg = c.tx, bg = c.ui },
    StatusLineNC = { fg = c.tx3, bg = c.bg2 },
    StatusLineTerm = { link = "StatusLine" },
    StatusLineTermNC = { link = "StatusLineNC" },
    TabLine = { fg = c.tx3, bg = c.bg2 },
    TabLineSel = { fg = c.tx, bg = c.ui },
    TabLineFill = { fg = c.tx3, bg = c.bg },

    SpellBad = { undercurl = true, sp = c.red },
    SpellCap = { undercurl = true, sp = c.blue },
    SpellRare = { undercurl = true, sp = c.purple },
    SpellLocal = { undercurl = true, sp = c.cyan },
  }

  ----------------------------------------------------------------------------
  -- Legacy syntax (non-treesitter)
  ----------------------------------------------------------------------------
  h {
    Comment = { fg = c.tx3, italic = true },
    Constant = { fg = c.orange },
    String = { fg = c.green },
    Character = { fg = c.green },
    Number = { fg = c.orange },
    Boolean = { fg = c.orange },
    Float = { fg = c.orange },
    Identifier = { fg = c.tx },
    Function = { fg = c.blue },
    Statement = { fg = c.magenta },
    Conditional = { fg = c.magenta },
    Repeat = { fg = c.magenta },
    Label = { fg = c.magenta },
    Operator = { fg = c.tx2 },
    Keyword = { fg = c.magenta },
    Exception = { fg = c.magenta },
    PreProc = { fg = c.purple },
    Include = { fg = c.purple },
    Define = { fg = c.purple },
    Macro = { fg = c.purple },
    PreCondit = { fg = c.purple },
    Type = { fg = c.yellow },
    StorageClass = { fg = c.magenta },
    Structure = { fg = c.yellow },
    Typedef = { fg = c.yellow },
    Special = { fg = c.orange },
    SpecialChar = { fg = c.orange },
    Tag = { fg = c.cyan },
    Delimiter = { fg = c.tx2 },
    SpecialComment = { fg = c.tx2, bold = true },
    Debug = { fg = c.red },
    vimCommand = { fg = c.magenta },
    vimOption = { fg = c.tx2 },
  }

  ----------------------------------------------------------------------------
  -- Treesitter (current capture names, plus legacy aliases)
  ----------------------------------------------------------------------------
  h {
    ["@comment"] = { link = "Comment" },
    ["@comment.documentation"] = { link = "Comment" },
    ["@comment.error"] = { fg = c.red, bold = true },
    ["@comment.warning"] = { fg = c.orange, bold = true },
    ["@comment.note"] = { fg = c.cyan, bold = true },
    ["@comment.todo"] = { link = "Todo" },

    ["@constant"] = { link = "Constant" },
    ["@constant.builtin"] = { fg = c.orange, italic = true },
    ["@constant.macro"] = { fg = c.purple },

    ["@module"] = { fg = c.tx2 },
    ["@module.builtin"] = { fg = c.tx2 },
    ["@namespace"] = { link = "@module" }, -- legacy

    ["@string"] = { link = "String" },
    ["@string.escape"] = { fg = c.orange },
    ["@string.regex"] = { fg = c.cyan },
    ["@string.regexp"] = { link = "@string.regex" }, -- legacy
    ["@string.special"] = { fg = c.cyan },
    ["@string.special.path"] = { fg = c.tx2 },
    ["@string.special.symbol"] = { fg = c.cyan },
    ["@string.special.url"] = { fg = c.blue, underline = true },
    ["@character"] = { link = "Character" },
    ["@character.special"] = { fg = c.orange },
    ["@number"] = { link = "Number" },
    ["@number.float"] = { link = "Float" },
    ["@boolean"] = { link = "Boolean" },

    ["@type"] = { link = "Type" },
    ["@type.builtin"] = { fg = c.yellow },
    ["@type.definition"] = { link = "@type" },
    ["@type.qualifier"] = { fg = c.magenta }, -- legacy
    ["@storageclass"] = { fg = c.magenta }, -- legacy

    ["@attribute"] = { fg = c.cyan },
    ["@attribute.builtin"] = { fg = c.cyan },
    ["@property"] = { fg = c.tx },
    ["@field"] = { link = "@property" }, -- legacy
    ["@variable.member"] = { fg = c.tx },
    ["@label"] = { fg = c.cyan },
    ["@symbol"] = { fg = c.cyan }, -- legacy

    ["@variable"] = { fg = c.tx },
    ["@variable.builtin"] = { fg = c.cyan, italic = true },
    ["@variable.parameter"] = { fg = c.tx },
    ["@variable.parameter.builtin"] = { fg = c.tx2 },
    ["@parameter"] = { link = "@variable.parameter" }, -- legacy
    ["@parameter.reference"] = { link = "@variable.parameter" }, -- legacy

    ["@function"] = { link = "Function" },
    ["@function.call"] = { link = "@function" },
    ["@function.builtin"] = { fg = c.blue },
    ["@function.macro"] = { fg = c.purple },
    ["@function.method"] = { fg = c.blue },
    ["@function.method.call"] = { link = "@function.method" },
    ["@method"] = { link = "@function.method" }, -- legacy
    ["@constructor"] = { fg = c.yellow },
    ["@macro"] = { fg = c.purple }, -- legacy

    ["@keyword"] = { link = "Keyword" },
    ["@keyword.conditional"] = { fg = c.magenta },
    ["@keyword.conditional.ternary"] = { fg = c.magenta },
    ["@keyword.coroutine"] = { fg = c.magenta },
    ["@keyword.exception"] = { fg = c.magenta },
    ["@keyword.function"] = { fg = c.magenta },
    ["@keyword.import"] = { fg = c.purple },
    ["@keyword.modifier"] = { fg = c.magenta },
    ["@keyword.operator"] = { fg = c.magenta },
    ["@keyword.repeat"] = { fg = c.magenta },
    ["@keyword.return"] = { fg = c.magenta },
    ["@keyword.type"] = { fg = c.magenta },
    ["@keyword.debug"] = { fg = c.red },
    ["@keyword.directive"] = { fg = c.purple },
    ["@keyword.directive.define"] = { fg = c.purple },
    ["@conditional"] = { link = "@keyword.conditional" }, -- legacy
    ["@repeat"] = { link = "@keyword.repeat" }, -- legacy
    ["@exception"] = { link = "@keyword.exception" }, -- legacy
    ["@include"] = { link = "@keyword.import" }, -- legacy
    ["@define"] = { link = "@keyword.directive.define" }, -- legacy
    ["@preproc"] = { link = "@keyword.directive" }, -- legacy

    ["@operator"] = { fg = c.tx2 },
    ["@punctuation"] = { fg = c.tx2 },
    ["@punctuation.bracket"] = { fg = c.tx2 },
    ["@punctuation.delimiter"] = { fg = c.tx2 },
    ["@punctuation.special"] = { fg = c.orange },

    ["@tag"] = { fg = c.magenta },
    ["@tag.builtin"] = { fg = c.magenta },
    ["@tag.attribute"] = { fg = c.cyan },
    ["@tag.delimiter"] = { fg = c.tx2 },

    ["@injection.language"] = { fg = c.purple },

    ["@diff.plus"] = { fg = c.green },
    ["@diff.minus"] = { fg = c.red },
    ["@diff.delta"] = { fg = c.yellow },
  }

  -- Treesitter markup (markdown, etc.)
  h {
    ["@markup.heading"] = { fg = c.blue, bold = true },
    ["@markup.heading.1"] = { link = "@markup.heading" },
    ["@markup.heading.2"] = { link = "@markup.heading" },
    ["@markup.heading.3"] = { link = "@markup.heading" },
    ["@markup.heading.4"] = { link = "@markup.heading" },
    ["@markup.heading.5"] = { link = "@markup.heading" },
    ["@markup.heading.6"] = { link = "@markup.heading" },
    ["@markup.heading.marker"] = { fg = c.tx3 },
    ["@markup.raw"] = { fg = c.green },
    ["@markup.raw.block"] = { link = "@markup.raw" },
    ["@markup.italic"] = { italic = true },
    ["@markup.strong"] = { bold = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.list"] = { fg = c.magenta },
    ["@markup.list.checked"] = { fg = c.green },
    ["@markup.list.unchecked"] = { fg = c.orange },
    ["@markup.link"] = { fg = c.cyan },
    ["@markup.link.label"] = { link = "@markup.link" },
    ["@markup.link.label.symbol"] = { link = "@markup.link" },
    ["@markup.link.url"] = { fg = c.blue, underline = true },
    ["@markup.quote"] = { fg = c.tx3, italic = true },
    ["@markup.math"] = { fg = c.orange },
    ["@markup.environment"] = { fg = c.purple },
    ["@markup.environment.name"] = { fg = c.blue },
    -- legacy names (pre-0.10 queries)
    ["@text.title"] = { link = "@markup.heading" },
    ["@text.literal"] = { link = "@markup.raw" },
    ["@text.uri"] = { link = "@markup.link.url" },
    ["@text.quote"] = { link = "@markup.quote" },
    ["@text.emphasis"] = { italic = true },
    ["@text.strong"] = { bold = true },
    ["@text.strike"] = { strikethrough = true },
    ["@text.underline"] = { underline = true },
    ["@text.math"] = { fg = c.orange },
    ["@text.reference"] = { fg = c.cyan },
    ["@text.note"] = { fg = c.cyan, bold = true },
    ["@text.warning"] = { fg = c.orange, bold = true },
    ["@text.danger"] = { fg = c.red, bold = true },
    ["@text.todo"] = { link = "Todo" },
  }

  ----------------------------------------------------------------------------
  -- LSP
  ----------------------------------------------------------------------------
  h {
    ["@lsp.type.class"] = { link = "Type" },
    ["@lsp.type.decorator"] = { link = "@attribute" },
    ["@lsp.type.enum"] = { link = "Type" },
    ["@lsp.type.enumMember"] = { link = "Constant" },
    ["@lsp.type.event"] = { link = "Constant" },
    ["@lsp.type.function"] = { link = "Function" },
    ["@lsp.type.interface"] = { link = "Type" },
    ["@lsp.type.keyword"] = { link = "Keyword" },
    ["@lsp.type.macro"] = { link = "Macro" },
    ["@lsp.type.method"] = { link = "@function.method" },
    ["@lsp.type.namespace"] = { link = "@module" },
    ["@lsp.type.number"] = { link = "Number" },
    ["@lsp.type.operator"] = { link = "Operator" },
    ["@lsp.type.parameter"] = { link = "@variable.parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.regexp"] = { fg = c.cyan },
    ["@lsp.type.string"] = { link = "String" },
    ["@lsp.type.struct"] = { link = "Type" },
    ["@lsp.type.type"] = { link = "Type" },
    ["@lsp.type.typeParameter"] = { fg = c.cyan },
    ["@lsp.type.variable"] = { link = "@variable" },
    ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },

    LspReferenceText = { fg = c.tx, bg = c.ui },
    LspReferenceRead = { fg = c.tx, bg = c.ui },
    LspReferenceWrite = { fg = c.tx, bg = c.ui, bold = true },
    LspInlayHint = { fg = c.tx3, italic = true },
    LspCodeLens = { fg = c.tx3 },
    LspCodeLensSeparator = { fg = c.tx3 },
    LspSignatureActiveParameter = { fg = c.tx, bg = c.ui, bold = true },

    DiagnosticError = { fg = c.red },
    DiagnosticWarn = { fg = c.orange },
    DiagnosticInfo = { fg = c.blue },
    DiagnosticHint = { fg = c.cyan },
    DiagnosticOk = { fg = c.green },
    DiagnosticVirtualTextError = { fg = c.red, bg = blend(c.red, c.bg, 0.12) },
    DiagnosticVirtualTextWarn = { fg = c.orange, bg = blend(c.orange, c.bg, 0.12) },
    DiagnosticVirtualTextInfo = { fg = c.blue, bg = blend(c.blue, c.bg, 0.12) },
    DiagnosticVirtualTextHint = { fg = c.cyan, bg = blend(c.cyan, c.bg, 0.12) },
    DiagnosticVirtualTextOk = { fg = c.green, bg = blend(c.green, c.bg, 0.12) },
    DiagnosticUnderlineError = { undercurl = true, sp = c.red },
    DiagnosticUnderlineWarn = { undercurl = true, sp = c.orange },
    DiagnosticUnderlineInfo = { undercurl = true, sp = c.blue },
    DiagnosticUnderlineHint = { undercurl = true, sp = c.cyan },
    DiagnosticUnderlineOk = { undercurl = true, sp = c.green },
    DiagnosticSignError = { fg = c.red },
    DiagnosticSignWarn = { fg = c.orange },
    DiagnosticSignInfo = { fg = c.blue },
    DiagnosticSignHint = { fg = c.cyan },
    DiagnosticSignOk = { fg = c.green },
    DiagnosticFloatingError = { fg = c.red },
    DiagnosticFloatingWarn = { fg = c.orange },
    DiagnosticFloatingInfo = { fg = c.blue },
    DiagnosticFloatingHint = { fg = c.cyan },
    DiagnosticFloatingOk = { fg = c.green },
    DiagnosticDeprecated = { fg = c.tx3, strikethrough = true },
    DiagnosticUnnecessary = { fg = c.tx3 },
  }

  ----------------------------------------------------------------------------
  -- Diffs / git
  ----------------------------------------------------------------------------
  h {
    DiffAdd = { bg = blend(c.green, c.bg, 0.15) },
    DiffChange = { bg = blend(c.yellow, c.bg, 0.12) },
    DiffDelete = { fg = c.red, bg = blend(c.red, c.bg, 0.12) },
    DiffText = { bg = blend(c.orange, c.bg, 0.3) },
    Added = { fg = c.green },
    Changed = { fg = c.yellow },
    Removed = { fg = c.red },
    diffAdded = { link = "Added" },
    diffChanged = { link = "Changed" },
    diffRemoved = { link = "Removed" },
    diffOldFile = { fg = c.orange },
    diffNewFile = { fg = c.green },
    diffFile = { fg = c.blue, bold = true },
    diffIndexLine = { fg = c.purple },
    diffLine = { fg = c.tx3 },
    diffSubname = { fg = c.tx3 },

    GitSignsAdd = { fg = c.green },
    GitSignsChange = { fg = c.yellow },
    GitSignsDelete = { fg = c.red },
    GitSignsTopDelete = { fg = c.red },
    GitSignsUntracked = { fg = c.cyan },
    GitSignsAddNr = { fg = c.green },
    GitSignsChangeNr = { fg = c.yellow },
    GitSignsDeleteNr = { fg = c.red },
    GitSignsTopDeleteNr = { fg = c.red },
    GitSignsUntrackedNr = { fg = c.cyan },
    GitSignsAddLn = { link = "DiffAdd" },
    GitSignsChangeLn = { link = "DiffChange" },
    GitSignsDeleteLn = { link = "DiffDelete" },
    GitSignsTopDeleteLn = { link = "DiffDelete" },
    GitSignsUntrackedLn = { bg = blend(c.cyan, c.bg, 0.12) },
    GitSignsCurrentLineBlame = { fg = c.tx3 },
    GitGutterAdd = { fg = c.green },
    GitGutterChange = { fg = c.yellow },
    GitGutterDelete = { fg = c.red },
    GitGutterChangeDelete = { fg = c.orange },
  }

  ----------------------------------------------------------------------------
  -- Help, man, health
  ----------------------------------------------------------------------------
  h {
    helpCommand = { fg = c.cyan },
    helpExample = { fg = c.green },
    helpHeader = { fg = c.tx2, bold = true },
    helpHyperTextEntry = { fg = c.cyan },
    helpHyperTextJump = { fg = c.blue },
    helpOption = { fg = c.tx2 },
    helpSectionDelim = { fg = c.tx3 },
    helpURL = { fg = c.blue, underline = true },
    helpTodo = { link = "Todo" },
    helpError = { fg = c.red },
    helpWarning = { fg = c.orange },
    helpSuccess = { fg = c.green },
    healthError = { fg = c.red },
    healthWarning = { fg = c.orange },
    healthSuccess = { fg = c.green },
    manTitle = { fg = c.tx, bold = true },
    manSectionHeading = { fg = c.blue, bold = true },
    manBold = { fg = c.tx, bold = true },
    manUnderline = { fg = c.blue, underline = true },
  }

  ----------------------------------------------------------------------------
  -- treesitter-context
  ----------------------------------------------------------------------------
  h {
    TreesitterContext = { fg = c.tx2, bg = c.ui },
    TreesitterContextLineNumber = { fg = c.tx2, bg = c.ui },
    TreesitterContextSeparator = { fg = c.ui },
  }

  ----------------------------------------------------------------------------
  -- which-key
  ----------------------------------------------------------------------------
  h {
    WhichKey = { fg = c.blue },
    WhichKeyGroup = { fg = c.cyan },
    WhichKeyDesc = { fg = c.tx },
    WhichKeySeparator = { fg = c.tx3 },
    WhichKeyValue = { fg = c.tx3 },
    WhichKeyFloat = { fg = c.tx, bg = c.bg2 },
    WhichKeyBorder = { fg = c.ui2, bg = c.bg2 },
    WhichKeyTitle = { fg = c.blue, bg = c.bg2, bold = true },
    WhichKeyIcon = { fg = c.ui2 },
    WhichKeyIconAzure = { fg = c.blue },
    WhichKeyIconBlue = { fg = c.blue },
    WhichKeyIconCyan = { fg = c.cyan },
    WhichKeyIconGreen = { fg = c.green },
    WhichKeyIconGrey = { fg = c.ui2 },
    WhichKeyIconOrange = { fg = c.orange },
    WhichKeyIconPurple = { fg = c.purple },
    WhichKeyIconRed = { fg = c.red },
    WhichKeyIconYellow = { fg = c.yellow },
  }

  ----------------------------------------------------------------------------
  -- telescope.nvim
  ----------------------------------------------------------------------------
  h {
    TelescopeNormal = { fg = c.tx, bg = c.bg2 },
    TelescopeBorder = { fg = c.ui2, bg = c.bg2 },
    TelescopeTitle = { fg = c.tx, bg = c.ui3 },
    TelescopePromptTitle = { link = "TelescopeTitle" },
    TelescopeResultsTitle = { link = "TelescopeTitle" },
    TelescopePreviewTitle = { link = "TelescopeTitle" },
    TelescopeSelection = { fg = c.tx, bg = c.ui },
    TelescopeSelectionCaret = { fg = c.blue },
    TelescopeMultiSelection = { fg = c.tx, bg = c.ui },
    TelescopeMatching = { fg = c.blue, bold = true },
    TelescopePromptPrefix = { fg = c.blue },
    TelescopePrompt = { fg = c.tx, bg = c.bg2 },
    TelescopeCursorLine = { bg = c.bg2 },
    TelescopePreviewLine = { bg = c.ui },
    TelescopePreviewMatch = { fg = c.blue, bold = true },
    TelescopeResultsDiffAdd = { fg = c.green },
    TelescopeResultsDiffChange = { fg = c.yellow },
    TelescopeResultsDiffDelete = { fg = c.red },
    TelescopeResultsDiffUntracked = { fg = c.tx3 },
  }

  ----------------------------------------------------------------------------
  -- blink.cmp / nvim-cmp
  ----------------------------------------------------------------------------
  h {
    CmpItemAbbr = { fg = c.tx },
    CmpItemAbbrDeprecated = { fg = c.tx3, strikethrough = true },
    CmpItemAbbrMatch = { fg = c.blue, bold = true },
    CmpItemAbbrMatchFuzzy = { fg = c.blue, bold = true },
    CmpItemMenu = { fg = c.tx3 },
    CmpItemKind = { fg = c.tx2 },
    CmpItemKindText = { fg = c.tx },
    CmpItemKindMethod = { fg = c.blue },
    CmpItemKindFunction = { fg = c.blue },
    CmpItemKindConstructor = { fg = c.yellow },
    CmpItemKindField = { fg = c.cyan },
    CmpItemKindVariable = { fg = c.tx },
    CmpItemKindClass = { fg = c.yellow },
    CmpItemKindInterface = { fg = c.yellow },
    CmpItemKindModule = { fg = c.tx2 },
    CmpItemKindProperty = { fg = c.cyan },
    CmpItemKindUnit = { fg = c.orange },
    CmpItemKindValue = { fg = c.orange },
    CmpItemKindEnum = { fg = c.yellow },
    CmpItemKindKeyword = { fg = c.magenta },
    CmpItemKindSnippet = { fg = c.purple },
    CmpItemKindColor = { fg = c.red },
    CmpItemKindFile = { fg = c.blue },
    CmpItemKindReference = { fg = c.cyan },
    CmpItemKindFolder = { fg = c.blue },
    CmpItemKindEnumMember = { fg = c.orange },
    CmpItemKindConstant = { fg = c.orange },
    CmpItemKindStruct = { fg = c.yellow },
    CmpItemKindEvent = { fg = c.orange },
    CmpItemKindOperator = { fg = c.tx2 },
    CmpItemKindTypeParameter = { fg = c.cyan },
    CmpGhostText = { fg = c.ui2 },

    BlinkCmpMenu = { fg = c.tx, bg = c.bg2 },
    BlinkCmpMenuBorder = { fg = c.ui2, bg = c.bg2 },
    BlinkCmpMenuSelection = { fg = c.tx, bg = c.ui3 },
    BlinkCmpLabel = { fg = c.tx },
    BlinkCmpLabelMatch = { fg = c.blue, bold = true },
    BlinkCmpLabelDeprecated = { fg = c.tx3, strikethrough = true },
    BlinkCmpLabelDetail = { fg = c.tx3 },
    BlinkCmpLabelDescription = { fg = c.tx3 },
    BlinkCmpGhostText = { fg = c.ui2 },
    BlinkCmpDoc = { fg = c.tx, bg = c.bg2 },
    BlinkCmpDocBorder = { fg = c.ui2, bg = c.bg2 },
    BlinkCmpSignature = { fg = c.tx, bg = c.bg2 },
    BlinkCmpSignatureBorder = { fg = c.ui2, bg = c.bg2 },
    BlinkCmpSignatureActiveParameter = { fg = c.tx, bg = c.ui, bold = true },
    BlinkCmpKind = { fg = c.tx2 },
    BlinkCmpKindText = { fg = c.tx },
    BlinkCmpKindMethod = { fg = c.blue },
    BlinkCmpKindFunction = { fg = c.blue },
    BlinkCmpKindConstructor = { fg = c.yellow },
    BlinkCmpKindField = { fg = c.cyan },
    BlinkCmpKindVariable = { fg = c.tx },
    BlinkCmpKindClass = { fg = c.yellow },
    BlinkCmpKindInterface = { fg = c.yellow },
    BlinkCmpKindModule = { fg = c.tx2 },
    BlinkCmpKindProperty = { fg = c.cyan },
    BlinkCmpKindUnit = { fg = c.orange },
    BlinkCmpKindValue = { fg = c.orange },
    BlinkCmpKindEnum = { fg = c.yellow },
    BlinkCmpKindKeyword = { fg = c.magenta },
    BlinkCmpKindSnippet = { fg = c.purple },
    BlinkCmpKindColor = { fg = c.red },
    BlinkCmpKindFile = { fg = c.blue },
    BlinkCmpKindReference = { fg = c.cyan },
    BlinkCmpKindFolder = { fg = c.blue },
    BlinkCmpKindEnumMember = { fg = c.orange },
    BlinkCmpKindConstant = { fg = c.orange },
    BlinkCmpKindStruct = { fg = c.yellow },
    BlinkCmpKindEvent = { fg = c.orange },
    BlinkCmpKindOperator = { fg = c.tx2 },
    BlinkCmpKindTypeParameter = { fg = c.cyan },
  }

  ----------------------------------------------------------------------------
  -- lazy.nvim
  ----------------------------------------------------------------------------
  h {
    LazyNormal = { fg = c.tx, bg = c.bg2 },
    LazyButton = { fg = c.tx2, bg = c.bg },
    LazyButtonActive = { fg = c.tx, bg = c.ui, bold = true },
    LazyH1 = { fg = c.tx, bold = true },
    LazyH2 = { fg = c.blue, bold = true },
    LazySpecial = { fg = c.magenta },
    LazyProgressDone = { fg = c.blue },
    LazyProgressTodo = { fg = c.ui },
    LazyDir = { fg = c.blue },
    LazyUrl = { fg = c.tx3 },
    LazyCommit = { fg = c.orange },
    LazyCommitIssue = { fg = c.red },
    LazyCommitScope = { fg = c.tx3 },
    LazyCommitType = { fg = c.magenta },
    LazyReasonCmd = { fg = c.magenta },
    LazyReasonEvent = { fg = c.orange },
    LazyReasonImport = { fg = c.green },
    LazyReasonKeys = { fg = c.cyan },
    LazyReasonModule = { fg = c.tx2 },
    LazyReasonPlugin = { fg = c.tx },
    LazyReasonRequire = { fg = c.green },
    LazyReasonRuntime = { fg = c.tx3 },
    LazyReasonSource = { fg = c.purple },
    LazyReasonStart = { fg = c.blue },
    LazyDiffAdd = { fg = c.green },
    LazyDiffChange = { fg = c.yellow },
    LazyDiffDelete = { fg = c.red },
  }

  ----------------------------------------------------------------------------
  -- mason / nvim-notify / noice
  ----------------------------------------------------------------------------
  h {
    MasonNormal = { fg = c.tx, bg = c.bg2 },
    MasonHighlight = { fg = c.blue },
    MasonHighlightBold = { fg = c.blue, bold = true },
    MasonHighlightSecondary = { fg = c.cyan },
    MasonHeader = { fg = c.tx, bg = c.ui3, bold = true },
    MasonHeaderSecondary = { fg = c.blue, bold = true },
    MasonError = { fg = c.red },
    MasonWarning = { fg = c.orange },
    MasonLink = { fg = c.blue, underline = true },

    NotifyERRORBorder = { fg = c.red },
    NotifyERRORIcon = { fg = c.red },
    NotifyERRORTitle = { fg = c.red, bold = true },
    NotifyWARNBorder = { fg = c.orange },
    NotifyWARNIcon = { fg = c.orange },
    NotifyWARNTitle = { fg = c.orange, bold = true },
    NotifyINFOBorder = { fg = c.blue },
    NotifyINFOIcon = { fg = c.blue },
    NotifyINFOTitle = { fg = c.blue, bold = true },
    NotifyDEBUGBorder = { fg = c.tx3 },
    NotifyDEBUGIcon = { fg = c.tx3 },
    NotifyDEBUGTitle = { fg = c.tx3, bold = true },
    NotifyTRACEBorder = { fg = c.purple },
    NotifyTRACEIcon = { fg = c.purple },
    NotifyTRACETitle = { fg = c.purple, bold = true },

    NoiceCmdline = { fg = c.tx },
    NoiceCmdlineIcon = { fg = c.blue },
    NoiceCmdlineIconCmdline = { fg = c.blue },
    NoiceCmdlineIconLua = { fg = c.blue },
    NoiceCmdlineIconSearch = { fg = c.blue },
    NoiceCmdlineIconFilter = { fg = c.blue },
    NoiceCmdlineIconHelp = { fg = c.blue },
    NoiceCmdlinePopup = { fg = c.tx, bg = c.bg2 },
    NoiceCmdlinePopupBorder = { fg = c.ui2, bg = c.bg2 },
    NoiceCmdlinePopupTitle = { fg = c.blue, bold = true },
    NoiceConfirmBorder = { fg = c.ui2, bg = c.bg2 },
    NoiceMini = { bg = c.bg2 },
    NoiceLspProgressClient = { fg = c.blue, bold = true },
    NoiceLspProgressTitle = { fg = c.tx2 },
    NoiceLspProgressSpinner = { fg = c.tx3 },
    NoiceFormatProgressDone = { fg = c.bg, bg = c.blue },
    NoiceFormatProgressTodo = { fg = c.ui, bg = c.bg2 },
    NoiceFormatDate = { fg = c.tx3 },
  }

  ----------------------------------------------------------------------------
  -- indent-blankline / mini.indentscope
  ----------------------------------------------------------------------------
  h {
    IblIndent = { fg = c.ui },
    IblWhitespace = { fg = c.ui },
    IblScope = { fg = c.ui3 },
    IndentBlanklineChar = { fg = c.ui },
    IndentBlanklineContextChar = { fg = c.ui3 },
    IndentBlanklineSpaceChar = { fg = c.ui },
    IndentBlanklineSpaceCharBlankline = { fg = c.ui },
    IndentBlanklineContextStart = { underline = true, sp = c.ui3 },
    ["@ibl.indent.1"] = { fg = c.ui },
    ["@ibl.indent.2"] = { fg = c.ui },
    ["@ibl.indent.3"] = { fg = c.ui },
    ["@ibl.scope.1"] = { fg = c.ui3 },
    ["@ibl.scope.2"] = { fg = c.ui3 },
    ["@ibl.scope.3"] = { fg = c.ui3 },
    ["@ibl.scope.underline"] = { underline = true, sp = c.ui3 },
    MiniIndentscopeSymbol = { fg = c.ui2 },
    MiniIndentscopeSymbolOff = { fg = c.ui },
  }

  ----------------------------------------------------------------------------
  -- File explorers (neo-tree / nvim-tree)
  ----------------------------------------------------------------------------
  h {
    NeoTreeNormal = { fg = c.tx, bg = c.bg2 },
    NeoTreeNormalNC = { link = "NeoTreeNormal" },
    NeoTreeEndOfBuffer = { fg = c.tx3, bg = c.bg2 },
    NeoTreeWinSeparator = { fg = c.ui },
    NeoTreeVertSplit = { link = "NeoTreeWinSeparator" },
    NeoTreeDirectoryName = { fg = c.blue },
    NeoTreeDirectoryIcon = { fg = c.blue },
    NeoTreeRootName = { fg = c.tx, bold = true },
    NeoTreeFileName = { fg = c.tx },
    NeoTreeFileNameOpened = { fg = c.tx, bold = true },
    NeoTreeSymbolicLinkTarget = { fg = c.cyan },
    NeoTreeGitModified = { fg = c.yellow },
    NeoTreeGitAdded = { fg = c.green },
    NeoTreeGitDeleted = { fg = c.red },
    NeoTreeGitRenamed = { fg = c.purple },
    NeoTreeGitConflict = { fg = c.red, bold = true },
    NeoTreeGitIgnored = { fg = c.tx3 },
    NeoTreeGitUntracked = { fg = c.cyan },
    NeoTreeDimText = { fg = c.tx3 },
    NeoTreeDotfile = { fg = c.tx3 },
    NeoTreeIndentMarker = { fg = c.ui2 },
    NeoTreeExpander = { fg = c.ui2 },
    NeoTreeBufferNumber = { fg = c.tx3 },
    NeoTreeTitleBar = { fg = c.tx, bg = c.ui },
    NeoTreeFloatBorder = { fg = c.ui2, bg = c.bg2 },
    NeoTreeFloatTitle = { fg = c.blue, bold = true },

    NvimTreeNormal = { fg = c.tx, bg = c.bg2 },
    NvimTreeNormalNC = { link = "NvimTreeNormal" },
    NvimTreeEndOfBuffer = { fg = c.tx3, bg = c.bg2 },
    NvimTreeWinSeparator = { fg = c.ui },
    NvimTreeVertSplit = { link = "NvimTreeWinSeparator" },
    NvimTreeRootFolder = { fg = c.tx, bold = true },
    NvimTreeFolderIcon = { fg = c.blue },
    NvimTreeFolderName = { fg = c.blue },
    NvimTreeOpenedFolderName = { fg = c.blue, bold = true },
    NvimTreeEmptyFolderMessage = { fg = c.tx3 },
    NvimTreeFileName = { fg = c.tx },
    NvimTreeOpenedFile = { fg = c.tx, bold = true },
    NvimTreeExecFile = { fg = c.green },
    NvimTreeImageFile = { fg = c.tx2 },
    NvimTreeSpecialFile = { fg = c.tx2 },
    NvimTreeSymlink = { fg = c.cyan },
    NvimTreeGitDirty = { fg = c.yellow },
    NvimTreeGitStaged = { fg = c.green },
    NvimTreeGitMerge = { fg = c.red, bold = true },
    NvimTreeGitRenamed = { fg = c.purple },
    NvimTreeGitNew = { fg = c.cyan },
    NvimTreeGitDeleted = { fg = c.red },
    NvimTreeGitIgnored = { fg = c.tx3 },
    NvimTreeIndentMarker = { fg = c.ui2 },
    NvimTreeWindowPicker = { fg = c.tx, bg = c.ui3, bold = true },
  }

  ----------------------------------------------------------------------------
  -- Start screens
  ----------------------------------------------------------------------------
  h {
    DashboardHeader = { fg = c.blue },
    DashboardIcon = { fg = c.cyan },
    DashboardShortCut = { fg = c.blue },
    DashboardDesc = { fg = c.tx },
    DashboardKey = { fg = c.cyan },
    DashboardFooter = { fg = c.tx3 },
    AlphaHeader = { fg = c.blue },
    AlphaButtons = { fg = c.tx },
    AlphaShortcut = { fg = c.cyan },
    AlphaFooter = { fg = c.tx3 },
  }

  ----------------------------------------------------------------------------
  -- DAP
  ----------------------------------------------------------------------------
  h {
    DapBreakpoint = { fg = c.red },
    DapBreakpointCondition = { fg = c.yellow },
    DapBreakpointRejected = { fg = c.tx3 },
    DapLogPoint = { fg = c.purple },
    DapStopped = { fg = c.yellow },
    DapUIScope = { fg = c.blue },
    DapUIType = { fg = c.yellow },
    DapUIValue = { fg = c.tx },
    DapUIVariable = { fg = c.tx },
    DapUIModifiedValue = { fg = c.orange, bold = true },
    DapUIDecoration = { fg = c.ui2 },
    DapUIThread = { fg = c.green },
    DapUIStoppedThread = { fg = c.cyan },
    DapUISource = { fg = c.tx3 },
    DapUILineNumber = { fg = c.blue },
    DapUIFloatBorder = { fg = c.ui2, bg = c.bg2 },
    DapUIWatchesEmpty = { fg = c.red },
    DapUIWatchesValue = { fg = c.green },
    DapUIWatchesError = { fg = c.red },
    DapUIBreakpointsPath = { fg = c.blue },
    DapUIBreakpointsInfo = { fg = c.tx2 },
    DapUIBreakpointsCurrentLine = { fg = c.blue, bold = true },
  }

  ----------------------------------------------------------------------------
  -- Jump motions
  ----------------------------------------------------------------------------
  h {
    LeapMatch = { fg = c.bg, bg = c.blue },
    LeapLabelPrimary = { fg = c.bg, bg = c.blue, bold = true },
    LeapLabelSecondary = { fg = c.bg, bg = c.cyan, bold = true },
    LeapLabelSelected = { fg = c.bg, bg = c.magenta, bold = true },
    LeapBackdrop = { fg = c.tx3 },
    FlashMatch = { fg = c.tx, bg = c.ui },
    FlashCurrent = { fg = c.tx, bg = c.ui3 },
    FlashLabel = { fg = c.bg, bg = c.magenta, bold = true },
    FlashBackdrop = { fg = c.tx3 },
    FlashPrompt = { fg = c.tx },
  }

  ----------------------------------------------------------------------------
  -- bufferline.nvim
  ----------------------------------------------------------------------------
  h {
    BufferLineFill = { fg = c.tx3, bg = c.bg },
    BufferLineBackground = { fg = c.tx3, bg = c.bg },
    BufferLineBuffer = { fg = c.tx3, bg = c.bg },
    BufferLineBufferInactive = { fg = c.tx3, bg = c.bg },
    BufferLineBufferVisible = { fg = c.tx2, bg = c.bg },
    BufferLineBufferSelected = { fg = c.tx, bg = c.bg, bold = true },
    BufferLineTab = { fg = c.tx3, bg = c.bg },
    BufferLineTabSelected = { fg = c.tx2, bg = c.bg, bold = true },
    BufferLineTabClose = { fg = c.tx3, bg = c.bg },
    BufferLineCloseButton = { fg = c.tx3, bg = c.bg },
    BufferLineCloseButtonVisible = { fg = c.tx2, bg = c.bg },
    BufferLineCloseButtonSelected = { fg = c.tx, bg = c.bg },
    BufferLineModified = { fg = c.orange, bg = c.bg },
    BufferLineModifiedVisible = { fg = c.orange, bg = c.bg },
    BufferLineModifiedSelected = { fg = c.orange, bg = c.bg },
    BufferLineIndicator = { fg = c.ui, bg = c.bg },
    BufferLineIndicatorSelected = { fg = c.green, bg = c.bg },
    BufferLineError = { fg = c.red, bg = c.bg },
    BufferLineWarning = { fg = c.orange, bg = c.bg },
  }

  ----------------------------------------------------------------------------
  -- trouble.nvim
  ----------------------------------------------------------------------------
  h {
    TroubleNormal = { fg = c.tx, bg = c.bg2 },
    TroubleNormalNC = { link = "TroubleNormal" },
    TroubleText = { fg = c.tx },
    TroubleSource = { fg = c.tx3 },
    TroubleCode = { fg = c.tx3 },
    TroubleFileName = { fg = c.blue },
    TroubleDirectory = { fg = c.blue },
    TroubleDirectoryIcon = { fg = c.blue },
    TroubleError = { fg = c.red },
    TroubleWarning = { fg = c.orange },
    TroubleInformation = { fg = c.blue },
    TroubleHint = { fg = c.cyan },
  }

  ----------------------------------------------------------------------------
  -- misc plugins
  ----------------------------------------------------------------------------
  h {
    IlluminatedWordText = { fg = c.tx, bg = c.ui },
    IlluminatedWordRead = { fg = c.tx, bg = c.ui },
    IlluminatedWordWrite = { fg = c.tx, bg = c.ui, bold = true },

    RainbowDelimiterRed = { fg = c.red },
    RainbowDelimiterOrange = { fg = c.orange },
    RainbowDelimiterYellow = { fg = c.yellow },
    RainbowDelimiterGreen = { fg = c.green },
    RainbowDelimiterCyan = { fg = c.cyan },
    RainbowDelimiterBlue = { fg = c.blue },
    RainbowDelimiterViolet = { fg = c.purple },
  }

  ----------------------------------------------------------------------------
  -- mini.nvim
  ----------------------------------------------------------------------------
  h {
    MiniStatuslineModeNormal = { fg = c.tx, bg = c.ui },
    MiniStatuslineModeInsert = { fg = c.bg, bg = c.green },
    MiniStatuslineModeVisual = { fg = c.bg, bg = c.orange },
    MiniStatuslineModeReplace = { fg = c.bg, bg = c.red },
    MiniStatuslineModeCommand = { fg = c.bg, bg = c.yellow },
    MiniStatuslineModeOther = { fg = c.bg, bg = c.cyan },
    MiniStatuslineInactive = { fg = c.tx3, bg = c.bg2 },
    MiniStatuslineFilename = { fg = c.tx2, bg = c.bg2 },
    MiniStatuslineFileinfo = { fg = c.tx3, bg = c.bg2 },
    MiniStatuslineDevinfo = { fg = c.tx3, bg = c.bg2 },
    MiniStatuslineLsp = { fg = c.tx3, bg = c.bg2 },
    MiniStatuslineDiagnostic = { fg = c.tx3, bg = c.bg2 },
    MiniStatuslineDiagnosticError = { fg = c.red, bg = c.bg2 },
    MiniStatuslineDiagnosticWarn = { fg = c.orange, bg = c.bg2 },
    MiniStatuslineDiagnosticInfo = { fg = c.blue, bg = c.bg2 },
    MiniStatuslineDiagnosticHint = { fg = c.cyan, bg = c.bg2 },

    MiniJump = { fg = c.bg, bg = c.blue },
    MiniJump2dSpot = { fg = c.bg, bg = c.magenta, bold = true },

    MiniDiffOverAdd = { bg = blend(c.green, c.bg, 0.15) },
    MiniDiffOverChange = { bg = blend(c.yellow, c.bg, 0.12) },
    MiniDiffOverDelete = { bg = blend(c.red, c.bg, 0.12) },
    MiniDiffSignAdd = { fg = c.green },
    MiniDiffSignChange = { fg = c.yellow },
    MiniDiffSignDelete = { fg = c.red },

    MiniFilesNormal = { fg = c.tx },
    MiniFilesDirectory = { fg = c.blue },
    MiniFilesBorder = { fg = c.ui2 },
    MiniFilesTitle = { fg = c.tx2, bold = true },
    MiniFilesTitleFocused = { fg = c.tx, bold = true },
    MiniFilesCursorLine = { bg = c.ui },

    MiniPickNormal = { fg = c.tx, bg = c.bg2 },
    MiniPickBorder = { fg = c.ui2, bg = c.bg2 },
    MiniPickBorderBusy = { fg = c.blue, bg = c.bg2 },
    MiniPickBorderText = { fg = c.tx2, bg = c.bg2 },
    MiniPickMatchCurrent = { bg = c.ui },
    MiniPickMatchMarked = { fg = c.blue, bold = true },
    MiniPickMatchRanges = { fg = c.blue, bold = true },

    MiniNotifyNormal = { fg = c.tx, bg = c.bg2 },
    MiniNotifyBorder = { fg = c.ui2, bg = c.bg2 },
    MiniNotifyTitle = { fg = c.blue, bold = true },

    MiniIconsAzure = { fg = c.blue },
    MiniIconsBlue = { fg = c.blue },
    MiniIconsCyan = { fg = c.cyan },
    MiniIconsGreen = { fg = c.green },
    MiniIconsGrey = { fg = c.ui2 },
    MiniIconsOrange = { fg = c.orange },
    MiniIconsPurple = { fg = c.purple },
    MiniIconsRed = { fg = c.red },
    MiniIconsYellow = { fg = c.yellow },

    MiniTrailspace = { bg = c.red },
  }

  return groups
end

return M
