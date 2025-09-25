---@class me.core.defaults
local M = {}

M.wildignore = {
  '*/node_modules/*',
  '*/.git/*',
  '*/dist/*',
}

M.bigfile = {
  enabled = true,
  threshold = 1024 * 1024, -- 1MB
}

M.exclude_filetypes = {
  'aerial',
  'dap-float',
  'fugitive',
  'git',
  'help',
  'checkhealth',
  'man',
  'neotest-output',
  'neotest-output-panel',
  'neotest-summary',
  'netrw',
  'qf',
  'startuptime',
}

return M
