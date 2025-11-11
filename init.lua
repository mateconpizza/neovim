_G.Core = require('me.core')

Core.config = require('me.config')
Core.config.options.setup()
Core.config.lazy.setup()

-- testing...
-- Core.lspp.load_registered()
-- Core.lspp.setup()
-- Core.utils.create_floating_window({ lines = Core.lspp.content, width = 100, height = 25 })

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    Core.config.autocmd.setup()
    Core.config.keybinds.setup()
    Core.commands.setup()
  end,
})
