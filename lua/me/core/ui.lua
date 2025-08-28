---@class me.core.ui

---@param name string
---@param val any
local function set_hl(name, val)
  vim.api.nvim_set_hl(0, name, val)
end

local icons = {
  bug = Core.icons.dap.signs.breakpoint,
  modified = Core.icons.all().ui.MidCircle,
}

local M = {}

function M.get_diagnostics()
  local diag = vim.diagnostic
  local errors = #diag.get(0, { severity = diag.severity.ERROR })
  local warnings = #diag.get(0, { severity = diag.severity.WARN })
  local hints = #diag.get(0, { severity = diag.severity.HINT })
  local info = #diag.get(0, { severity = diag.severity.INFO })

  local formatted_str = ''
  if errors ~= 0 then
    formatted_str = formatted_str .. tostring(errors)
  end
  if warnings ~= 0 then
    formatted_str = formatted_str .. tostring(warnings)
  end
  if hints ~= 0 then
    formatted_str = formatted_str .. tostring(hints)
  end
  if info ~= 0 then
    formatted_str = formatted_str .. tostring(info)
  end

  return formatted_str
end

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

  -- Check if buffer is modified (unsaved)
  local modified_indicator = vim.bo.modified and icons.modified .. ' ' or ''

  -- Get diagnostics
  local diagnostics = M.get_diagnostics()
  local diagnostic_indicator = diagnostics ~= '' and icons.bug .. ' ' or ''

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
    -- Show parent folder and filename with indicators
    local dir = vim.fn.fnamemodify(bufname, ':h:t')
    return '%=' .. diagnostic_indicator .. modified_indicator .. dir .. '/' .. filename .. ' '
  else
    return '%=' .. diagnostic_indicator .. modified_indicator .. filename .. ' '
  end
end

return M
