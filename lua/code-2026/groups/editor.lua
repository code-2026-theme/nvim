local M = {}

---@param c table<string, string>
---@param o Dark2026Config
---@return table<string, table>
function M.get(c, o)
  return {
    -- Base
    Normal = { fg = c.fg, bg = c.bg_normal },
    NormalNC = { fg = c.fg, bg = o.dim_inactive and c.bg_inactive or c.bg_normal },
    NormalSB = { fg = c.fg, bg = c.bg_panel },
    NormalFloat = { fg = c.fg, bg = c.bg_float },
    FloatBorder = { fg = c.border_alt, bg = c.bg_float },
    FloatTitle = { fg = c.fg_alt, bg = c.bg_float, bold = true },
    FloatFooter = { fg = c.fg_dim, bg = c.bg_float },
    NonText = { fg = c.fg_muted },
    EndOfBuffer = { fg = c.bg },
    Whitespace = { fg = c.fg_muted },
    SpecialKey = { fg = c.fg_muted },
    Conceal = { fg = c.fg_dim },
    Directory = { fg = c.accent_alt },
    Title = { fg = c.keyword, bold = true },
    Underlined = { underline = true },
    Ignore = { fg = c.fg_muted },

    -- Cursor / lines
    Cursor = { fg = c.bg, bg = c.fg },
    lCursor = { fg = c.bg, bg = c.fg },
    CursorIM = { fg = c.bg, bg = c.fg },
    TermCursor = { fg = c.bg, bg = c.fg },
    CursorLine = { bg = c.bg_line },
    CursorColumn = { bg = c.bg_line },
    ColorColumn = { bg = c.bg_line },
    LineNr = { fg = c.fg_muted, bg = c.bg_normal },
    LineNrAbove = { fg = c.fg_muted, bg = c.bg_normal },
    LineNrBelow = { fg = c.fg_muted, bg = c.bg_normal },
    CursorLineNr = { fg = c.fg_alt, bg = c.bg_normal, bold = true },
    CursorLineSign = { bg = c.bg_normal },
    CursorLineFold = { bg = c.bg_normal },
    SignColumn = { fg = c.fg_muted, bg = c.bg_normal },
    SignColumnSB = { fg = c.fg_muted, bg = c.bg_panel },
    FoldColumn = { fg = c.fg_muted, bg = c.bg_normal },
    Folded = { fg = c.fg_dim, bg = c.bg_line },

    -- Selection / search
    Visual = { bg = c.bg_select },
    VisualNOS = { bg = c.bg_select },
    Search = { fg = c.fg, bg = c.bg_match },
    IncSearch = { fg = c.white, bg = c.accent },
    CurSearch = { fg = c.white, bg = c.accent },
    Substitute = { fg = c.white, bg = c.keyword },
    MatchParen = { fg = c.accent_alt, bold = true, underline = true },

    -- Statusline / splits / winbar
    StatusLine = { fg = c.fg_dim, bg = c.bg_panel },
    StatusLineNC = { fg = c.fg_muted, bg = c.bg_panel },
    StatusLineTerm = { fg = c.fg_dim, bg = c.bg_panel },
    StatusLineTermNC = { fg = c.fg_muted, bg = c.bg_panel },
    WinBar = { fg = c.fg_dim, bg = c.bg_normal },
    WinBarNC = { fg = c.fg_muted, bg = c.bg_normal },
    WinSeparator = { fg = c.border, bg = c.bg_normal },
    VertSplit = { fg = c.border, bg = c.bg_normal },

    -- Tabline
    TabLine = { fg = c.fg_dim, bg = c.bg_panel },
    TabLineFill = { bg = c.bg_panel },
    TabLineSel = { fg = c.fg_alt, bg = c.bg_normal, sp = c.accent, underline = true },

    -- Popup menu / completion
    Pmenu = { fg = c.fg, bg = c.bg_float },
    PmenuSel = { fg = c.fg_alt, bg = c.accent_dim },
    PmenuSbar = { bg = c.bg_line },
    PmenuThumb = { bg = c.fg_muted },
    PmenuKind = { fg = c.func, bg = c.bg_float },
    PmenuKindSel = { fg = c.func, bg = c.accent_dim },
    PmenuExtra = { fg = c.fg_dim, bg = c.bg_float },
    PmenuExtraSel = { fg = c.fg_alt, bg = c.accent_dim },
    PmenuMatch = { fg = c.accent_alt, bold = true },
    PmenuMatchSel = { fg = c.accent_alt, bg = c.accent_dim, bold = true },
    WildMenu = { fg = c.fg_alt, bg = c.accent_dim },

    -- Messages / prompts
    ErrorMsg = { fg = c.err },
    WarningMsg = { fg = c.warn },
    ModeMsg = { fg = c.fg_alt, bold = true },
    MoreMsg = { fg = c.accent },
    Question = { fg = c.accent },
    MsgArea = { fg = c.fg, bg = c.bg_normal },
    MsgSeparator = { fg = c.border, bg = c.bg_normal },
    QuickFixLine = { bg = c.bg_line, bold = true },
    qfLineNr = { fg = c.fg_dim },
    qfFileName = { fg = c.accent_alt },

    -- Spell
    SpellBad = { undercurl = true, sp = c.err },
    SpellCap = { undercurl = true, sp = c.warn },
    SpellLocal = { undercurl = true, sp = c.info },
    SpellRare = { undercurl = true, sp = c.hint },

    -- Diff / git
    DiffAdd = { bg = c.diff_add },
    DiffChange = { bg = c.diff_chg },
    DiffDelete = { fg = c.diff_del_fg, bg = c.diff_del },
    DiffText = { bg = c.diff_text, bold = true },
    Added = { fg = c.diff_add_fg },
    Changed = { fg = c.diff_chg_fg },
    Removed = { fg = c.diff_del_fg },
    diffAdded = { fg = c.diff_add_fg },
    diffChanged = { fg = c.diff_chg_fg },
    diffRemoved = { fg = c.diff_del_fg },
    diffFile = { fg = c.accent_alt },
    diffLine = { fg = c.comment },
    diffIndexLine = { fg = c.func },

    -- Health / misc built-ins
    healthError = { fg = c.err },
    healthWarning = { fg = c.warn },
    healthSuccess = { fg = c.ok },
  }
end

return M
