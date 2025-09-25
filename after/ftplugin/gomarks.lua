local set = vim.opt_local
set.laststatus = 0
set.showtabline = 0
set.wrap = true
set.textwidth = 79

local option = vim.api.nvim_set_option_value
option('textwidth', 79, { scope = 'local' })
option('colorcolumn', '+0', { scope = 'local' })
-- set.syntax = 'on'
-- set.filetype = 'conf'
-- vim.cmd.colorscheme('retrobox')
