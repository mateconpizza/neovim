---@class me.core.manager
local M = {}

-- get plugin from lazy
---@param name string
function M.get_loaded_plugin(name)
  return require('lazy.core.config').spec.plugins[name]
end

-- checks if a plugin is installed
---@param plugin string
---@return boolean
function M.has_plugin(plugin)
  local ok, _ = pcall(require, plugin)
  return ok
end

return M
