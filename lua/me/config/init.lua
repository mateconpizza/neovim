---@class Config
---@field options me.config.options
local M = {}

setmetatable(M, {
  __index = function(tbl, key)
    tbl[key] = require('me.config.' .. key)
    return tbl[key]
  end,
})

return M
