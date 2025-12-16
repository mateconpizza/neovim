-- treesitter.lua

-- syntax aware text-objects, select, move, swap, and peek support.
local textobjects = {
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  enabled = true,
  config = Core.treesitter.text_objects_keymaps,
}

-- show code context
-- local tscontext = {
--   'https://github.com/nvim-treesitter/nvim-treesitter-context',
--   opts = { enabled = false },
--   cmd = { 'TSContextEnable', 'TSContextDisable', 'TSContextToggle' },
-- }

return {
  { -- nvim treesitter configurations and abstraction layer
    'https://github.com/nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
    branch = 'main',
    version = false,
    enabled = true,
    lazy = false,
    build = ':TSUpdate',
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    dependencies = { textobjects }, --, tscontext },
    config = Core.treesitter.setup,
  },
  -- { -- https://github.com/windwp/nvim-ts-autotag
  --   'windwp/nvim-ts-autotag',
  --   enabled = false,
  --   opts = {
  --     aliases = {
  --       ['gotmpl'] = 'html',
  --     },
  --   },
  -- },
}
