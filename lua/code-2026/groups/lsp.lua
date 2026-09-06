local style = require('code-2026.util').style

local M = {}

---@param c table<string, string>
---@param o Dark2026Config
---@return table<string, table>
function M.get(c, o)
  local s = o.styles

  return {
    -- Semantic tokens
    ['@lsp.type.class'] = { link = '@type' },
    ['@lsp.type.enum'] = { link = '@type' },
    ['@lsp.type.interface'] = { link = '@type' },
    ['@lsp.type.struct'] = { link = '@type' },
    ['@lsp.type.type'] = { link = '@type' },
    ['@lsp.type.typeParameter'] = { link = '@type' },
    ['@lsp.type.decorator'] = { link = '@attribute' },
    ['@lsp.type.parameter'] = { link = '@variable.parameter' },
    ['@lsp.type.variable'] = { link = '@variable' },
    ['@lsp.type.property'] = { link = '@property' },
    ['@lsp.type.function'] = { link = '@function' },
    ['@lsp.type.method'] = { link = '@function.method' },
    ['@lsp.type.namespace'] = { link = '@module' },
    ['@lsp.type.comment'] = { link = '@comment' },
    ['@lsp.type.keyword'] = { link = '@keyword' },
    ['@lsp.type.operator'] = { link = '@operator' },
    ['@lsp.type.string'] = { link = '@string' },
    ['@lsp.type.number'] = { link = '@number' },
    ['@lsp.type.regexp'] = { link = '@string.regexp' },
    ['@lsp.type.enumMember'] = style({ fg = c.constant }, s.constants),
    ['@lsp.type.macro'] = style({ fg = c.macro }, s.macros),
    ['@lsp.type.const'] = style({ fg = c.constant }, s.constants),
    ['@lsp.type.const.rust'] = style({ fg = c.constant }, s.constants),
    ['@lsp.type.selfKeyword'] = { link = '@variable.builtin' },
    ['@lsp.type.builtinType'] = { link = '@type.builtin' },

    ['@lsp.typemod.variable.readonly'] = { link = '@constant' },
    ['@lsp.typemod.variable.defaultLibrary'] = { link = '@variable.builtin' },
    ['@lsp.typemod.function.defaultLibrary'] = { link = '@function.builtin' },
    ['@lsp.typemod.type.defaultLibrary'] = { link = '@type.builtin' },
    ['@lsp.typemod.const.static'] = style({ fg = c.constant }, s.constants),
    ['@lsp.typemod.const.constant'] = style({ fg = c.constant }, s.constants),
    ['@lsp.typemod.keyword.async'] = { link = '@keyword.coroutine' },
    ['@lsp.mod.deprecated'] = { strikethrough = true },

    -- LSP UI
    LspReferenceText = { bg = c.bg_widget },
    LspReferenceRead = { bg = c.bg_widget },
    LspReferenceWrite = { bg = c.bg_widget, underline = true },
    LspReferenceTarget = { bg = c.bg_widget },
    LspSignatureActiveParameter = { fg = c.param, bold = true },
    LspCodeLens = { fg = c.fg_muted, italic = true },
    LspCodeLensSeparator = { fg = c.fg_muted },
    LspInlayHint = { fg = c.fg_muted, bg = c.bg_line },
    LspInfoBorder = { fg = c.border_alt, bg = c.bg_float },

    -- Diagnostics
    DiagnosticError = { fg = c.err },
    DiagnosticWarn = { fg = c.warn },
    DiagnosticInfo = { fg = c.info },
    DiagnosticHint = { fg = c.hint },
    DiagnosticOk = { fg = c.ok },

    DiagnosticSignError = { fg = c.err },
    DiagnosticSignWarn = { fg = c.warn },
    DiagnosticSignInfo = { fg = c.info },
    DiagnosticSignHint = { fg = c.hint },
    DiagnosticSignOk = { fg = c.ok },

    DiagnosticFloatingError = { fg = c.err },
    DiagnosticFloatingWarn = { fg = c.warn },
    DiagnosticFloatingInfo = { fg = c.info },
    DiagnosticFloatingHint = { fg = c.hint },
    DiagnosticFloatingOk = { fg = c.ok },

    DiagnosticUnderlineError = { undercurl = true, sp = c.err },
    DiagnosticUnderlineWarn = { undercurl = true, sp = c.warn },
    DiagnosticUnderlineInfo = { undercurl = true, sp = c.info },
    DiagnosticUnderlineHint = { undercurl = true, sp = c.hint },
    DiagnosticUnderlineOk = { undercurl = true, sp = c.ok },

    DiagnosticVirtualTextError = { fg = c.err, bg = c.err_bg },
    DiagnosticVirtualTextWarn = { fg = c.warn, bg = c.warn_bg },
    DiagnosticVirtualTextInfo = { fg = c.info, bg = c.info_bg },
    DiagnosticVirtualTextHint = { fg = c.hint, bg = c.hint_bg },
    DiagnosticVirtualTextOk = { fg = c.ok, bg = c.bg_normal },

    DiagnosticUnnecessary = { fg = c.fg_muted },
    DiagnosticDeprecated = { fg = c.fg_dim, strikethrough = true },
  }
end

return M
