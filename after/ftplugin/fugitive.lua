vim.opt_local.laststatus = 0
vim.api.nvim_create_autocmd('FileType', {
  group = Core.augroup('fugitive_doom'),
  pattern = '*fugitive*',
  callback = function(args)
    if not vim.b[args.buf].fugitive_x_disabled then
      Core.log.debug('[autocmd] ', 'fugitive_X disabled')
      vim.keymap.set('n', 'X', '<Nop>', { buffer = args.buf, silent = true })
      vim.b[args.buf].fugitive_x_disabled = true
    end
  end,
  desc = 'disable X (discard changes) in fugitive buffers',
})
