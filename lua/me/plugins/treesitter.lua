-- treesitter.lua
local parsers = {
  'asm',
  'bash',
  'c',
  'cmake',
  'cpp',
  'css',
  'html',
  'printf',
  'query',
  'rasi',
  'regex',
  'rust',
  'sql',
  'ssh_config',
  'toml',
  'vim',
  'vimdoc',
  'xresources',
  'yaml',
  'zathurarc',
  -- lua
  'lua',
  'luadoc',
  'luap',
  -- json
  'json',
  'json5',
  'jsonc',
}

-- stylua: ignore start
local parser_list = {
  -- main
  'asm', 'bash', 'c', 'cmake',
  'cpp', 'css', 'html', 'printf',
  'query', 'rasi', 'regex', 'rust',
  'sql', 'ssh_config', 'toml', 'vim',
  'vimdoc', 'xresources', 'yaml', 'zathurarc',
  -- git
  'diff', 'git_rebase', 'gitattributes',
  'gitcommit', 'gitignore', 'git_config',
  -- golang
  'go', 'gomod', 'gowork', 'gosum', 'gotmpl',
  -- lua
  'lua', 'luadoc', 'luap',
  -- markdown
  'markdown', 'markdown_inline',
  -- javascript|typescript
  'tsx', 'javascript', 'typescript',
  -- python
  'ninja', 'python', 'rst',
  'toml', 'requirements',
  -- json
  'json', 'json5', 'jsonc',
}
-- stylua: ignore end

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
  { -- https://github.com/windwp/nvim-ts-autotag
    'windwp/nvim-ts-autotag',
    enabled = true,
    opts = {
      aliases = {
        ['gotmpl'] = 'html',
      },
    },
  },
}
