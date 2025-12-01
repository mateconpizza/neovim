---@class me.core.log
local M = {
  _debug = false,
}

function M.debug_enable()
  M._debug = true
end
function M.debug_disable()
  M._debug = false
end
function M.debug_toggle()
  M._debug = not M._debug
end

local function split_args(prefix, msg)
  if prefix and not msg then return nil, prefix end
  return prefix, msg
end

local function echo(prefix, msg, default_msg, hl)
  prefix, msg = split_args(prefix, msg)

  local messages = {}
  if prefix then table.insert(messages, { prefix, 'LogPrefixMsg' }) end
  table.insert(messages, { msg or default_msg, hl })

  vim.api.nvim_echo(messages, true, {})
end

---@param prefix? string optional prefix
---@param msg? string if omitted, prefix becomes the message
function M.info(prefix, msg)
  echo(prefix, msg, 'i Info', 'LogInfoMsg')
end

---@param prefix? string optional prefix
---@param msg? string if omitted, prefix becomes the message
function M.success(prefix, msg)
  echo(prefix, msg, '✓ Success', 'LogSuccessMsg')
end

---@param prefix? string optional prefix
---@param msg? string if omitted, prefix becomes the message
function M.warning(prefix, msg)
  echo(prefix, msg, '! Warning', 'LogWarningMsg')
end

---@param prefix? string optional prefix
---@param msg? string if omitted, prefix becomes the message
function M.error(prefix, msg)
  echo(prefix, msg, '✗ Error', 'LogErrorMsg')
end

---@param prefix? string optional prefix
---@param msg? string if omitted, prefix becomes the message
function M.debug(prefix, msg)
  if not M._debug then return end
  echo(prefix, msg, '· Debug', '')
end

return M
