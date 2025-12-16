_G.P = function(v)
  print(vim.inspect(v))
  return v
end

local c = Core.colors
local p = Core.colors.current()
Core.hi.LogPrefixMsg = { fg = c.darken(p.extras.gray, 0.45, p.bg), bold = true }
Core.hi.LogInfoMsg = { fg = p.bright.blue }
Core.hi.LogSuccessMsg = { fg = p.bright.green }
Core.hi.LogWarningMsg = { fg = p.bright.yellow }
Core.hi.LogErrorMsg = { fg = p.bright.red }

local hl = vim.api.nvim_get_hl(0, { name = 'CurrentWord' })
if vim.tbl_isempty(hl) then
  Core.hi.CurrentWord =
    { bg = Core.colors.darken(p.base.dark0_soft, 0.28, p.base.dark0_soft), italic = true, bold = true }
end
