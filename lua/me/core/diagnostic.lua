---@class me.core.lsp.diagnostic
local M = {}
local icons = Core.icons.lsp.diagnostics.filled

---@param diagnostic vim.Diagnostic
---@return string
local dformat = function(diagnostic)
  local code = diagnostic.code or diagnostic.source
  return string.format('%s: %s', code, diagnostic.message)
end

M.defaults = {
  virtual_lines = false,
  -- virtual_lines = {
  --   current_line = false,
  --   ---@param diagnostic vim.Diagnostic
  --   format = dformat,
  -- },
  -- virtual_text = false,
  virtual_text = {
    spacing = 4,
    source = 'if_many',
    current_line = true,
    -- prefix = '■',
    -- format = dformat,
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.Error,
      [vim.diagnostic.severity.WARN] = icons.Warn,
      [vim.diagnostic.severity.HINT] = icons.Hint,
      [vim.diagnostic.severity.INFO] = icons.Info,
    },
  },
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
}

return M
