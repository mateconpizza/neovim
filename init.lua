_G.Core = require('me.core')

Core.config = require('me.config')
Core.config.options.setup()
Core.config.lazy.setup()

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    Core.config.autocmd.setup()
    Core.config.keybinds.setup()
    Core.commands.setup()
    Core.lsp.setup()
  end,
})

vim.cmd.colorscheme('retrobox.nvim')
