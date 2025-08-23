-- lazy.bootstrap

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.api.nvim_echo({
    {
      'installing lazy.nvim, the modern plugin manager for neovim...\n',
      'WarningMsg',
    },
    {
      'Press any key to continue...\n',
      'MoreMsg',
    },
  }, true, {})

  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })

  vim.fn.getchar()
end

-- add lazy.nvim to runtimepath
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup({
  spec = {
    { import = 'me.plugins' },
    { import = 'me.plugins.lsp.servers.golang' },
    { import = 'me.plugins.lsp.servers.python' },
    { import = 'me.plugins.lsp.servers.typescript' },
    { import = 'me.plugins.lsp.servers.bashlsp' },
    { import = 'me.plugins.lsp.servers.markdown' },
  },
  defaults = { lazy = false },
  install = { colorscheme = { 'retrobox' } },
  checker = { enabled = false },
  ui = {
    browser = Core.env.get('BROWSER', 'firefox'),
  },
  diff = {
    cmd = 'terminal_git',
  },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        'gzip',
        -- 'matchit',
        -- "matchparen",
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
