local set = vim.opt_local
set.expandtab = true
set.tabstop = 4
set.shiftwidth = 4

if vim.g.colors_name == 'gruvbox-material' then
  Core.hi['@constant.bash'] = { link = 'PurpleItalic' }
  Core.hi['@keyword.conditional.bash'] = { link = 'RedItalic' }
  Core.hi['@keyword.exception.bash'] = { link = 'RedItalic' }
  Core.hi['@keyword.loop.bash'] = { link = 'RedItalic' }
  Core.hi['@keyword.return.bash'] = { link = 'RedItalic' }
  Core.hi['@keyword.repeat.bash'] = { link = 'RedItalic' }
  Core.hi['@keyword.import.bash'] = { link = 'RedItalic' }
  Core.hi['@keyword.function.bash'] = { link = 'RedItalic' }
  Core.hi['@keyword.bash'] = { link = 'RedItalic' }
end
