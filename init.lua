_G.Core = require('me.core')
_G.Config = require('me.config')

-- Core.lspp.load_registered()
-- Core.lspp.setup()
-- Core.utils.create_floating_window({ lines = Core.lspp.content, width = 100, height = 25 })

Config.options.setup()
require('me.config.lazy')

-- Setup WinBar
Core.ui.winbar.setup({
  enabled = true,
  file_icon = false,
  show_single_buffer = false,
  git_branch = false,
  lsp_status = false,
  diagnostics = {
    show_detail = false,
  },
})

-- require('me.config.colorscheme').load_highlight_mods()
-- require('me.config.colorscheme').setup()

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    require('me.config.autocmd')
    require('me.config.keymaps')
  end,
})
