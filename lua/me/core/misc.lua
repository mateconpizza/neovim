---@class me.core.misc
local M = {}

-- inserts a banner using toilet
M.banner = function()
  if not Core.is_executable('toilet') then
    error('banner: toilet is not installed')
    return
  end

  local s = vim.fn.input({ prompt = 'banner> ' })
  local output = vim.fn.system('echo "' .. s .. '" | toilet -f future')

  local comment_prefix = vim.bo.commentstring
  comment_prefix = comment_prefix:gsub('%s%%s', ' ')

  local lines = vim.split(output, '\n', { trimempty = true })
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

  -- add comment prefix
  for i, line in ipairs(lines) do
    lines[i] = comment_prefix .. line
  end

  vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, lines)
end

return M
