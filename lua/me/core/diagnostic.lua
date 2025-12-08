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

function M.show_buffer_diagnostics()
  local bufnr = vim.api.nvim_get_current_buf()
  local diagnostics = vim.diagnostic.get(bufnr)

  if #diagnostics == 0 then
    vim.notify('diagnostic: no diagnostics found for current buffer', vim.log.levels.INFO)
    return
  end

  vim.diagnostic.setqflist({
    title = 'Current File Diagnostics',
    context = 0,
    id = bufnr,
  })

  vim.cmd('copen')
end

-- copy diagnostic message from current cursor position
function M.yank()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
  if #diagnostics == 0 then
    vim.notify('No diagnostic here', vim.log.levels.INFO)
    return
  end

  local msg = diagnostics[1].message
  vim.fn.setreg('+', msg)
  vim.notify('copied diagnostic: ' .. msg, vim.log.levels.INFO)
end

return M
