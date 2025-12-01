---@class me.core.treesitter
local M = {}

M.parsers = {}

M.text_objects_keymaps = function()
  local map = Core.keymap
  -- stylua: ignore start
  -- select
  local select = require('nvim-treesitter-textobjects.select').select_textobject
  map('af', function() select('@function.outer', 'textobjects') end, 'select outer function', { 'x', 'o' })
  map('if', function() select('@function.inner', 'textobjects') end, 'select inner function', { 'x', 'o' })
  map('ac', function() select('@class.outer', 'textobjects') end, 'select outer class', { 'x', 'o' })
  map('ic', function() select('@class.inner', 'textobjects') end, 'select inner class', { 'x', 'o' })
  map('as', function() select('@local.scope', 'locals') end, 'select local scope', { 'x', 'o' })
  -- move
  local move = require("nvim-treesitter-textobjects.move")
  local opts = { 'n', 'x', 'o' }
  map(']f', function() move.goto_next_start("@function.outer", "textobjects") end, 'move next function', opts)
  map('[f', function() move.goto_previous_start("@function.outer", "textobjects") end, 'move previous function', opts)
  map(']c', function() move.goto_next_start("@class.outer", "textobjects") end, 'move next class', opts)
  map('[c', function() move.goto_previous_start("@class.outer", "textobjects") end, 'move previous class', opts)
  -- map(']d', function() move.goto_next("@conditional.outer", "textobjects") end, 'move next conditional',  opts) <- interferes with diagnostic
  -- map('[d', function() move.goto_previous("@conditional.outer", "textobjects") end, 'move previous conditional', opts) <- interferes with diagnostic
  -- swap
  -- local ts_swap = require("nvim-treesitter-textobjects.swap")
  -- map('<leader>a', function() ts_swap.swap_next("@parameter.inner") end, 'swap next')
  -- map('<leader>A', function() ts_swap.swap_previous("@parameter.outer") end, 'swap next')
  -- stylua: ignore end
end

---@param parsers string[]
M.add = function(parsers)
  vim.list_extend(M.parsers, parsers)
end

M.setup = function()
  local ok, ts = pcall(require, 'nvim-treesitter')
  if not ok then
    Core.log.warning('treesitter: ', 'nvim-treesitter not found')
    return
  end

  M.parsers = Core.utils.deduplicate(M.parsers)
  ts.install(M.parsers)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = M.parsers,
    callback = function()
      vim.treesitter.start()
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })
end

return M
