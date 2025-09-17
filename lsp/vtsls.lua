-- https://github.com/yioneko/vtsls
---@type vim.lsp.Config

local findAll = function()
  Core.lsp.execute({
    command = 'typescript.findAllFileReferences',
    arguments = { vim.uri_from_bufnr(0) },
    open = true,
  })
end

return {
  cmd = { 'vtsls', '--stdio' },
  root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = 'always' },
      suggest = {
        completeFunctionCalls = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = 'literals' },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil
    Core.keymap_buf(bufnr, '<leader>lt', '', '+typescript')
    Core.keymap_buf(bufnr, '<leader>ltf', findAll, 'File References')
    Core.keymap_buf(bufnr, '<leader>lto', Core.lsp.action['source.organizeImports'], 'Organize Imports')
    Core.keymap_buf(bufnr, '<leader>ltm', Core.lsp.action['source.addMissingImports.ts'], 'Add missing imports')
    Core.keymap_buf(bufnr, '<leader>ltu', Core.lsp.action['source.removeUnused.ts'], 'Remove unused imports')
    Core.keymap_buf(bufnr, '<leader>ltF', Core.lsp.action['source.fixAll.ts'], 'Fix all diagnostics')
  end,
}
