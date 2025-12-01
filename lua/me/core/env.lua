---@class me.core.env
local M = {}

local HOME = os.getenv('HOME')

---@param varname string
---@param default any: if varname is not set
---@return any
function M.getenv(varname, default)
  -- TODO: checkout `vim.env`
  Core.log.warning('Core.env.getenv: deprecated')
end

---@param varname string
---@param default any: if varname is not set
---@return string
function M.get(varname, default)
  local value = os.getenv(varname)
  if not value then return default end
  return value
end

---@param varname string
---@return boolean
M.enabled = function(varname)
  return Core.utils.boolme(M.get(varname, false))
end

---@return string?
M.xdg_home = function()
  return HOME
end

---@return string
M.xdg_data_home = function()
  -- FIX: vim.fn.stdpath('data')
  return M.get('XDG_DATA_HOME', HOME .. '/.local/share')
end

---@return string
M.xdg_state_home = function()
  -- FIX: vim.fn.stdpath('state')
  return M.get('XDG_STATE_HOME', HOME .. '/.local/state')
end

---@return string
M.xdg_config_home = function()
  -- FIX: vim.fn.stdpath('config')
  return M.get('XDG_CONFIG_HOME', HOME .. '/.config')
end

---@return string
M.xdg_cache_home = function()
  -- FIX: vim.fn.stdpath('cache')
  return M.get('XDG_CACHE_HOME', HOME .. '/.cache')
end

M.debug = M.enabled('NVIM_DEBUG')
M.testing = M.enabled('NVIM_TEST')
M.dadbod = M.enabled('NVIM_DBUI')

return M
