---@class Config
---@field options me.config.options
---@field keybinds me.config.keybinds
---@field autocmd me.config.autocmds
---@field lazy me.config.lazy
local M = {}

setmetatable(M, {
  __index = function(tbl, key)
    tbl[key] = require('me.config.' .. key)
    return tbl[key]
  end,
})

return M
