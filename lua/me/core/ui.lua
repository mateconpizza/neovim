---@class me.core.ui

---@param name string
---@param val any
local function set_hl(name, val)
  vim.api.nvim_set_hl(0, name, val)
end

local M = {}

function M.winbar()
  set_hl('WinBar', { bold = true, italic = true })
  set_hl('WinBarNC', { bold = false, italic = true })

  -- show only > 1 buffer
  local all_buffers = vim.tbl_filter(function(buf)
    return vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) ~= ''
  end, vim.api.nvim_list_bufs())
  if #all_buffers < 2 then
    return ''
  end

  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == '' then
    return ''
  end

  local filename = vim.fn.fnamemodify(bufname, ':t')
  all_buffers = vim.api.nvim_list_bufs()

  local duplicates = 0
  for _, buf in ipairs(all_buffers) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      if vim.fn.fnamemodify(name, ':t') == filename then
        duplicates = duplicates + 1
      end
    end
  end

  if duplicates > 1 then
    -- Show parent folder and filename
    local dir = vim.fn.fnamemodify(bufname, ':h:t')
    return '%=' .. dir .. '/' .. filename .. ' '
  else
    return '%=' .. filename .. ' '
  end
end

return M
