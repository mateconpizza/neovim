_G.Core = require('me.core')

Core.config = require('me.config')
Core.config.options.setup()
Core.config.lazy.setup()
Core.ui.winbar.setup({
  enabled = true,
  file_icon = true,
  show_single_buffer = true,
  git_branch = true,
  lsp_status = false,
  diagnostics = {
    enabled = true,
    mini = true,
    bug_icon = '',
    show_detail = true,
  },
})

-- testing...
-- Core.lspp.load_registered()
-- Core.lspp.setup()
-- Core.utils.create_floating_window({ lines = Core.lspp.content, width = 100, height = 25 })

-- built-in theme
-- require('me.config.colorscheme').load_highlight_mods()
-- require('me.config.colorscheme').setup()

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    Core.config.autocmd.setup()
    Core.config.keybinds.setup()
    Core.commands.setup()
  end,
})
