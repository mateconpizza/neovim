_G.Core = require('me.core')

-- Core.lspp.load_registered()
-- Core.lspp.setup()
-- Core.utils.create_floating_window({ lines = Core.lspp.content, width = 100, height = 25 })

require('me.config.options')
require('me.config.lazy')
-- require('me.config.colorscheme').load_highlight_mods()
-- require('me.config.colorscheme').setup()

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    require('me.config.autocmd')
    require('me.config.keymaps')
  end,
})
