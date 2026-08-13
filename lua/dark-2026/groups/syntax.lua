local style = require('dark-2026.util').style

local M = {}

---@param c table<string, string>
---@param o Dark2026Config
---@return table<string, table>
function M.get(c, o)
  local s = o.styles

  return {
    Comment = style({ fg = c.comment }, s.comments),
    SpecialComment = style({ fg = c.comment }, s.comments),

    Constant = style({ fg = c.constant }, s.constants),
    String = style({ fg = c.string }, s.strings),
    Character = style({ fg = c.string }, s.strings),
    Number = style({ fg = c.number }, s.numbers),
    Float = style({ fg = c.number }, s.numbers),
    Boolean = style({ fg = c.constant }, s.booleans),

    Identifier = style({ fg = c.variable }, s.variables),
    Function = style({ fg = c.func }, s.functions),

    Statement = style({ fg = c.keyword }, s.keywords),
    Conditional = style({ fg = c.preproc }, s.conditionals),
    Repeat = style({ fg = c.preproc }, s.conditionals),
    Label = style({ fg = c.keyword }, s.keywords),
    Operator = style({ fg = c.operator }, s.operators),
    Keyword = style({ fg = c.keyword }, s.keywords),
    Exception = style({ fg = c.preproc }, s.conditionals),

    PreProc = style({ fg = c.preproc }, s.keywords),
    Include = style({ fg = c.preproc }, s.keywords),
    Define = style({ fg = c.preproc }, s.keywords),
    Macro = style({ fg = c.preproc }, s.macros),
    PreCondit = style({ fg = c.preproc }, s.keywords),

    Type = style({ fg = c.type }, s.types),
    StorageClass = style({ fg = c.keyword }, s.keywords),
    Structure = style({ fg = c.type }, s.types),
    Typedef = style({ fg = c.type }, s.types),

    Special = { fg = c.annotation },
    SpecialChar = { fg = c.regex },
    Tag = style({ fg = c.tag }, s.tags),
    Delimiter = { fg = c.fg },
    Debug = { fg = c.debug },

    Error = { fg = c.err },
    Todo = { fg = c.warn, bold = true },
  }
end

return M
