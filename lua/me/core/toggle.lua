---@class me.core.toggle
local M = {}
local minimalist = false
local maximize = {
  toggle = false,
  restore_cmd = nil,
}

function M.statusline()
  ---@diagnostic disable-next-line: undefined-field
  local laststatus = vim.opt_local.laststatus._value
  vim.opt_local.laststatus = vim.tbl_contains({ '0' }, tostring(laststatus)) and 0 or 3
end

function M.laststatus()
  local choice = Core.input('which statusline?> ')
  vim.opt_local.laststatus = tonumber(choice)
end

function M.numbers()
  ---@diagnostic disable-next-line: undefined-field
  local enabled = not Core.utils.boolme(vim.opt_local.relativenumber._value)
  vim.opt_local.number = enabled
  vim.opt_local.relativenumber = enabled
end

function M.signcolumn()
  ---@diagnostic disable-next-line: undefined-field
  if Core.utils.boolme(vim.opt_local.signcolumn._value) then
    vim.opt_local.signcolumn = 'no'
    return
  end
  vim.opt_local.signcolumn = 'yes'
end

function M.gitsings()
  M.signcolumn()
  require('gitsigns').toggle_signs()
end

function M.minimalist()
  minimalist = not minimalist
  if minimalist then
    vim.opt_local.relativenumber = true
    vim.opt_local.number = true
    vim.opt_local.laststatus = 3
    vim.opt_local.signcolumn = 'yes'
  else
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.opt_local.laststatus = 0
    vim.opt_local.signcolumn = 'no'
  end
end

function M.diagnostic_signs()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

function M.inlay_hints()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

function M.scrollsync()
  vim.cmd('set scb!')
end

function M.fmt_on_save()
  vim.g.enable_autoformat = not vim.g.enable_autoformat
  vim.print('toggle autofmt: ' .. tostring(vim.g.enable_autoformat))
end

-- function M.maximize()
--   local win = vim.api.nvim_get_current_win()
--   maximize.toggle = not maximize.toggle
--
--   if maximize.toggle then
--     maximize.state.height = vim.api.nvim_win_get_height(win)
--     maximize.state.width = vim.api.nvim_win_get_width(win)
--     vim.cmd('wincmd |') -- maximize window width
--     vim.cmd('wincmd _') -- maximize window height
--   else
--     vim.api.nvim_win_set_height(win, maximize.state.height)
--     vim.api.nvim_win_set_width(win, maximize.state.width)
--   end
-- end

function M.maximize()
  maximize.toggle = not maximize.toggle

  if maximize.toggle then
    -- save full window layout
    maximize.restore_cmd = vim.fn.winrestcmd()

    -- maximize current window
    vim.cmd('wincmd |')
    vim.cmd('wincmd _')
  else
    if maximize.restore_cmd then vim.cmd(maximize.restore_cmd) end
  end
end

return M
