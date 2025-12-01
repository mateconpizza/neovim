_G.P = function(v)
  print(vim.inspect(v))
  return v
end

local c = Core.colors.is_darkmode() and Core.colors.gruvbox_dark_medium() or Core.colors.gruvbox_light_medium()
Core.hi.LogPrefixMsg = { fg = c.extras.gray, bold = true }
Core.hi.LogInfoMsg = { fg = c.bright.blue }
Core.hi.LogSuccessMsg = { fg = c.bright.green }
Core.hi.LogWarningMsg = { fg = c.bright.yellow }
Core.hi.LogErrorMsg = { fg = c.bright.red }
