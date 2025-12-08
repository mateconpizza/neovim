Core.lsp.on_attach(function(_, bufnr)
  -- keymaps
  Core.lsp.keymaps(bufnr)

  -- diagnostics
  vim.diagnostic.config(Core.lsp.diagnostic.defaults)

  -- clean lsp-log if > 1024K
  local logpath = Core.env.xdg_state_home() .. '/nvim/' .. 'lsp.log'
  Core.utils.gc_logfile(logpath, 2048)
end)

Core.lsp.register({
  'basedpyright',
  'bashls',
  'cssls',
  'dartls',
  'docker_compose_language_service',
  'gopls',
  'harper_ls',
  'jsonls',
  'lua_ls',
  'marksman',
  'ruff',
  'taplo',
  'texlab',
  'vtsls',
  'yamlls',
  'vimls',
  'clangd',
})
