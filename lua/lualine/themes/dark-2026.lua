local c = require('dark-2026').colors()

local function mode(color)
  return { fg = c.bg, bg = color, gui = 'bold' }
end

local inactive = { fg = c.fg_muted, bg = c.bg_alt }

return {
  normal = {
    a = mode(c.accent),
    b = { fg = c.fg, bg = c.bg_menu },
    c = { fg = c.fg_dim, bg = c.bg_alt },
  },
  insert = { a = mode(c.regex) },
  visual = { a = mode(c.func) },
  replace = { a = mode(c.keyword) },
  command = { a = mode(c.annotation) },
  terminal = { a = mode(c.type) },
  inactive = { a = inactive, b = inactive, c = inactive },
}
