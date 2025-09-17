---@class me.core.ui
---@field winbar me.core.ui.winbar
---@field utils me.core.ui.utils

local M = {}

setmetatable(M, {
  __index = function(tbl, key)
    tbl[key] = require('me.core.ui.' .. key)
    return tbl[key]
  end,
})

return M
