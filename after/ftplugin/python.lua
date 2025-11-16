local hl = vim.api.nvim_set_hl

vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4

if vim.g.colors_name == 'gruvbox-material' then
  hl(0, '@constant.python', { link = 'Purple', default = true })
  hl(0, '@keyword.return.python', { link = 'RedItalic', default = true })
  hl(0, '@keyword.conditional.python', { link = 'RedItalic', default = true })
  hl(0, '@keyword.exception.python', { link = 'RedItalic', default = true })
  hl(0, '@keyword.python', { link = 'RedItalic', default = true })
end

-- set debugger
if Core.manager.has_plugin('dap-python') then
  local dap = require('dap-python')
  Core.keymap('<leader>dp', '', '+python')
  Core.keymap('<leader>dpm', dap.test_method, 'python: test method')
  Core.keymap('<leader>dpc', dap.test_class, 'python: test class')
  Core.keymap('<leader>dpd', dap.debug_selection, 'python: debug selection')
end
