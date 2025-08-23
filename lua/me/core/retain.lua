---@class me.core.retain

vim.g.retained = {}

-- Permanently stop `value` from getting garbage-collected.
--
-- @generic T
-- @param value T
-- @return T
local retain = function(value)
  vim.g.retained[#vim.g.retained + 1] = value
  return value
end

return retain
