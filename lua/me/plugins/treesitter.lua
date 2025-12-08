-- treesitter.lua
local textobjects = { -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/tree/main
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  enabled = true,
  config = Core.treesitter.text_objects_keymaps,
}

local tscontext = { -- https://github.com/nvim-treesitter/nvim-treesitter-context
  'nvim-treesitter/nvim-treesitter-context',
  opts = { enabled = true },
  cmd = { 'TSContextEnable', 'TSContextDisable', 'TSContextToggle' },
}

return {
  { -- https://github.com/nvim-treesitter/nvim-treesitter/tree/main
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
    branch = 'main',
    version = false,
    enabled = true,
    lazy = false,
    build = ':TSUpdate',
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    dependencies = { textobjects, tscontext },
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
