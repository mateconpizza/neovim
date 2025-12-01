---@type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    '.git',
  },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
      },
      codeLens = {
        enable = true,
      },
      completion = {
        callSnippet = 'Replace',
      },
      doc = {
        privateName = { '^_' },
      },
      semantic = {
        enable = false,
      },
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        paramName = 'Disable',
        semicolon = 'Disable',
        arrayIndex = 'Disable',
      },
    },
  },
  on_attach = function(_, bufnr)
    Core.keymap_buf(bufnr, '<leader>dL', '', '+lua')
    Core.keymap_buf(bufnr, '<leader>dLs', function()
      require('osv').launch({ port = 8086 })
    end, 'start lua debugging')
  end,
}
