local style = require('code-2026.util').style

local M = {}

---@param c table<string, string>
---@param o Dark2026Config
---@return table<string, table>
function M.get(c, o)
  local s = o.styles

  return {
    ['@comment'] = { link = 'Comment' },
    ['@comment.documentation'] = { link = 'Comment' },
    ['@comment.todo'] = { link = 'Todo' },
    ['@comment.error'] = { fg = c.err, bold = true },
    ['@comment.warning'] = { fg = c.warn, bold = true },
    ['@comment.note'] = { fg = c.info, bold = true },

    ['@string'] = { link = 'String' },
    ['@string.documentation'] = { link = 'String' },
    ['@string.escape'] = style({ fg = c.keyword }, s.strings),
    ['@string.regexp'] = style({ fg = c.regex }, s.strings),
    ['@string.special'] = { fg = c.annotation },
    ['@string.special.path'] = { fg = c.string, underline = true },
    ['@string.special.url'] = { fg = c.accent_alt, underline = true },
    ['@string.special.symbol'] = { fg = c.constant },
    ['@character'] = { link = 'Character' },
    ['@character.special'] = { fg = c.regex },
    ['@number'] = { link = 'Number' },
    ['@number.float'] = { link = 'Float' },
    ['@boolean'] = { link = 'Boolean' },
    ['@float'] = { link = 'Float' },

    ['@constant'] = { link = 'Constant' },
    ['@constant.builtin'] = style({ fg = c.constant }, s.constants),
    ['@constant.macro'] = style({ fg = c.preproc }, s.macros),

    ['@variable'] = style({ fg = c.variable }, s.variables),
    ['@variable.builtin'] = style(style({ fg = c.keyword }, s.variables), s.builtins),
    ['@variable.parameter'] = style({ fg = c.param }, s.parameters),
    ['@variable.parameter.builtin'] = style(style({ fg = c.param }, s.parameters), s.builtins),
    ['@variable.member'] = style({ fg = c.member }, s.properties),

    ['@property'] = style({ fg = c.member }, s.properties),
    ['@field'] = style({ fg = c.member }, s.properties),

    ['@function'] = { link = 'Function' },
    ['@function.builtin'] = style(style({ fg = c.func }, s.functions), s.builtins),
    ['@function.call'] = { link = 'Function' },
    ['@function.macro'] = style({ fg = c.macro }, s.macros),
    ['@function.method'] = style({ fg = c.func }, s.methods),
    ['@function.method.call'] = style({ fg = c.func }, s.methods),
    ['@constructor'] = style({ fg = c.type }, s.types),

    ['@keyword'] = { link = 'Keyword' },
    ['@keyword.function'] = { link = 'Keyword' },
    ['@keyword.operator'] = style({ fg = c.keyword }, s.keywords),
    ['@keyword.modifier'] = { link = 'Keyword' },
    ['@keyword.coroutine'] = { link = 'Keyword' },
    ['@keyword.type'] = { link = 'Keyword' },
    ['@keyword.return'] = style({ fg = c.preproc }, s.conditionals),
    ['@keyword.conditional'] = { link = 'Conditional' },
    ['@keyword.conditional.ternary'] = { link = 'Operator' },
    ['@keyword.repeat'] = { link = 'Repeat' },
    ['@keyword.import'] = { link = 'Include' },
    ['@keyword.export'] = { link = 'Include' },
    ['@keyword.exception'] = { link = 'Exception' },
    ['@keyword.debug'] = { link = 'Debug' },
    ['@keyword.directive'] = { link = 'PreProc' },
    ['@keyword.directive.define'] = { link = 'Define' },

    ['@operator'] = { link = 'Operator' },

    ['@type'] = { link = 'Type' },
    ['@type.builtin'] = style(style({ fg = c.keyword }, s.types), s.builtins),
    ['@type.definition'] = { link = 'Type' },
    ['@type.qualifier'] = { link = 'Keyword' },

    ['@attribute'] = style({ fg = c.annotation }, s.attributes),
    ['@attribute.builtin'] = style(style({ fg = c.annotation }, s.attributes), s.builtins),
    ['@module'] = style({ fg = c.module }, s.namespaces),
    ['@module.builtin'] = style(style({ fg = c.module }, s.namespaces), s.builtins),
    ['@namespace'] = style({ fg = c.module }, s.namespaces),
    ['@label'] = { link = 'Label' },

    ['@punctuation'] = { fg = c.fg },
    ['@punctuation.bracket'] = { fg = c.fg },
    ['@punctuation.delimiter'] = { fg = c.fg },
    ['@punctuation.special'] = { fg = c.keyword },

    ['@tag'] = style({ fg = c.tag }, s.tags),
    ['@tag.builtin'] = style({ fg = c.tag }, s.tags),
    ['@tag.attribute'] = style({ fg = c.attr }, s.attributes),
    ['@tag.delimiter'] = { fg = c.fg_dim },

    -- Markup
    ['@markup'] = { fg = c.fg },
    ['@markup.heading'] = style({ fg = c.keyword }, s.headings),
    ['@markup.heading.1'] = style({ fg = c.keyword }, s.headings),
    ['@markup.heading.2'] = style({ fg = c.func }, s.headings),
    ['@markup.heading.3'] = style({ fg = c.type }, s.headings),
    ['@markup.heading.4'] = style({ fg = c.number }, s.headings),
    ['@markup.heading.5'] = style({ fg = c.annotation }, s.headings),
    ['@markup.heading.6'] = style({ fg = c.fg_dim }, s.headings),
    ['@markup.strong'] = { fg = c.fg, bold = true },
    ['@markup.italic'] = { fg = c.preproc, italic = true },
    ['@markup.underline'] = { underline = true },
    ['@markup.strikethrough'] = { strikethrough = true },
    ['@markup.link'] = { fg = c.accent_alt, underline = true },
    ['@markup.link.label'] = { fg = c.string },
    ['@markup.link.url'] = { fg = c.accent_alt, underline = true },
    ['@markup.list'] = { fg = c.keyword },
    ['@markup.list.checked'] = { fg = c.ok },
    ['@markup.list.unchecked'] = { fg = c.fg_dim },
    ['@markup.quote'] = style({ fg = c.comment }, s.comments),
    ['@markup.math'] = { fg = c.number },
    ['@markup.environment'] = { fg = c.module },
    ['@markup.raw'] = { fg = c.string },
    ['@markup.raw.block'] = { fg = c.fg, bg = c.bg_line },

    ['@diff.plus'] = { fg = c.diff_add_fg },
    ['@diff.minus'] = { fg = c.diff_del_fg },
    ['@diff.delta'] = { fg = c.diff_chg_fg },

    ['@none'] = { fg = c.fg },
    ['@conceal'] = { link = 'Conceal' },
    ['@error'] = { link = 'Error' },
  }
end

return M
