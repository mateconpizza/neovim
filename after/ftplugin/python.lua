vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4

if vim.g.colors_name == 'gruvbox-material' then
  local c = Core.colors.get_colors()
  Core.hi['@lsp.typemod.variable.readonly.python'] = { link = '@constant.python' }
  Core.hi.RedItalic = { fg = c.normal.red, italic = true, default = true }
  Core.hi['@keyword.return.python'] = { link = 'RedItalic' }
  Core.hi['@keyword.conditional.python'] = { link = 'RedItalic' }
  Core.hi['@keyword.exception.python'] = { link = 'RedItalic' }
  Core.hi['@keyword.python'] = { link = 'RedItalic' }
end

-- set debugger
if Core.manager.has_plugin('dap-python') then
  local dap = require('dap-python')
  Core.keymap('<leader>dp', '', '+python')
  Core.keymap('<leader>dpm', dap.test_method, 'python: test method')
  Core.keymap('<leader>dpc', dap.test_class, 'python: test class')
  Core.keymap('<leader>dpd', dap.debug_selection, 'python: debug selection')
end
