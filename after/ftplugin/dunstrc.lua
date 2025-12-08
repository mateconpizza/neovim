vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  group = Core.augroup('dunstrc'),
  pattern = { 'dunstrc' },
  command = '!dunst-ts -r',
  desc = 'reload dunstrc after buffer write',
})
